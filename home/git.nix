{config, ...}: {
  programs.lazygit.enable = true; #godsend
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
  programs.gh-dash.enable = true;

  programs.git = {
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
}
