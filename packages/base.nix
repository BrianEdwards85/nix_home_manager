# Base packages - always installed
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat                         # Cat clone with syntax highlighting
    btop                        # Resource monitor (CPU, memory, disks)
    byobu                       # Text-based window manager and terminal multiplexer
    delta                       # Syntax-highlighting pager for git diffs
    eza                         # Modern replacement for ls
    fzf                         # Fuzzy finder for command line
    git                         # Distributed version control system
    git-worktree-switcher       # Tool to easily switch between git worktrees
    ranger                      # Console file manager with vi keybindings
    starship                    # Cross-shell customizable prompt
    zellij                      # Terminal workspace and multiplexer
  ];
}
