# XVIM Portable Distribution Plan

## Problem Statement
Create a self-contained Neovim distribution that works on any system without Nix, avoiding npmjs.org dependencies in corporate environments.

## Core Principle
Use the existing Nix variables that already define what each component is, then copy those specific components to create a portable distribution.

## Why This Approach

**The Problem with Store References:**
- Store references give us a flat list of paths but no context about what each path is for
- We'd still need to guess or hardcode which paths are plugins vs tools vs config

**The Solution - Use Existing Nix Variables:**
- `${config}` - already points to the config 
- `${plugins.extraVars.plugin_path}` - already points to plugins
- `${plugins.extraVars.ts_parsers}` - already points to treesitter parsers
- `${plugins.extraVars.mcp_cli}` - already points to mcp hub binary
- `${pkgs.neovim}` - already points to neovim itself
- `${extraPackages}` - already lists all the tools for PATH

## Implementation Architecture

### Normal Build (No Regression)
- `nix build .#default` - works exactly as before
- `nix profile install .` - works exactly as before  
- Creates normal wrapper with nix store paths for local development

### CI Bundle Creation (Addition)
- Normal build creates a CI script as part of the wrapper package
- CI runs: `nix build .#default && ./result/bin/ci-extract.sh`
- CI script uses nix variables to extract portable distribution
- CI uploads the bundle tarball to GitHub releases

### Bundle Installation (New Target)
- `nix build .#install-from-release` - downloads and installs from GitHub release
- Fetches the portable bundle created by CI
- Installs as a local nix package that works without store dependencies

## Implementation Steps

### 1. Normal Wrapper + CI Script (wrapper.nix)
```nix
# Normal wrapper creation (unchanged)
cat > $out/bin/${appName} << EOF
  # existing wrapper with nix store paths
EOF

# Add CI extraction script
cat > $out/bin/ci-extract.sh << 'EXTRACT_EOF'
  # Copy using known nix variables:
  cp -r ${config} $BUILD_DIR/config/
  cp -r ${plugins.extraVars.plugin_path}/* $BUILD_DIR/plugins/
  cp -r ${plugins.extraVars.ts_parsers} $BUILD_DIR/parsers/
  # etc...
EXTRACT_EOF
```

### 2. GitHub Workflow
```yaml
- name: Build XVIM
  run: nix build .#default
- name: Extract portable bundle  
  run: ./result/bin/ci-extract.sh
- name: Upload to release
  run: gh release upload latest build/xvim-*.tar.gz
```

### 3. Install-from-Release Package
```nix
install-from-release = pkgs.stdenv.mkDerivation {
  src = pkgs.fetchurl {
    url = "https://github.com/ck3mp3r/xvim/releases/download/latest/xvim-bundle.tar.gz";
    # Downloads the CI-created portable bundle
  };
  # Extracts and installs as local package
};
```

## Missing Components to Implement

### 1. Lazy.nvim Inclusion
- **Critical**: Must copy `${pkgs.vimPlugins.lazy-nvim}` to bundle
- Without this, the entire plugin system won't work
- Add to CI script: `cp -r ${pkgs.vimPlugins.lazy-nvim} $BUILD_DIR/lazy-nvim/`

### 2. Runtime Path Setup  
- Portable wrapper needs proper neovim runtime path
- Must include config, lazy-nvim, and neovim's own runtime
- Add: `--cmd "set runtimepath^=$XVIM_ROOT/config,$XVIM_ROOT/lazy-nvim,$XVIM_ROOT/neovim/share/nvim/runtime"`

### 3. Environment Variables
- **TOPIARY setup**: `export TOPIARY_CONFIG_FILE` and `TOPIARY_LANGUAGE_DIR`
- Copy topiary files: `cp -r ${pkgs.topiary-nu} $BUILD_DIR/topiary/`
- **PATH setup**: `export PATH="$XVIM_ROOT/tools:$PATH"`

### 4. Error Handling & Verification
- CI script needs proper error checking after each copy operation
- Verify critical files exist before packaging
- Test that extracted bundle actually works: `$BUILD_DIR/bin/xvim --version`

### 5. File Permissions
- Handle read-only nix store files: `chmod -R +w $BUILD_DIR` before cleanup
- Ensure copied files are writable in extracted bundle

### 6. Tool Dependencies
- Some tools might need libraries - verify all required shared libraries are included
- Check that tools work in isolation: test key tools after extraction

### 7. Complete CI Script Template
```bash
# Copy all components with error checking
cp -r ${config} $BUILD_DIR/config/ || exit 1
cp -r ${pkgs.vimPlugins.lazy-nvim} $BUILD_DIR/lazy-nvim/ || exit 1
cp -r ${pkgs.topiary-nu} $BUILD_DIR/topiary/ || exit 1
# ... etc for all components

# Verify critical files exist
test -f $BUILD_DIR/tools/nvim || { echo "nvim missing"; exit 1; }
test -d $BUILD_DIR/config || { echo "config missing"; exit 1; }

# Test the bundle works
$BUILD_DIR/bin/xvim --version || { echo "Bundle test failed"; exit 1; }
```

## Key Insight
**The Nix build system already knows what each component is via variables - use that knowledge instead of trying to reverse-engineer it from store references.**

## Expected Outcome
- ~100-200MB portable tarball (instead of 8GB closure)
- Works on systems with the **same architecture** as the build system (aarch64 or x86_64)
- Contains exactly the runtime dependencies needed
- Simple installation: extract and run

## Architecture Limitation
**Critical**: The portable distribution only works on the same architecture where it was built:
- Building on Apple Silicon (aarch64) → only works on aarch64 systems
- Building on Intel/AMD (x86_64) → only works on x86_64 systems

For true cross-platform support, you'd need separate builds for each architecture.