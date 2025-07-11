{ config, pkgs, lib, ... }:

{
#  nixpkgs.config.allowUnfreePredicate = pkg:
#    builtins.elem (lib.getName pkg) [
#      # Add additional package names here
#      "vscode"
#    ];

  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "janis";
  home.homeDirectory = "/home/janis";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.htop
    pkgs.unzip
    pkgs.cowsay
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nodejs_24
    pkgs.python313
    pkgs.nnn
  ];

  home.sessionVariables = {
    EDITOR = "code";
  };

  home.file = {
    # ".tool-versions".source = ./sources/.tool-versions;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default = {
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = true;
      userSettings = {
          "workbench.iconTheme" = "vscode-icons";
          "editor.defaultFormatter" = "esbenp.prettier-vscode";

          "terminal.integrated.fontFamily" = "JetBrainsMono NFP";
          "terminal.integrated.defaultProfile.linux" = "zsh";

          "editor.formatOnSave" = true;
          "editor.stickyScroll.enabled" = true;

          "workbench.editor.wrapTabs" = true;
          "workbench.colorTheme" = "One Dark Pro Night Flat";

          # Error lense is too noisy for some files/types
          "errorLens.excludeBySource" = ["cSpell"];
          "errorLens.excludePatterns" = ["**/*.{ts,tsx,js}"];

          "vsicons.dontShowNewVersionMessage" = true;
      };
      extensions = [
        pkgs.vscode-extensions.tamasfe.even-better-toml
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.zhuangtongfa.material-theme
        pkgs.vscode-extensions.esbenp.prettier-vscode
        pkgs.vscode-extensions.vscode-icons-team.vscode-icons
        pkgs.vscode-extensions.github.vscode-github-actions
        pkgs.vscode-extensions.github.copilot
        pkgs.vscode-extensions.eamodio.gitlens
      ];
      keybindings = [
        {
          "key" = "ctrl+[Semicolon]";
          "command" = "workbench.action.terminal.new";
        }
        {
          "key" = "ctrl+[Semicolon]";
          "command" = "workbench.action.terminal.new";
        }
        {
          "key" = "ctrl+shift+down";
          "command" = "editor.action.duplicateSelection";
        }
        {
          "key" = "ctrl+alt+g ctrl+alt+g";
          "command" = "gitlens.showGraphPage";
        }
      ];
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "asdf" ];
      theme = "robbyrussell";
    };
  };

  programs.git = {
    enable = true;
    userName = "Janis Jansen";
    userEmail = "oss@janis.me";
  };

  programs.ssh = {
    enable = true;
  };
}
