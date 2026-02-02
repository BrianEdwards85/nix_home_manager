{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        pagers = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        commitPrefix = {
          pattern = "^\\w+\\/(\\w+-\\w+).*";
          replace = "$1: ";
        };
      };
    };
  };
}