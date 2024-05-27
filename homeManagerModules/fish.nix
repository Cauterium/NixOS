{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    fish.enable = lib.mkEnableOption "Enables Fish Shell";
  };

  config = lib.mkIf config.fish.enable {
    home.packages = with pkgs; [
      fzf
    ];

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.bat = {
      enable = true;
      # TODO add theme
    };

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos";
          padding = {
            right = 2;
          };
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "wm"
          "theme"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "memory"
          "battery"
          "break"
          "colors"
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
	"fzf" = ''fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'';
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
  };
}
