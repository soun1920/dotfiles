{ ... }:

# NixOS VM + niri 専用のユーザー設定
# home/default.nix からは import せず、hosts/vm-niri の home-manager.users で追加 import する
{
  xdg.configFile."niri/config.kdl".text = ''
    input {
      keyboard {
        xkb {
          layout "jp"
        }
      }
      touchpad {
        tap
        natural-scroll
      }
    }

    output "Virtual-1" {
      scale 1.0
      mode "1920x1080"
    }

    layout {
      gaps 8
      default-column-width { proportion 0.5; }
      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }
    }

    binds {
      // ターミナル・ランチャー
      Mod+Return { spawn "/etc/profiles/per-user/aw5qm/bin/ghostty"; }
      Mod+D { spawn "fuzzel"; }
      Mod+Q { close-window; }
      Mod+Shift+E { quit; }
      Mod+Shift+L { spawn "swaylock"; }

      // フォーカス移動 (vim-style hjkl)
      Mod+H { focus-column-left; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }
      Mod+L { focus-column-right; }

      // ウィンドウ移動
      Mod+Shift+H { move-column-left; }
      Mod+Shift+J { move-window-down; }
      Mod+Shift+K { move-window-up; }

      // ワークスペース
      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+Shift+1 { move-column-to-workspace 1; }
      Mod+Shift+2 { move-column-to-workspace 2; }
      Mod+Shift+3 { move-column-to-workspace 3; }
      Mod+Shift+4 { move-column-to-workspace 4; }
      Mod+Shift+5 { move-column-to-workspace 5; }

      // カラム幅変更
      Mod+R { switch-preset-column-width; }
      Mod+F { maximize-column; }
      Mod+Shift+F { fullscreen-window; }

      // スクリーンショット
      Print { screenshot; }
      Mod+Print { screenshot-window; }
      Mod+Shift+Print { screenshot-screen; }

      // スクロール (niri の特徴的なスクロール操作)
      Mod+WheelScrollDown cooldown-ms=150 { focus-column-right; }
      Mod+WheelScrollUp cooldown-ms=150 { focus-column-left; }
      Mod+Shift+WheelScrollDown cooldown-ms=150 { move-column-right; }
      Mod+Shift+WheelScrollUp cooldown-ms=150 { move-column-left; }

      // 音量
      XF86AudioRaiseVolume allow-when-locked=true { spawn "pamixer" "-i" "5"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "pamixer" "-d" "5"; }
      XF86AudioMute allow-when-locked=true { spawn "pamixer" "-t"; }
    }

    spawn-at-startup "waybar"
    spawn-at-startup "mako"
    spawn-at-startup "fcitx5" "-d"
  '';
}
