# Non Indeed Development tools
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_24                   # Event-driven I/O framework for the V8 JavaScript engine
    python315
  ];
}
