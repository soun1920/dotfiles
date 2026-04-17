{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];

    shellInit = ''
      set -g fish_greeting
      set -gx fish_history_max 100000
      fish_add_path "$HOME/.wasmtime/bin"
      fish_add_path "$HOME/.local/bin"
    '';

    interactiveShellInit = ''
      direnv hook fish | source
      uv generate-shell-completion fish | source

      if test -x /usr/bin/dircolors
          if test -r ~/.dircolors
              eval (dircolors -c ~/.dircolors)
          else
              eval (dircolors -c)
          end
      end
    '';

    shellAliases = {
      ll = "ls -l";
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      nv = "nvim .";
      python = "python3";
      cdc = "cd /home/aw5qm/.config";
      actv = "source .venv/bin/activate.fish";
      activate = "source .venv/bin/activate.fish";
      # C++ コンパイル (AtCoder)
      gc = "g++ -std=gnu++20 -O2 -Wall -Wextra";
      cpp = "g++ -std=gnu++20 -O2 -Wall -Wextra main.cpp";
      ac = "gc main.cpp && oj t";
      ot = "cpp_test";
    };

    functions = {
      copy_to_clipboard = {
        description = "クリップボードにコピー (Wayland/X11対応)";
        body = ''
          if command -v wl-copy >/dev/null 2>&1
              wl-copy
          else if command -v pbcopy >/dev/null 2>&1
              pbcopy
          else if command -v xclip >/dev/null 2>&1
              xclip -selection clipboard
          else if command -v xsel >/dev/null 2>&1
              xsel --clipboard --input
          else
              echo "Warning: クリップボードにコピーできませんでした"
              cat
              return 1
          end
        '';
      };

      nd = {
        description = "AtCoderの問題ディレクトリ a→b→c→...→g→a を循環する";
        body = ''
          set -l current_dir (basename $PWD)
          set -l next_dir ""

          switch $current_dir
              case a; set next_dir b
              case b; set next_dir c
              case c; set next_dir d
              case d; set next_dir e
              case e; set next_dir f
              case f; set next_dir g
              case g; set next_dir a
              case '*'
                  echo "エラー: 対象ディレクトリは a b c d e f g のみ"
                  return 1
          end

          cd "../$next_dir" && echo "$current_dir → $next_dir"
        '';
      };

      cpp_test = {
        description = "C++コンパイル + ojテスト + 成功時クリップボードコピー";
        body = ''
          set -l cpp_file (test -n "$argv[1]" && echo $argv[1] || echo "main.cpp")

          g++ -std=gnu++20 -O2 -Wall -Wextra $cpp_file; or return 1

          set -l res (timeout 5s oj t 2>&1)
          set -l exit_code $status

          if test $exit_code -eq 124
              echo "timeout"
              return 1
          end

          echo $res

          if echo $res | grep -qE '\[SUCCESS\]|test success|All tests passed'
              cat $cpp_file | copy_to_clipboard
              echo "copied to clipboard"
          end

          return $exit_code
        '';
      };

      cdg = {
        description = "ghq + fzf でリポジトリに移動";
        body = ''
          cd "$(ghq list -p | fzf)"
        '';
      };

      gg = {
        description = "GitHub リポジトリを検索して ghq でクローン";
        body = ''
          set -l selected_repo (gh api user/repos --paginate --jq '.[] | "\(.full_name)\t\(.description)"' | fzf --prompt="Select Repo> " | awk '{print $1}')

          if test -n "$selected_repo"
              echo "Cloning $selected_repo..."
              ghq get $selected_repo
          end
        '';
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
