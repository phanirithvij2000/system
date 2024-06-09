{ pkgs, ... }:
{
  home.packages = [
    pkgs.gitbatch
    pkgs.hub
  ];
  programs = {
    lazygit = {
      enable = true;
      settings = {
        disableStartupPopups = true;
        git = {
          commit = {
            signOff = true;
          };
          paging = {
            colorArg = "always";
            pager = "${pkgs.delta} --dark --paging=never";
          };
        };
        gui = {
          showBottomLine = false;
          showCommandLog = true;
          showIcons = false;
          showListFooter = false;
          showRandomTip = false;
          theme = {
            showFileTree = true;
          };
        };
        notARepository = "quit";
        promptToReturnFromSubprocess = false;
      };
    };
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
