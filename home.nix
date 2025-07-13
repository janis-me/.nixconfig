{ config, pkgs, lib, nixgl, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixGL.packages = import nixgl {
    inherit pkgs;
  };
  nixGL.defaultWrapper = "nvidia";
  nixGL.installScripts = [ "nvidia" ];
  nixGL.vulkan.enable = true;

  xsession.enable = true;
  
  news.display = "silent";
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

  home.packages = with pkgs; [
    htop
    unzip
    cowsay
    nerd-fonts.jetbrains-mono
    nodejs_24
    python313
    nnn
    _1password-gui
    _1password-cli
    spotify
    (config.lib.nixGL.wrap firefox)
    (config.lib.nixGL.wrap thunderbird)
    (config.lib.nixGL.wrap steam)
    (config.lib.nixGL.wrap gdlauncher-carbon)
    (config.lib.nixGL.wrap discord)
  ];

  home.sessionVariables = {
    EDITOR = "code";
  };

  # TODO: Find a way to ignore the steam.pipe file and whatever is in the ibus cache.
  home.file = {
    ".steam/steam.pipe" = {
      enable = false;
      target = ".steam/steam.pipe";
    };
    ".cache/ibus" = {
      enable = false;
      recursive = true;
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # TODO: Find a way to support firefox and thunderbird with custom options AND gpu support
  # programs.firefox = {
  #   enable = true;
  #   package = (config.lib.nixGL.wrap pkgs.firefox);
  #   profiles = {
  #     janis = {
  #       isDefault = true;
  #     };
  #   };
  # };
  # programs.thunderbird = {
  #   enable = true;
  #   package = (config.lib.nixGL.wrap pkgs.thunderbird);
  #   profiles = {
  #     janis = {
  #       isDefault = true;
  #     };
  #   };
  # };

  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    prefix = "C-a";
    keyMode = "vi";
    extraConfig = ''
      bind o split-window -h
      bind i split-window -v
      unbind '"'
      unbind %
    '';
  };

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
      extensions = with pkgs.vscode-extensions; [
        tamasfe.even-better-toml
        jnoortheen.nix-ide
        zhuangtongfa.material-theme
        esbenp.prettier-vscode
        vscode-icons-team.vscode-icons
        github.vscode-github-actions
        github.copilot
        eamodio.gitlens
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
    initContent = lib.mkOrder 1000 ''
      alias ll='ls -la'
      alias switch='home-manager switch --impure --flake ~/.nixconfig/.#janis'
      echo "welcome :)"
    '';
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
