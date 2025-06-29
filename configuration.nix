# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

# Define my python package lists
let
  username = "nixbookpro";
  userdescription = "Midori's Macbook Pro";
  myPython = pkgs.python3.withPackages (ps: with ps; [
    pip
    requests
  ]);
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  programs.firefox.enable = false;
  programs.thunar.enable = true;
  # programs.home-manager.enable = true;
  programs.starship.enable = true;
  programs.hyprland.enable = true;
  services.displayManager.ly.enable = true;
 
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # udevmon
  services.udev.extraRules = ''
    KERNEL=="event*", NAME="input/%k", MODE="660", GROUP="input"
  '';

  # Nixbook Pro Fn -> Esc Hack
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
      - JOB: 'intercept -g $DEVNODE | dual-function-keys -c /etc/interception-tools/dual-function-keys.yaml | uinput -d $DEVNODE'
        DEVICE:
          NAME: ".*"
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK]
    '';
  };

  environment.etc."interception/dual-function-keys.yaml".text = ''
    TIMING:
      TAP_MILLISEC: 200
      DOUBLE_TAP_MILLISEC: 0

    MAPPINGS:
      - KEY: KEY_CAPSLOCK
        TAP: KEY_ESC
	HOLD: KEY_LEFTCTRL
  '';

  # Make input group for udevmon
  users.groups.input = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    description = "${userdescription}";
    shell = pkgs.zsh; 
    extraGroups = [ "networkmanager" "wheel" "input"];
    packages = with pkgs; [];
  };

  # systemd.services.udevmon = {
  #   description = "udevmon";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.interception-tools}/bin/udevmon -c /etc/interception/udevmon.yaml";
  #   };
  # };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ 
	# Fetching stuff from the web
	wget
	curl

	# Dev stuff
	ghostty
	git
	vscode
	# neovim	# Hold off until dual function caps lock works

	# Diagnostic utils
	dysk
	btop
	libnotify

	# Stack
	google-chrome
	starship
	ly	# Display manager
	yazi	# CLI file nav
	waybar	# Info bar at the top
	neofetch	# Is an explanation needed for this?
	rofi-wayland	# Launcher
	materia-theme	# Makes other GTK apps look nice

	# System essentials
	dunst	# Notification daemon
	brightnessctl
	wl-clipboard
	cliphist
	pavucontrol
	mpv
	hyprshot
	hyprpicker
	hypridle
	hyprlock
	hyprpaper
	networkmanagerapplet
	blueman	

	# Used for setting up dual function Caps Lock key
	interception-tools
	interception-tools-plugins.dual-function-keys

	# List of python packages
	myPython
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
  };

  # Theme for GTK apps
  environment.variables = {
 	GTK_THEME = "Materia-dark";
	XDG_CURRENT_DESKTOP = "Hyprland";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
