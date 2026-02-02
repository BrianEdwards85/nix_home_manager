# Development tools
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    emacs                       # Extensible text editor
    helix                       # Modal text editor inspired by Vim/Kakoune
    httpie                      # Command line HTTP client whose goal is to make CLI human-friendly
    jdt-language-server         # Java language server for IDE features
    lazydocker                  # Terminal UI for Docker management
    lazygit                     # Terminal UI for Git commands
    lazysql                     # Simple TUI for MySQL/MariaDB databases
    lua-language-server         # Lua language server for IDE features
    neovim                      # Hyperextensible Vim-based text editor
    nixfmt-tree                 # Nix code formatter (treefmt compatible)
    rainfrog                    # Database management TUI for Postgres
    rustup                      # Rust toolchain installer and manager
  ];
}
