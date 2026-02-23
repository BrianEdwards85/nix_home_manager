# GUI applications and fonts
{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
#    blender
    alacritty                   # Cross-platform, GPU-accelerated terminal emulator
#    gimp
#    kitty                       # GPU-accelerated terminal emulator
    nerd-fonts.droid-sans-mono  # Droid Sans Mono with Nerd Font icons
    nerd-fonts.hack             # Hack font with Nerd Font icons
    nerd-fonts.ubuntu           # Ubuntu font with Nerd Font icons
    obsidian                    # Powerful knowledge base that works on top of a local folder of plain text Markdown files
    qmk                         # Quantum Mechanical Keyboard firmware toolkit
    vscode                      # 
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    pinentry_mac                # macOS PIN entry dialog for GPG
    terminal-notifier           # macOS notification utility
    rectangle
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    gnupg                       # GNU Privacy Guard encryption
    keymapviz                   # Keyboard layout visualization
    qmk_hid                     # QMK HID device utilities
    terminator                  # Terminal emulator with tiling
    vial                        # Open-source keyboard configurator
    httpie-desktop              # Cross-platform API testing client
    libnotify                   # Desktop notification library
  ];
}
