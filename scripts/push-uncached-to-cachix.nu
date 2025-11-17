#!/usr/bin/env nu

# Push store paths to Cachix that aren't already in upstream cache
def main [
  --cache: string = "ck3mp3r" # Cachix cache name
  --upstream: string = "https://cache.nixos.org" # Upstream cache to check against
  --flake: string = ".#" # Flake output to build
] {
  # Check if running in GitHub Actions
  let is_github = ($env.GITHUB_STEP_SUMMARY? | is-not-empty)
  let summary_file = if $is_github { $env.GITHUB_STEP_SUMMARY } else { null }

  # Helper to strip ANSI codes
  def strip-ansi []: string -> string {
    str replace -ra '\x1b\[[0-9;]*m' ''
  }

  # Helper to print to both stdout and summary
  def log [message: string --summary-only --no-summary] {
    if not $summary_only {
      print $message
    }
    if $is_github and ($summary_file | is-not-empty) and (not $no_summary) {
      let clean_msg = ($message | strip-ansi)
      $"($clean_msg)\n" | save --append $summary_file
    }
  }

  log $"(ansi cyan_bold)🔨 Building flake output: ($flake)(ansi reset)"

  # Build the flake
  let build_result = try {
    ^nix build $flake --json --no-link
    | complete
  } catch {
    log $"(ansi red_bold)❌ Failed to build flake(ansi reset)"
    return 1
  }

  if $build_result.exit_code != 0 {
    log $"(ansi red_bold)❌ Build failed:(ansi reset)"
    log $build_result.stderr
    return 1
  }

  log $"(ansi green)✓ Build successful(ansi reset)\n"

  # Get all recursive dependencies
  log $"(ansi cyan_bold)📦 Getting all recursive dependencies...(ansi reset)"
  let all_paths = (do { ^nix path-info --recursive $flake } | complete | get stdout | lines)
  let total_count = ($all_paths | length)
  log $"(ansi green)✓ Found ($total_count) total paths(ansi reset)\n"

  # Filter out paths already in upstream and cachix
  log $"(ansi cyan_bold)🔍 Checking which paths are in caches...(ansi reset)"
  log $"(ansi default_dimmed)   This may take a while...(ansi reset)\n"

  let path_status = (
    $all_paths | par-each {|path|
      let hash = ($path | path basename | split row '-' | first)

      let upstream_check = try {
        ^nix path-info --store $upstream $path
        | complete
      } catch {
        {exit_code: 1 stdout: "" stderr: ""}
      }

      # Check Cachix via HTTP (more reliable than nix path-info)
      let cachix_check = try {
        http head $"https://($cache).cachix.org/($hash).narinfo"
        {status: 200}
      } catch {
        {status: 404}
      }

      {
        path: $path
        in_upstream: ($upstream_check.exit_code == 0)
        in_cachix: ($cachix_check.status == 200)
      }
    }
  )

  let paths_to_push = ($path_status | where in_upstream == false and in_cachix == false | get path)
  let already_in_cachix = ($path_status | where in_cachix == true | length)
  let upstream_count = ($path_status | where in_upstream == true | length)
  let push_count = ($paths_to_push | length)

  log --no-summary $"(ansi green)✓ Already in upstream: ($upstream_count) paths(ansi reset)"
  log --no-summary $"(ansi blue)✓ Already in ($cache).cachix.org: ($already_in_cachix) paths(ansi reset)"
  log --no-summary $"(ansi yellow)⚠ Not in any cache: ($push_count) paths(ansi reset)\n"

  # Write summary in markdown format if in GitHub Actions
  if $is_github and ($summary_file | is-not-empty) {
    "## 📊 Cache Summary\n\n" | save --append $summary_file
    $"| Cache | Count |\n" | save --append $summary_file
    $"|-------|-------|\n" | save --append $summary_file
    $"| ✅ Already in upstream | ($upstream_count) |\n" | save --append $summary_file
    $"| ✅ Already in ($cache).cachix.org | ($already_in_cachix) |\n" | save --append $summary_file
    $"| ⚠️ Not in any cache | ($push_count) |\n\n" | save --append $summary_file
  }

  if $push_count == 0 {
    log $"(ansi green_bold)✅ Nothing to push - all store paths are already cached!(ansi reset)"
    if $already_in_cachix > 0 {
      log $"(ansi blue)   ($already_in_cachix) paths already in ($cache).cachix.org(ansi reset)"
    }
    return 0
  }

  # Show what will be pushed
  log --no-summary $"(ansi cyan_bold)📋 Paths to push:(ansi reset)"

  if $is_github and ($summary_file | is-not-empty) {
    "## 📦 Paths to Push\n\n" | save --append $summary_file
    $paths_to_push | each {|path|
      let name = ($path | path basename)
      print $"   • ($name)"
      $"- `($name)`\n" | save --append $summary_file
    }
  } else {
    $paths_to_push | each {|path|
      let name = ($path | path basename)
      print $"   • ($name)"
    }
  }
  print ""

  # Push to cachix
  log $"(ansi cyan_bold)⬆️  Pushing ($push_count) paths to ($cache).cachix.org...(ansi reset)\n"

  let push_result = try {
    $paths_to_push
    | str join "\n"
    | ^cachix push $cache
    | complete
  } catch {
    log $"(ansi red_bold)❌ Failed to push to cachix(ansi reset)"
    return 1
  }

  if $push_result.exit_code != 0 {
    log $"(ansi red_bold)❌ Cachix push failed:(ansi reset)"
    log $push_result.stderr
    return 1
  }

  log $push_result.stdout
  log $"\n(ansi green_bold)✅ Successfully pushed ($push_count) paths to ($cache).cachix.org!(ansi reset)"
  log $"(ansi default_dimmed)   Users can now use: cachix use ($cache)(ansi reset)"

  if $is_github and ($summary_file | is-not-empty) {
    $"\n## ✅ Success\n\nSuccessfully pushed **($push_count)** paths to `($cache).cachix.org`\n" | save --append $summary_file
  }

  return ""
}
