{ ... }:
{
  flake.modules.homeManager.base-packages =
    # Base packages - always installed
    { pkgs, ... }:

    {
      home.packages =
        with pkgs;
        [
          #    bintools                    # Tools for manipulating binaries
          btop # Resource monitor (CPU, memory, disks)
          #    byobu                       # Text-based window manager and terminal multiplexer
          gcc # GNU Compiler Collection
          delta # Syntax-highlighting pager for git diffs
          emacs # Extensible text editor
          fd # Simple, fast and user-friendly alternative to find
          fzf # Fuzzy finder for command line
          git # Distributed version control system
          git-worktree-switcher # Tool to easily switch between git worktrees
          helix # Modal text editor inspired by Vim/Kakoune
          neovim # Hyperextensible Vim-based text editor
          #openscad                    # 3D parametric model compiler
          openscad-unstable # 3D parametric model compiler
          ranger # Console file manager with vi keybindings
          #    wezterm                     # GPU-accelerated cross-platform terminal emulator and multiplexer written by @wez and implemented in Rust
          uutils-coreutils # Cross-platform Rust rewrite of the GNU coreutils --uutils-coreutils-noprefix
          yazi # Blazing fast terminal file manager written in Rust, based on async I/O
          zoxide # Fast cd command that learns your habits
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          #    uutils-coreutils-noprefix
          gnupg # GNU Privacy Guard encryption
          unixtools.net-tools # Network utilities like ifconfig, netstat, route, etc.
        ];
    };
}
