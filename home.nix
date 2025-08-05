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
    packages = import nixgl { inherit pkgs; };

    defaultWrapper = "nvidiaPrime";
    installScripts = [
      "nvidia"
      "nvidiaPrime"
    ];
    prime.card = "2";
  };

  # disabled to prevent issues when running home-manager for the first time
  news.display = "silent";

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

    keyboard = {
      layout = "eu";
    };

    # TODO: Find a way to ignore the steam.pipe file and whatever is in the ibus cache.
    # TODO: Find a way to load settings.json file from within flake-based home-manager config
    file = {
      ".oh-my-custom/janis.zsh-theme" = {
        enable = true;
        source = ./sources/janis.zsh-theme;
      };
    };

    packages = with pkgs; [
      # cli / terminal
      htop
      unzip
      cowsay
      nnn
      jq
      xclip
      # fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      # programming
      rustc
      rustup
      nixfmt-rfc-style
      # gui apps:
      _1password-gui
      _1password-cli
      spotify
      audacity
      libva-utils
      # Programs below are wrapped with nixGL to support OpenGL and Vulkan applications
      # TODO: Find a way to support firefox and thunderbird with custom options AND gpu support
      (config.lib.nixGL.wrap thunderbird)
      # (config.lib.nixGL.wrap steam)
      # (config.lib.nixGL.wrap gdlauncher-carbon)
      # (config.lib.nixGL.wrap discord)
      # (config.lib.nixGL.wrap warp-terminal)
      (config.lib.nixGL.wrap libreoffice)
      (config.lib.nixGL.wrap teams-for-linux)
      # (config.lib.nixGL.wrap chromium)
    ];
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    firefox = {
      enable = true;
      package = (config.lib.nixGL.wrap pkgs.firefox-bin);
      nativeMessagingHosts = [
        pkgs.firefoxpwa
      ];
    };

    keepassxc = {
      enable = true;
    };

    vscode = {
      package = (config.lib.nixGL.wrap pkgs.vscode);
      enable = true;
      mutableExtensionsDir = false;

      profiles.default = {
        enableExtensionUpdateCheck = true;
        enableUpdateCheck = true;
        userSettings = {
          "workbench.iconTheme" = "vscode-icons";
          "vsicons.dontShowNewVersionMessage" = true;

          "terminal.integrated.fontFamily" = "JetBrainsMono NFP";
          "terminal.integrated.defaultProfile.linux" = "zsh";

          "editor.stickyScroll.enabled" = true;

          "workbench.editor.wrapTabs" = true;
          "workbench.colorTheme" = "One Dark Pro Night Flat";

          "git.enableSmartCommit" = true;
          "git.confirmSync" = false;
          "git.autofetch" = true;

          # Error lense is too noisy for some files/types
          "errorLens.excludeBySource" = [ "cSpell" ];
          "errorLens.excludePatterns" = [ "**/*.{ts,tsx,js}" ];

          # Formatter configs
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "editor.inlineSuggest.enabled" = true;

          "[xml]" = {
            "editor.defaultFormatter" = "redhat.vscode-xml";
          };
          "[yaml]" = {
            "editor.defaultFormatter" = "redhat.vscode-yaml";
          };
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
          "[mdx]" = {
            "editor.defaultFormatter" = "unifiedjs.vscode-mdx";
          };
          "[astro]" = {
            "editor.defaultFormatter" = "astro-build.astro-vscode";
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
          github.copilot-chat
          eamodio.gitlens
          usernamehw.errorlens
          ms-azuretools.vscode-docker
          redhat.vscode-yaml
          redhat.vscode-xml
          rust-lang.rust-analyzer
          unifiedjs.vscode-mdx
          mechatroner.rainbow-csv
          astro-build.astro-vscode
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
            "key" = "ctrl+f4";
            "command" = "workbench.action.closeActiveEditor";
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
      defaultSettings = {
        corePlugins = [
          "audio-recorder"
          "backlink"
          "bookmarks"
          "canvas"
          "command-palette"
          "daily-notes"
          "editor-status"
          "file-explorer"
          "file-recovery"
          "global-search"
          "graph"
          "note-composer"
          "outgoing-link"
          "outline"
          "page-preview"
          "slides"
          "sync"
          "switcher"
          "tag-pane"
          "templates"
          "word-count"
        ];
        appearance = {
          "accentColor" = "#e68122";
          "interfaceFontFamily" = "Fira Code";
          "textFontFamily" = "Fira Code";
        };
      };
      vaults = {
        janis = {
          enable = true;
          target = ".obsidian/janis";
        };
        cognigy = {
          enable = true;
          target = ".obsidian/cognigy";
        };
      };
    };

    lazygit = {
      enable = true;
    };

    eza = {
      enable = true;
      icons = "auto";
    };

    zellij = {
      enable = true;
      # enableZshIntegration = true;
      # attachExistingSession = true;
      settings = {
        copy_command = "xclip -selection clipboard";
        show_startup_tips = false;
        simplified_ui = true;
        default_shell = "zsh";
        theme = "onedark";
        default_layout = "janis";
      };
      layouts = {
        janis = {
          layout = {
            _children = [
              {
                default_tab_template = {
                  _children = [
                    {
                      pane = {
                        size = 1;
                        borderless = true;
                        plugin = {
                          location = "zellij:tab-bar";
                        };
                      };
                    }
                    { "children" = { }; }
                    {
                      pane = {
                        size = 1;
                        borderless = true;
                        plugin = {
                          location = "zellij:status-bar";
                        };
                      };
                    }
                  ];
                };
              }
              {
                tab = {
                  _props = {
                    name = "main";
                    split_direction = "vertical";
                  };
                  _children = [
                    {
                      pane = {
                        _props = {
                          size = "20%";
                          name = "files";
                          cwd = "/";
                        };
                        plugin = {
                          cwd = "/";
                          location = "zellij:strider";
                        };
                      };
                    }
                    {
                      pane = {
                        _props = {
                          size = "80%";
                          name = "zsh";
                        };
                        command = "zsh";
                      };
                    }
                  ];
                };
              }
              {
                tab = {
                  _props = {
                    name = "git";
                  };
                  _children = [
                    {
                      pane = {
                        _props = {
                          name = "lazygit";
                        };
                        command = "zsh";
                      };
                    }
                  ];
                };
              }
              {
                tab = {
                  _props = {
                    name = "sys";
                    split_direction = "horizontal";
                  };
                  _children = [
                    {
                      pane = {
                        _props = {
                          name = "htop";
                          size = "60%";
                        };
                        command = "zsh";
                      };
                    }
                    {
                      pane = {
                        _props = {
                          name = "nvidia";
                          size = "40%";
                        };
                        command = "zsh";
                      };
                    }
                  ];
                };
              }
            ];
          };
        };
      };
    };

    bat = {
      enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      envExtra = ''
        setxkbmap eu
      '';
      oh-my-zsh = {
        enable = true;
        custom = "$HOME/.oh-my-custom";
        plugins = [
          "git"
          "eza"
          "fzf"
          "nvm"
          "npm"
          "helm"
          "kubectl"
          "docker"
          ""
        ];
        theme = "janis";
      };
      initContent = lib.mkOrder 1000 ''
        export NVM_DIR="$([ -z "''${XDG_CONFIG_HOME-}" ] && printf %s "''${HOME}/.nvm" || printf %s "''${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

        alias switch='home-manager switch --impure --flake ~/.nixconfig/.#default'
        alias sync-obsidian='(cd ~/.obsidian && git pull && git add -A && git commit -m "$(date "+%A %W %Y %X")" && git push) &'
        alias tree="l -TR"
        alias cat="bat -p"
        alias f="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

        # Cognigy config:
        alias deploy='~/Documents/code/cognigy/scripts/deploy.sh'
        alias destroy='~/Documents/code/cognigy/scripts/destroy.sh'
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
