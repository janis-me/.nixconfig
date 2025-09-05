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
      unzip
      cowsay
      nnn
      jq
      xclip
      ffmpeg
      # fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      # programming
      rustc
      rustup
      nixfmt-rfc-style
      azure-cli
      snyk
      # gui apps:
      _1password-gui
      _1password-cli
      spotify
      audacity
      libva-utils
      pgadmin4
      # Programs below are wrapped with nixGL to support OpenGL and Vulkan applications
      # TODO: Find a way to support firefox and thunderbird with custom options AND gpu support
      (config.lib.nixGL.wrap thunderbird)
      (config.lib.nixGL.wrap steam)
      (config.lib.nixGL.wrap gdlauncher-carbon)
      (config.lib.nixGL.wrap discord)
      # (config.lib.nixGL.wrap warp-terminal)
      (config.lib.nixGL.wrap libreoffice)
      (config.lib.nixGL.wrap teams-for-linux)
      (config.lib.nixGL.wrap postman)
      (config.lib.nixGL.wrap obs-studio)
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

    fastfetch = {
      enable = true;
      package = (config.lib.nixGL.wrap pkgs.fastfetch);
      settings = {
        logo = {
          source = "nixos";
          padding = {
            right = 1;
          };
        };
        display = {
          size = {
            binaryPrefix = "si";
          };
          color = "blue";
          separator = "  ";
        };
        "modules" = [
          "title"
          "datetime"
          "separator"
          "os"
          "host"
          "bios"
          "bootmgr"
          "kernel"
          "initsystem"
          "uptime"
          "processes"
          "packages"
          "shell"
          "editor"
          "separator"
          {
            "type" = "cpu";
            "showPeCoreCount" = true;
            "temp" = true;
          }
          "cpucache"
          "cpuusage"
          "separator"
          {
            "type" = "gpu";
            "driverSpecific" = true;
            "temp" = true;
          }
          "separator"
          "memory"
          "physicalmemory"
          "disk"
          {
            "type" = "battery";
            "temp" = true;
          }
          "separator"
          "dns"
          {
            "type" = "localip";
            "showIpv6" = true;
            "showMac" = true;
            "showSpeed" = true;
            "showMtu" = true;
            "showLoop" = true;
            "showFlags" = true;
            "showAllIps" = true;
          }
          "vulkan"
          "opengl"
          "tpm"
          "version"
          "colors"
        ];
      };
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

          "terminal.integrated.defaultProfile.linux" = "zsh";
          "terminal.integrated.persistentSessionReviveProcess" = "onExitAndWindowClose";

          "editor.stickyScroll.enabled" = true;

          "workbench.editor.wrapTabs" = true;
          "workbench.colorTheme" = "One Dark Pro Night Flat";

          "git.enableSmartCommit" = true;
          "git.confirmSync" = false;
          "git.autofetch" = true;

          # Error lense is too noisy for some files/types
          "errorLens.excludeBySource" = [ "cSpell" ];
          "errorLens.messageBackgroundMode" = "message";
          "errorLens.border" = [
            "1px dotted"
            "1px dotted"
            "1px dotted"
            "1px dotted"
          ];
          "errorLens.padding" = "2px 0.4ch";
          # "errorLens.followCursor" = "closestProblem";
          # "errorLens.followCursorMore" = 3;
          "errorLens.alignMessage" = {
            "start" = 120;
            "end" = 0;
            "padding" = [
              0
              0.5
            ];
          };
          "errorLens.editorHoverPartsEnabled" = {
            "messageEnabled" = true;
            "sourceCodeEnabled" = true;
            "buttonsEnabled" = false;
          };

          # Formatter configs
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "editor.inlineSuggest.enabled" = true;
          "editor.inlayHints.enabled" = "offUnlessPressed";

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
          "[rust]" = {
            "editor.defaultFormatter" = "rust-lang.rust-analyzer";
          };
          "[toml]" = {
            "editor.defaultFormatter" = "tamasfe.even-better-toml";
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
          {
            "key" = "alt+right";
            "command" = "cursorWordPartRight";
            "when" = "editorTextFocus";
          }
          {
            "key" = "alt+shift+right";
            "command" = "cursorWordPartRightSelect";
            "when" = "editorTextFocus";
          }
          {
            "key" = "alt+left";
            "command" = "cursorWordPartLeft";
            "when" = "editorTextFocus";
          }
          {
            "key" = "alt+shift+left";
            "command" = "cursorWordPartLeftSelect";
            "when" = "editorTextFocus";
          }
          {
            "key" = "alt+backspace";
            "command" = "deleteWordPartLeft";
            "when" = "editorTextFocus && !editorReadonly";
          }
          {
            "key" = "alt+delete";
            "command" = "deleteWordPartRight";
            "when" = "editorTextFocus && !editorReadonly";
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
        default_layout = "janis";
        themes = {
          janis = {
            text_unselected = {
              base = [
                204
                204
                204
              ];
              background = [
                29
                32
                37
              ];
              emphasis_0 = [
                209
                154
                102
              ];
              emphasis_1 = [
                86
                182
                194
              ];
              emphasis_2 = [
                152
                195
                121
              ];
              emphasis_3 = [
                198
                120
                221
              ];
            };
            text_selected = {
              base = [
                29
                32
                37
              ];
              background = [
                204
                204
                204
              ];
              emphasis_0 = [
                209
                154
                102
              ];
              emphasis_1 = [
                86
                182
                194
              ];
              emphasis_2 = [
                152
                195
                121
              ];
              emphasis_3 = [
                198
                120
                221
              ];
            };
            ribbon_selected = {
              base = [
                29
                32
                37
              ];
              background = [
                152
                195
                121
              ];
              emphasis_0 = [
                190
                80
                70
              ];
              emphasis_1 = [
                209
                154
                102
              ];
              emphasis_2 = [
                198
                120
                221
              ];
              emphasis_3 = [
                97
                175
                239
              ];
            };
            ribbon_unselected = {
              base = [
                29
                32
                37
              ];
              background = [
                171
                178
                191
              ];
              emphasis_0 = [
                190
                80
                70
              ];
              emphasis_1 = [
                204
                204
                204
              ];
              emphasis_2 = [
                97
                175
                239
              ];
              emphasis_3 = [
                198
                120
                221
              ];
            };
            table_title = {
              base = [
                152
                195
                121
              ];
              background = [ 0 ];
              emphasis_0 = [
                209
                154
                102
              ];
              emphasis_1 = [
                86
                182
                194
              ];
              emphasis_2 = [
                152
                195
                121
              ];
              emphasis_3 = [
                198
                120
                221
              ];
            };
            table_cell_selected = {
              base = [
                204
                204
                204
              ];
              background = [
                40
                44
                52
              ];
              emphasis_0 = [
                209
                154
                102
              ];
              emphasis_1 = [
                86
                182
                194
              ];
              emphasis_2 = [
                152
                195
                121
              ];
              emphasis_3 = [
                198
                120
                221
              ];
            };
            table_cell_unselected = {
              base = [
                204
                204
                204
              ];
              background = [
                29
                32
                37
              ];
              emphasis_0 = [
                209
                154
                102
              ];
              emphasis_1 = [
                86
                182
                194
              ];
              emphasis_2 = [
                152
                195
                121
              ];
              emphasis_3 = [
                198
                120
                221
              ];
            };
            list_selected = {
              base = [
                204
                204
                204
              ];
              background = [
                40
                44
                52
              ];
              emphasis_0 = [
                209
                154
                102
              ];
              emphasis_1 = [
                86
                182
                194
              ];
              emphasis_2 = [
                152
                195
                121
              ];
              emphasis_3 = [
                198
                120
                221
              ];
            };
            list_unselected = {
              base = [
                204
                204
                204
              ];
              background = [
                29
                32
                37
              ];
              emphasis_0 = [
                209
                154
                102
              ];
              emphasis_1 = [
                86
                182
                194
              ];
              emphasis_2 = [
                152
                195
                121
              ];
              emphasis_3 = [
                198
                120
                221
              ];
            };
            frame_selected = {
              base = [
                152
                195
                121
              ];
              background = [ 0 ];
              emphasis_0 = [
                209
                154
                102
              ];
              emphasis_1 = [
                86
                182
                194
              ];
              emphasis_2 = [
                198
                120
                221
              ];
              emphasis_3 = [ 0 ];
            };
            frame_highlight = {
              base = [
                209
                154
                102
              ];
              background = [ 0 ];
              emphasis_0 = [
                198
                120
                221
              ];
              emphasis_1 = [
                209
                154
                102
              ];
              emphasis_2 = [
                209
                154
                102
              ];
              emphasis_3 = [
                209
                154
                102
              ];
            };
            exit_code_success = {
              base = [
                152
                195
                121
              ];
              background = [ 0 ];
              emphasis_0 = [
                86
                182
                194
              ];
              emphasis_1 = [
                29
                32
                37
              ];
              emphasis_2 = [
                198
                120
                221
              ];
              emphasis_3 = [
                97
                175
                239
              ];
            };
            exit_code_error = {
              base = [
                190
                80
                70
              ];
              background = [ 0 ];
              emphasis_0 = [
                229
                192
                123
              ];
              emphasis_1 = [ 0 ];
              emphasis_2 = [ 0 ];
              emphasis_3 = [ 0 ];
            };
            multiplayer_user_colors = {
              player_1 = [
                198
                120
                221
              ];
              player_2 = [
                97
                175
                239
              ];
              player_3 = [ 0 ];
              player_4 = [
                229
                192
                123
              ];
              player_5 = [
                86
                182
                194
              ];
              player_6 = [ 0 ];
              player_7 = [
                190
                80
                70
              ];
              player_8 = [ 0 ];
              player_9 = [ 0 ];
              player_10 = [ 0 ];
            };
          };
        };
        theme = "janis";
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
                    name = "zsh";
                    split_direction = "vertical";
                  };
                  _children = [
                    {
                      pane = {
                        _props = {
                          size = "50%";
                          name = "zsh1";
                        };
                        command = "zsh";
                      };
                    }
                    {
                      pane = {
                        _props = {
                          size = "50%";
                          name = "zsh2";
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
                    name = "files";
                  };
                  _children = [
                    {
                      pane = {
                        _props = {
                          size = "100%";
                          name = "files";
                          cwd = "/";
                        };
                        plugin = {
                          cwd = "/";
                          location = "zellij:strider";
                        };
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
                        command = "lazygit";
                        args = [
                          "-p"
                          "/home/janis/code/cognigy/cognigy"
                        ];
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
                          name = "btop";
                          size = "70%";
                        };
                        command = "btop";
                      };
                    }
                    {
                      pane = {
                        _props = {
                          name = "nvidia";
                          size = "30%";
                        };
                        command = "watch";
                        args = [ "nvidia-smi" ];
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
      config = {
        theme = "TwoDark";
        style = "changes,header";
      };
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
        ];
        theme = "janis";
      };
      initContent = lib.mkOrder 1000 ''
        export NVM_DIR="$([ -z "''${XDG_CONFIG_HOME-}" ] && printf %s "''${HOME}/.nvm" || printf %s "''${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

        alias switch='home-manager switch --impure --flake ~/.nixconfig/.#default'
        alias sync-obsidian='(cd ~/.obsidian && git pull && git add -A && git commit -m "$(date "+%A %W %Y %X")" && git push) &'
        alias tree="l -TR"
        alias ff="fastfetch"
        alias f="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"

        alias -g cat="bat"
        alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
        alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

        # Cognigy config:
        alias deploy='~/code/cognigy/scripts/deploy.sh'
        alias hu="cd ~/code/cognigy/cognigy-ai-app && helm upgrade --debug --install --create-namespace --namespace cognigy-ai --values values-local.out.yaml cognigy-ai ."
        alias destroy='~/code/cognigy/scripts/destroy.sh'
      '';
    };

    btop = {
      enable = true;
      package = (config.lib.nixGL.wrap pkgs.btop);
      settings = {
        color_theme = "Default";
        theme_background = false;
        presets = "gpu0:0:default,cpu:0:default,proc:0:default";
        shown_boxes = "cpu gpu0 proc mem net";
      };
    };

    rofi = {
      enable = true;
      package = pkgs.rofi;
      font = "Fira Code";
      modes = [
        "drun"
        "calc"
        "emoji"
        "filebrowser"
        "window"
        "run"
      ];
      plugins = [
        pkgs.rofi-calc
        pkgs.rofi-emoji
        pkgs.rofi-obsidian
      ];
      extraConfig = {
        kb-mode-next = "Alt+Tab";
      };
      theme = "Arc-Dark";
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
