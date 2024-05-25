{...}: {
  imports = [
    ./specialisations.nix
  ];
  # had to do sudo su hydra no password required
  # su - hydra asked for password
  # su; passwd hydra to set one, but sudo su works
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@iron";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };
}
