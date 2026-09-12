---
name: env-contract
description: リポジトリで使う実行環境（ホスト、distrobox コンテナ、Nix devshell、venv、Flatpak）を実際に確かめて、リポジトリの CLAUDE.md に「環境」の節として書く。ROS 2 や Nix のプロジェクトで最初に一度実行する。「環境を CLAUDE.md に書いて」「env-contract」「どの環境で動かすか決めて」のとき。
---

# 実行環境を CLAUDE.md に書く

1. 候補を集める。`distrobox list`、`flake.nix` と `.envrc` の有無、`.venv` と `pyproject.toml`、`package.xml`（ROS 2 のディストロ）、ホストに同名のコマンドがあるか。
2. 候補ごとに実際にコマンドを通して確かめる。推測で書かない。例:

   ```bash
   distrobox enter <name> -- bash -lc 'source /opt/ros/<distro>/setup.bash && ros2 pkg list | head'
   ```

3. リポジトリの `CLAUDE.md` に次の節を書く。既にあれば書き換える。

   ```markdown
   ## 環境
   - どの作業をどの環境で行うか、1行ずつ。
   - コマンドの実行方法をそのまま貼れる形で（distrobox のラッパー、source する setup.bash、venv の有効化）。
   - ホストで見つからなくても、上の環境をすべて確認するまで「無い」と結論しない。
   - 検証コマンド（ビルド、テスト、`ros2 node list` など）と期待する出力。
   ```

4. 書いた検証コマンドを一度実行し、期待する出力が出ることを確かめてから完了と言う。
