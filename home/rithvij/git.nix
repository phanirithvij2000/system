{ pkgs, ... }:
{
  home.packages = [
    pkgs.gitbatch
    pkgs.hub
  ];
  programs = {
    lazygit.enable = true; # godsend
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
    gh-dash.enable = true;

    git = {
      enable = true;
      userName = "phanirithvij";
      userEmail = "phanirithvij2000@gmail.com";
      delta.enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        url = {
          "https://github.com/" = {
            insteadOf = [
              "gh:"
              "github:"
            ];
          };
        };
      };
    };
  };
}
