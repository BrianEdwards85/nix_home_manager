{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        theme = {
          activeBorderColor = [ "#ff9e64" "bold" ];
          inactiveBorderColor = [ "#29a4bd" ];
          searchingActiveBorderColor = [ "#ff9e64" "bold" ];
          optionsTextColor = [ "#7aa2f7" ];
          selectedLineBgColor = [ "#2e3c64" ];
          cherryPickedCommitFgColor = [ "#7aa2f7" ];
          cherryPickedCommitBgColor = [ "#bb9af7" ];
          markedBaseCommitFgColor = [ "#7aa2f7" ];
          markedBaseCommitBgColor = [ "#e0af68" ];
          unstagedChangesColor = [ "#db4b4b" ];
          defaultFgColor = [ "#c0caf5" ];
        };
      };
      services = {
        "code.corp.indeed.com" = "gitlab:code.corp.indeed.com";
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never --syntax-theme=tokyonight_storm";
        };
        pagers = {
          colorArg = "always";
          pager = "delta --dark --paging=never --syntax-theme=tokyonight_storm";
        };
        commitPrefix = [
          {
            pattern = "^\\w+\\/(\\w+-\\w+).*";
            replace = "$1: ";
          }
        ];
      };
    };
  };
}
