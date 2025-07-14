{
  config,
  pkgs,
  lib,
  nixgl,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixGL = {
    packages = import nixgl {
      inherit pkgs;
    };
    defaultWrapper = "nvidia";
    installScripts = [ "nvidia" ];
    vulkan.enable = true;
  };

  # disabled to prevent issues when running home-manager for the first time
  news.display = "silent";

  fonts.fontconfig = {
    enable = true;
  };

  home = {
    username = "janis";
    homeDirectory = "/home/janis";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "25.05"; # Please read the comment before changing.

    sessionVariables = {
      EDITOR = "code";
    };

    # TODO: Find a way to ignore the steam.pipe file and whatever is in the ibus cache.
    # TODO: Find a way to load settings.json file from within flake-based home-manager config
    file = {
      # ".config/code/User/settings.json" = {
      #   enable = true;
      #   text = builtins.readFile "${src}/sources/vscode/settings.json";
      # };
    };

    packages = with pkgs; [
      # cli / terminal
      htop
      unzip
      cowsay
      nnn
      jq
      eza
      docker
      # fonts
      jetbrains-mono
      fira-code
      # programming
      nodejs_24
      python313
      rustc
      rustup
      nixfmt-rfc-style
      # gui apps:
      _1password-gui
      _1password-cli
      spotify
      audacity
      # Programs below are wrapped with nixGL to support OpenGL and Vulkan applications
      # TODO: Find a way to support firefox and thunderbird with custom options AND gpu support
      (config.lib.nixGL.wrap firefox)
      (config.lib.nixGL.wrap thunderbird)
      (config.lib.nixGL.wrap steam)
      (config.lib.nixGL.wrap gdlauncher-carbon)
      (config.lib.nixGL.wrap discord)
      (config.lib.nixGL.wrap warp-terminal)
    ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    vscode = {
      package = (config.lib.nixGL.wrap pkgs.vscode);
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
          "errorLens.excludeBySource" = [ "cSpell" ];
          "errorLens.excludePatterns" = [ "**/*.{ts,tsx,js}" ];

          "vsicons.dontShowNewVersionMessage" = true;

          "[xml]" = {
            "editor.defaultFormatter" = "redhat.vscode-xml";
          };
          "[yaml]" = {
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
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
          usernamehw.errorlens
          ms-azuretools.vscode-docker
          redhat.vscode-yaml
          redhat.vscode-xml
          rust-lang.rust-analyzer
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
          {
            "key" = "shift+alt+f";
            "command" = "editor.action.formatDocument";
            "when" =
              "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor";
          }
        ];
        globalSnippets = {
          "functionalComponent" = {
            "prefix" = "ffc";
            "body" = [
              "export default function \${1:\${TM_FILENAME_BASE}}() {"
              "  return ("
              "    <div>\${1:first}</div>"
              "  )"
              "}"
              ""
            ];
            "description" = "Creates a React Functional Component";
            "scope" = "typescript,typescriptreact,javascript,javascriptreact";
          };
          "functionalComponentWithProps" = {
            "prefix" = "ffcp";
            "body" = [
              "export interface \${1:\${TM_FILENAME_BASE}}Props {"
              ""
              "}"
              ""
              "export default function \${1:first}({}: \${1:first}Props) {"
              "  return ("
              "    <div>\${1:first}</div>"
              "  )"
              "}"
              ""
            ];
            "description" = "Creates a React Functional Component and TypeScript interface for Props";
            "scope" = "typescript,typescriptreact,javascript,javascriptreact";
          };
          "penguinImportComponents" = {
            "prefix" = "penc";
            "body" = [
              "import { Components as Dive } from '@dive-solutions/penguin';"
            ];
            "description" = "Imports components from Penguin as 'dive'";
            "scope" = "typescript,typescriptreact,javascript,javascriptreact";
          };
          "LocalStyleImport" = {
            "prefix" = "fcs";
            "body" = [
              "import './\${TM_FILENAME_BASE}.scss';"
            ];
            "description" = "Imports a stylesheet file named like the component";
            "scope" = "typescript,typescriptreact,javascript,javascriptreact";
          };
          "barrelFileExport" = {
            "prefix" = "fcexp";
            "body" = [
              "import \${1:\${TM_DIRECTORY/^.+\\/(.*)$/$1/}} from './\${1:Component}';"
              ""
              "export default \${1:Component};"
            ];
            "description" = "Imports and exports a component based on the parent folder name";
            "scope" = "typescript,typescriptreact,javascript,javascriptreact";
          };
          "penguinImportStyles" = {
            "prefix" = "pens";
            "body" = [
              "@use '@dive-solutions/penguin/scss/\${1:colors}';"
            ];
            "description" = "Adds an import for a penguin scss file, 'colors' by default";
            "scope" = "scss,css";
          };
          "classForFunctionalComponent" = {
            "prefix" = "fcc";
            "body" = [
              ".\${TM_FILENAME_BASE/([A-Z][a-z]+$)|((^|[A-Z])[a-z]+)/\${1:/downcase}\${2:/downcase}\${2:+-}/gm} {"
              "  $0"
              "}"
            ];
            "description" =
              "Adds a class name that's named after the file. Ex: 'MyComponent' -> '.my-component'";
            "scope" = "scss,css";
          };
        };
      };
    };

    obsidian = {
      enable = true;
    };

    tmux = {
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

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "asdf"
        ];
        theme = "agnoster";
      };
      initContent = lib.mkOrder 1000 ''
        alias ll='ls -la'
        alias e='eza'
        alias switch='home-manager switch --impure --flake ~/.nixconfig/.#default'
        echo "welcome :)"
      '';
    };

    git = {
      enable = true;
      userName = "Janis Jansen";
      userEmail = "oss@janis.me";
    };

    ssh = {
      enable = true;
    };
  };
}
