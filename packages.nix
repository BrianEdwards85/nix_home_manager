{
  pkgs,
  lib,
  hostname,
  ...
}:

{
  home.packages = with pkgs; [
    bat                         # Cat clone with syntax highlighting
    btop                        # Resource monitor (CPU, memory, disks)
    delta                       # Syntax-highlighting pager for git diffs
    emacs                       # Extensible text editor
    esphome                     # ESP8266/ESP32 home automation firmware
    eza                         # Modern replacement for ls
    fzf                         # Fuzzy finder for command line
    helix                       # Modal text editor inspired by Vim/Kakoune
    jdt-language-server         # Java language server for IDE features
    kitty                       # GPU-accelerated terminal emulator
    lazydocker                  # Terminal UI for Docker management
    lazygit                     # Terminal UI for Git commands
    lua-language-server         # Lua language server for IDE features
    neovim                      # Hyperextensible Vim-based text editor
    nerd-fonts.droid-sans-mono  # Droid Sans Mono with Nerd Font icons
    nerd-fonts.hack             # Hack font with Nerd Font icons
    nerd-fonts.ubuntu           # Ubuntu font with Nerd Font icons
    nixfmt-tree                 # Nix code formatter (treefmt compatible)
    qmk                         # Quantum Mechanical Keyboard firmware toolkit
    rainfrog                    # Database management TUI for Postgres
    ranger                      # Console file manager with vi keybindings
    rustup                      # Rust toolchain installer and manager
    starship                    # Cross-shell customizable prompt
    zellij                      # Terminal workspace and multiplexer

    # Disabled packages
    # dysk                      # Disk usage analyzer
    # fldigi                    # Ham radio digital modes software
    # flrig                     # Ham radio rig control
    # gridtracker               # Ham radio WSJT-X companion
    # treefmt-nix               # Universal code formatter
    # uv                        # Python package installer
    # wsjtx                     # Weak signal ham radio communication
  ]
  ++ lib.optionals (hostname == "deck") [
    gnupg                       # GNU Privacy Guard encryption
    keymapviz                   # Keyboard layout visualization
    qmk_hid                     # QMK HID device utilities
    terminator                  # Terminal emulator with tiling
    vial                        # Open-source keyboard configurator
    vscode                      # Visual Studio Code editor
    zsh                         # Z shell

    # via                       # Keyboard configurator (proprietary)
  ]
  ++ lib.optionals (hostname == "IT-USA-VF3086") [
    pinentry_mac                # macOS PIN entry dialog for GPG
  ];
}
