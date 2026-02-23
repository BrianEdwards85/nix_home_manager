# Base packages - always installed
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat                         # Cat clone with syntax highlighting
    btop                        # Resource monitor (CPU, memory, disks)
#    byobu                       # Text-based window manager and terminal multiplexer
    delta                       # Syntax-highlighting pager for git diffs
    emacs                       # Extensible text editor
    eza                         # Modern replacement for ls
    fish                        # Smart and user-friendly command line shell
    fzf                         # Fuzzy finder for command line
    git                         # Distributed version control system
    git-worktree-switcher       # Tool to easily switch between git worktrees
#    helix                       # Modal text editor inspired by Vim/Kakoune
    neovim                      # Hyperextensible Vim-based text editor
    ranger                      # Console file manager with vi keybindings
    starship                    # Cross-shell customizable prompt
#    wezterm                     # GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust
    uutils-coreutils            # Cross-platform Rust rewrite of the GNU coreutils --uutils-coreutils-noprefix

    zellij                      # Terminal workspace and multiplexer
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    unixtools.net-tools         # Network utilities like ifconfig, netstat, route, etc.
  ];
}
