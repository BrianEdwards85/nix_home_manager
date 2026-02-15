{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
      };
      services = {
        "code.corp.indeed.com" = "gitlab:code.corp.indeed.com";
      };
      git = {
        pagers = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
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
