{ ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      format = ''
        [╭──](fg:#6b7089)[$directory](bold fg:#84a0c6)([ ─ ](fg:#6b7089)$git_branch $git_status)([ ─ ](fg:#6b7089)$python$nodejs$rust$golang$java$lua$docker_context$package)
        [╰─>](fg:#6b7089) '';
      right_format = "\${cmd_duration}\${time}";
      add_newline = true;

      directory = {
        style = "bold fg:#84a0c6";
        truncation_length = 5;
        format = "[ $path]($style)";
        read_only = " 󰌾";
        read_only_style = "fg:#e27878";
      };

      git_branch = {
        symbol = " ";
        style = "fg:#b4be82";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "fg:#e27878";
        format = "[$all_status$ahead_behind]($style) ";
        ahead = "↑";
        behind = "↓";
        diverged = "󰙒";
        modified = "";
        staged = "";
        untracked = "";
        deleted = "";
        renamed = "";
        stashed = "";
      };

      username = {
        show_always = false;
        style_user = "fg:#a093c7";
        format = "[ $user]($style_user)@";
      };

      hostname = {
        ssh_only = true;
        style = "fg:#a093c7";
        format = "[$ssh_symbol$hostname]($style)";
        ssh_symbol = "󰣀 ";
      };

      python = {
        symbol = " ";
        style = "fg:#e2a478";
        format = "[$symbol$version( $virtualenv)]($style) ";
      };

      nodejs = {
        symbol = " ";
        style = "fg:#b4be82";
        format = "[$symbol$version]($style) ";
      };

      rust = {
        symbol = " ";
        style = "fg:#e27878";
        format = "[$symbol$version]($style) ";
      };

      golang = {
        symbol = "󰟓 ";
        style = "fg:#89b8c2";
        format = "[$symbol$version]($style) ";
      };

      java = {
        symbol = " ";
        style = "fg:#e27878";
        format = "[$symbol$version]($style) ";
      };

      lua = {
        symbol = " ";
        style = "fg:#84a0c6";
        format = "[$symbol$version]($style) ";
      };

      c = {
        symbol = " ";
        style = "fg:#84a0c6";
        format = "[$symbol$name$version]($style) ";
      };

      docker_context = {
        symbol = " ";
        style = "fg:#89b8c2";
        format = "[$symbol$context]($style) ";
      };

      package = {
        symbol = "󰏗 ";
        style = "fg:#e2a478";
        format = "[$symbol$version]($style) ";
      };

      cmd_duration = {
        min_time = 2000;
        style = "fg:#6b7089";
        format = "[ $duration]($style)";
      };

      time = {
        disabled = true;
        style = "fg:#6b7089";
        format = "[  $time]($style)";
        time_format = "%H:%M";
      };

      memory_usage = {
        disabled = true;
        symbol = "󰍛 ";
        style = "fg:#6b7089";
        format = "[$symbol$ram]($style) ";
      };

      battery = {
        disabled = true;
      };

      aws = {
        symbol = " ";
        style = "fg:#e2a478";
        format = "[$symbol$profile]($style) ";
      };

      character = {
        disabled = true;
      };
    };
  };
}
