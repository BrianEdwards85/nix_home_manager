# Development tools
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    httpie                      # Command line HTTP client whose goal is to make CLI human-friendly
    jdt-language-server         # Java language server for IDE features
    lazydocker                  # Terminal UI for Docker management
    lazygit                     # Terminal UI for Git commands
    lazysql                     # Simple TUI for MySQL/MariaDB databases
    lua-language-server         # Lua language server for IDE features
    nixfmt-tree                 # Nix code formatter (treefmt compatible)
    rainfrog                    # Database management TUI for Postgres
    rustup                      # Rust toolchain installer and manager
    uv                          # Extremely fast Python package installer and resolver, written in Rust
  ];
}
