# system
main system configuration including dotfiles, will recreate repo with private dotfiles removed and then make it public

## TODO
- [ ] modular restructuring
    - allows enabling disabling things
    - hardware-configuration.nix needs to be untouched
    - [ ] disko
    - [ ] binfmt etc can be in different files
    - flake schemas is a new halted rfc because of the Elco
- [ ] systemd profiles
    - multiple generations which each act as a profile
    - generations can be named I watched this on a youtube video
        - find that link?
- [ ] jupyenv/jupyterhub/jupyterlab
- [ ] flake compat, working with default.nix and shell.nix
- [ ] flake templates, need to learn
- [ ] Wayland external monitor sleeping bug workaround
    - New user works but need to somehow make /home/rithvij move to the new user
    - I did remove .cache didn't help, tried using default vals for all configs of plamsa
        didn't help
    - so the bug is hard to track down given I know nothing about plasma
- [ ] Separate home-manager to work on non-nixos
- [ ] initial installation setup for nixos and non-nixos linux
    - Scripts and writeups
    - Bootstrapping nix
        - Comes with iso for nixos minimal iso
        - DeterminateSystems nix installer on non-nixos
    - Bootstrapping home-manager
        - `nix run home-manager/master --extra-experimental-features "nix-command flakes" -- switch --flake /home/rithvij/Projects/system#rithvij`
        - To bootstrap home.nix config [see here](https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-standalone)
            - `nix run home-manager/master -- init #--switch`
- [ ] ssh keys, ssh certs
- [ ] tailscale on local instead of vps
    - also vps configuration in nix/dockerfiles separate repo?
    - rustdesk, syncplay, tailscale

