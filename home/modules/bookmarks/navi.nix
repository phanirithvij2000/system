{ navi_config, pkgs, ... }:
let
  naviOverlay = f: p: {
    navi = p.navi.overrideAttrs (old: rec {
      pname = "navi";
      version = "master";
      src = p.fetchFromGitHub {
        owner = "denisidoro";
        repo = "navi";
        rev = "52e90ad8f993c9db458915b681a3ddf165b8002b";
        hash = "sha256-8e2sbKc6eYDerf/q0JwS6GPXkqDXLerbPqWK6oemSqM=";
      };
      cargoDeps = old.cargoDeps.overrideAttrs (
        p.lib.const {
          name = "${pname}-vendor.tar.gz";
          inherit src;
          outputHash = "sha256-vNfcSHNP0KNM884DMtraYohLOvumSZnEtemJ+bJSQ5o=";
        }
      );
    });
  };
  navi = pkgs.navi;
in
{
  nixpkgs.overlays = [ naviOverlay ];
  programs.tealdeer.enable = true;
  programs.navi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      client = {
        tealdeer = true;
      };
    };
  };
  programs.bash.initExtra = ''
    if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
      ${navi}/bin/navi widget bash \
        | sed 's/_navi_widget/_navi_widget_currdir/g' \
        | sed 's/--print/--print --path "$PWD"/g' \
        | sed 's/C-g/C-j/g' \
        > /tmp/navi_eval.sh
      source /tmp/navi_eval.sh
    fi
  '';
  programs.zsh.initExtra = ''
    if [[ $options[zle] = on ]]; then
      ${navi}/bin/navi widget zsh \
        | sed 's/_navi_widget/_navi_widget_currdir/g' \
        | sed 's/--print/--print --path "$PWD"/g' \
        | sed 's/\^g/\^j/g'
        > /tmp/navi_eval.zsh
      source /tmp/navi_eval.zsh
    fi
  '';
  programs.fish.shellInit = ''
    ${navi}/bin/navi widget fish \
      | sed 's/--print/--print --path "$PWD"/g' \
      | sed 's/\\\\cg/\\\\cj/g' \
      | sed 's/_navi_smart_replace/_navi_smart_replace_currdir/g' \
      | source
  '';
  home.file.".local/share/navi/cheats/phanirithvij__navi" = {
    source = navi_config;
    recursive = true;
  };
}
