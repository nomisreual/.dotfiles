{ config, pkgs, ... }:

{
  # Allow unfree software:
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # User account details:
  home.username = "simon";
  home.homeDirectory = "/home/simon";
  home.stateVersion = "24.05";

  # Git
  programs.git = {
    enable = true;
    userName = "Simon Antonius Lauer";
    userEmail = "simon.lauer@posteo.de";
    extraConfig = {
      init = {
        defaultbranch = "main";
      };
      core = {
        editor = "nvim";
      };
    };
  };


  # User packages:
  home.packages = with pkgs; [
    vim
    neovim
    slack
    _1password-gui
    thunderbird
    poetry
    sqlite
    neofetch
    htop
    stow
    (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  # Enable home manager to manage fonts:
  fonts.fontconfig.enable = true;

  home.file = {
  };

  home.sessionVariables = {
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
