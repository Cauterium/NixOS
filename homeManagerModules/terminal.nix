{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    terminal.enable = lib.mkEnableOption "Enables terminal programs";
  };

  config = lib.mkIf config.terminal.enable {
    programs.eza = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.bat = {
      enable = true;
      config = {
        theme = "base16";
      };
    };

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = ../resources/nixos-logo.png;
          type = "kitty-direct";
          padding = {
            right = 2;
          };
          width = 46;
          height = 23;
        };
        display.separator = "   ";
        modules = [
          {
            type = "custom";
            format = "┌────────────────────── Hardware ───────────────────────";
          }
          {
            type = "host";
            key = "│  PC      ";
            keyColor = "cyan";
          }
          {
            type = "cpu";
            key = "│  CPU     ";
            keyColor = "cyan";
          }
          {
            type = "gpu";
            key = "│ 󰍛 GPU     ";
            keyColor = "cyan";
          }
          {
            type = "memory";
            key = "│ 󰍛 RAM     ";
            keyColor = "cyan";
          }
          {
            type = "battery";
            key = "│ 󰁹 Battery ";
            keyColor = "cyan";
          }
          {
            type = "custom";
            format = "└───────────────────────────────────────────────────────";
          }
          "break"
          {
            type = "custom";
            format = "┌────────────────────── Software ───────────────────────";
          }
          {
            type = "os";
            key = "│  OS      ";
            keyColor = "blue";
          }
          {
            type = "kernel";
            key = "│  Kernel  ";
            keyColor = "blue";
          }
          {
            type = "bios";
            key = "│ ⚙ BIOS    ";
            keyColor = "blue";
          }
          {
            type = "packages";
            key = "│  Packages";
            keyColor = "blue";
          }
          {
            type = "shell";
            key = "│  Shell   ";
            keyColor = "blue";
          }
          {
            type = "custom";
            format = "│";
          }
          {
            type = "de";
            key = "│  DE      ";
            keyColor = "magenta";
          }
          {
            type = "wm";
            key = "│  WM      ";
            keyColor = "magenta";
          }
          {
            type = "theme";
            key = "│  Theme   ";
            keyColor = "magenta";
          }
          {
            type = "terminal";
            key = "│  Terminal";
            keyColor = "magenta";
          }
          {
            type = "terminalfont";
            key = "│  Font    ";
            keyColor = "magenta";
          }
          {
            type = "uptime";
            key = "│  Uptime  ";
            keyColor = "magenta";
          }
          {
            type = "custom";
            format = "└───────────────────────────────────────────────────────";
          }
          "break"
          {
            type = "colors";
            paddingLeft = 16;
          }
        ];
      };
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        "ls" = "eza --icons";
        "ll" = "eza --icons -lah";
        "cat" = "bat";
        "c" = "clear && fastfetch";
        "shell-cpp" = "nix-shell -p cmake gcc gdb valgrind glm --command fish";
      };
      shellInit = ''
        set -g fish_greeting
        set -g theme_date_format "+%a %H:%M"
      '';
      interactiveShellInit = ''
        clear
        fastfetch
      '';
      plugins = [
        {
          name = "colored_man_pages";
          src = pkgs.fishPlugins.colored-man-pages;
        }
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge;
        }
      ];
    };

    programs.fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultOptions = [
        "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
        "--ignore-case"
      ];
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$line_break"
          "$rust"
          "$python"
          "$character"
        ];

        directory = {
          style = "blue";
        };

        character = {
          success_symbol = "[❯](purple)";
          error_symbol = "[❯](red)";
          vimcmd_symbol = "[❮](green)";
        };

        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };

        git_status = {
          format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "​";
          untracked = "​";
          modified = "​";
          staged = "​";
          renamed = "​";
          deleted = "​";
          stashed = "≡";
        };

        git_state = {
          format = "\([$state( $progress_current/$progress_total)]($style)\) ";
          style = "bright-black";
        };

        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };

        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
        };

        rust = {
          format = "[$version]($style) ";
          style = "bright-black";
        };
      };
    };

    programs.thefuck = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
        theme_background = false;
        vim_keys = true;
        rounded_corners = true;
      };
    };

    programs.yazi = {
      enable = true;
      package = pkgs.yazi;
      enableFishIntegration = config.programs.fish.enable;

      settings = {
        mgr = {
          layout = [1 4 3];
          sort_by = "alphabetical";
          sort_sensitive = true;
          sort_reverse = false;
          sort_dir_first = true;
          show_hidden = false;
          show_symlink = true;
        };

        preview = {
          tab_size = 2;
          max_width = 600;
          max_height = 900;
        };
      };
    };

    home.packages = with pkgs; [
      cz-cli
      inputs.nixvim.packages."x86_64-linux".default
    ];

    programs.git = {
      enable = true;
      userName = "Fabian Brenneisen";
      userEmail = "brenneisen.fabian@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    programs.lazygit = {
      enable = true;
      settings = {
        gui.shortTimeFormat = "15:04:05";
        customCommands = [
          {
            key = "c";
            command = "git cz";
            description = "commit with commitizen";
            context = "files";
            loadingText = "opening commit tool";
            output = "terminal";
          }
        ];
      };
    };

    programs.neovim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    home.file.".czrc".text = ''
      {
        "path": "cz-conventional-changelog"
      }
    '';
  };
}
