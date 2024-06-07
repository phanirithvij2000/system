{ navi_config, pkgs, ... }:
let
  navi = pkgs.navi;
in
{
  home.packages = [ pkgs.buku ];
  programs.navi = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };
  programs.bash.initExtra = ''
    if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
      eval "$(${navi}/bin/navi widget bash | sed 's/--print/--print --path \"\$PWD\"/g')"
    fi
  '';
  programs.zsh.initExtra = ''
    if [[ $options[zle] = on ]]; then
      eval "$(${navi}/bin/navi widget zsh | sed 's/--print/--print --path \"\$PWD\"/g')"
    fi
  '';
  programs.fish.shellInit = ''
    ${navi}/bin/navi widget fish | sed 's/--print/--print --path "$PWD"/g' | source
  '';
  home.file.".local/share/navi/cheats/phanirithvij__navi" = {
    source = navi_config;
    recursive = true;
  };
  programs.tealdeer.enable = true;
  services.espanso = {
    enable = true;
    # TODO config, matches
  };
}
