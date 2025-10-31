# Push filtered store paths to Cachix

def main [
  ...filters: string # Filter expressions to match store paths (e.g., "mcp-hub" "prettier" "vscode-json")
  --result-path: string = "./result"
] {
  let cache_name = "ck3mp3r"
  print $"🔍 Identifying store paths matching filters: ($filters | str join ', ')"

  # Get all store paths
  let all_paths = (^nix path-info --recursive $result_path | lines)

  # Apply filters to find matching paths
  let filtered_paths = (
    $all_paths | where {|path|
      $filters | any {|f| $path | str contains $f }
    }
  )

  if ($filtered_paths | is-empty) {
    print $"ℹ️  No paths found matching filters: ($filters | str join ', ')"
    return
  }

  print $"📦 Found ($filtered_paths | length) matching paths:"
  $filtered_paths | each {|path| print $"  - ($path | path basename)" }

  print $"\n⬆️  Pushing to cachix cache: ($cache_name)"

  # Push each path to Cachix
  $filtered_paths | each {|path|
    let basename = ($path | path basename)
    print $"  Pushing ($basename)..."
    try {
      ^cachix push $cache_name $path
    } catch {
      print $"❌ Failed to push ($basename)"
    }
  }

  print "✅ Cachix push complete!"
  print $"Users can now use: cachix use ($cache_name)"
}
