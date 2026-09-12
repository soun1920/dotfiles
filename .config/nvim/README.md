# nvim-next

`~/.config/nvim` の試用版。既存の設定には一切触れずに並行して動かせる。

```sh
NVIM_APPNAME=nvim-next nvim
```

データも完全に分離される（プラグイン・Mason・undo・ShaDa すべて別）:

| 種別 | パス |
|---|---|
| 設定 | `~/.config/nvim-next` |
| プラグイン | `~/.local/share/nvim-next` |
| undo / ShaDa / ログ | `~/.local/state/nvim-next` |

気に入らなければ 3 つ消すだけで元に戻る。常用するなら `alias vn='NVIM_APPNAME=nvim-next nvim'` などを shell に置く。

## 初回起動時

プラグインと Mason のツール（15個）は初回起動時に自動で入る。入らなければ手動で:

```vim
:MasonToolsInstall
```

`rust-toolchain` が nightly のプロジェクトでは `rustup` の `rust-analyzer` が
「Unknown binary」で落ちるため、Mason 版が必要（rustaceanvim は Mason 版を自動で拾う）。

## 動作確認の結果

| 項目 | 現行 nvim | nvim-next |
|---|---|---|
| 起動時間 | 54〜62 ms | 39〜44 ms |
| プラグイン数 | 55 | 46 |
| python / typescript / cpp の treesitter | 効いていない | 有効 |
| Lua の `<leader>f` | 何も起きない | stylua で整形される |
| insert の `<C-k>` | `:bnext` が挿入される | バッファ移動 |
| rust バッファ | rust-analyzer が attach | attach + inlay hint + `<leader>rr` など |

エラー・deprecation 警告なしで起動することを確認済み。

## 動かして分かって直した点

- **遅延ロードと FileType の順序**: `nvim file.rs` のように引数付きで起動すると、
  最初のバッファだけ treesitter と rustaceanvim が効かなかった。init.lua の最後で
  FileType を撃ち直している。
- **rustaceanvim と on_attach の共有**: rustaceanvim は rust-analyzer を自前で
  起動するため、`lsp.lua` の `on_attach` が rust バッファに適用されず、
  `gd` / `<leader>vca` / inlay hint が全部効かなかった。`lua/config/lsp_attach.lua`
  に切り出して両方から読むようにした。
- **venv-selector の `regexp` ブランチ**: main に統合済みで警告が出るため削除。
- **crates.nvim の `completion.cmp`**: deprecated になっていたため削除（in-process LSP で動く）。
- **stylua.toml**: `indent_width = 2` だったが実際のコードは 4 スペース。LazyVim starter の
  残骸なので 4 に直した。

## 元の設定から変えた点

### 不具合の修正

- **insert の `<C-k>`**: RHS が `:bnext<CR>` だったため insert モードでバッファに `:bnext` という文字列が挿入されていた。`<Cmd>bnext<CR>` に変更。
- **Mason の `ensure_installed`**: `mason.nvim` の `setup()` にそのオプションは無く、黙って無視されていた（stylua / prettier / gofumpt が未導入で、Lua・JS・Markdown の `<leader>f` が無反応だった）。`mason-tool-installer.nvim` に移した。
- **treesitter のハイライト**: `nvim-treesitter` main ブランチはパーサを入れるだけで `vim.treesitter.start()` を呼ばない。Neovim 同梱の c/lua/vim/markdown 以外（python・typescript・cpp など）はハイライトが効いていなかった。FileType autocmd で起動するようにした。ついでに treesitter の折りたたみとインデントも有効化。
- **insert の `<C-h>`**: `signature_help` に割り当てられていてバックスペースが潰れていた。削除（Neovim 0.11+ の既定は insert の `<C-s>`）。
- **`vim.diagnostic.goto_prev/goto_next`**: deprecated。`]d` / `[d` は 0.11+ で既定マップがあるので定義自体を削除した。
- **`vim.loop`**: deprecated。`vim.uv` に変更。
- **C++ 実行コマンド**: `fnameescape()` は Ex コマンド用でシェル用ではない。`shellescape()` に変更し、出力先を `a.out` 固定からキャッシュ配下の一時ファイルに変更。
- **telescope の `gd` / `gr`**: グローバルに張られていたが LSP の `on_attach` に上書きされ使われていなかった。`on_attach` 側で telescope 版を張るようにした。

### 追加したオプション

`undofile`（永続 undo。telescope-undo がセッションを跨ぐ）、`confirm`、`scrolloff=8`、`sidescrolloff`、`cursorline`、`signcolumn=yes`、`inccommand=split`、`splitright` / `splitbelow`、`updatetime=250`、`timeoutlen=400`、`jumpoptions=view`、`pumheight`、`list` / `listchars`、`linebreak` / `breakindent`、`exrc`。

### 整理したプラグイン

| 削除 | 理由 |
|---|---|
| fern.vim ほか4つ | oil.nvim と重複 |
| mini.tabline | bufferline.nvim と重複 |
| mini.pick | telescope.nvim と重複 |
| mini.comment | Neovim 0.10+ の組み込み `gc` で足りる |
| vim-lexiv | mini.pairs と重複 |
| clever-f.vim | flash.nvim に置き換え |
| glance.nvim | telescope / trouble と重複、未使用 |
| project.nvim | `add()` のみで `setup()` されておらず無効だった |
| typescript.nvim | 同上。ts_ls の設定は lsp.lua にある |
| catppuccin / nordic / gruvbox-material / iceberg.vim | カラースキームを 3 種に整理 |

### 追加したプラグイン

| プラグイン | 用途 |
|---|---|
| mini.clue | leader などのキー候補をポップアップ表示（which-key 相当、mini.nvim 同梱） |
| mini.bufremove | `<leader>x` でレイアウトを壊さずバッファを閉じる |
| mini.move | `Alt-hjkl` で行・選択範囲を移動 |
| mini.splitjoin | `gS` で引数リストを一行 ↔ 複数行 |
| mini.hipatterns | TODO / FIXME・カラーコードの可視化 |
| mini.trailspace | 末尾空白の可視化 |
| flash.nvim | `f` / `t` の強化、`S` で treesitter 選択、`<leader>s` でジャンプ |
| grug-far.nvim | プロジェクト全体の検索・置換（`<leader>fR`） |
| trouble.nvim | 診断・quickfix の一覧（`<leader>vt`） |
| fidget.nvim | rust-analyzer / clangd の index 進捗表示 |
| persistence.nvim | ディレクトリ単位のセッション復元（`<leader>qs`、自動ロードなし） |
| rustaceanvim | rust-analyzer の統合。`<leader>rr` runnables、`<leader>rd` debuggables、`K` で hover actions |
| crates.nvim | Cargo.toml のバージョン補完・更新チェック |
| mason-tool-installer.nvim | Mason のツール導入を宣言的に |

### 変更したキー

| キー | 旧 | 新 |
|---|---|---|
| `<leader>b` | 背景の透過トグル | Buffer 系の prefix（透過は `<leader>tb`） |
| `<leader>t`（cpp） | oj のテスト | `<leader>rt`（`<leader>t` は Toggle 系の prefix） |
| `<C-j>` | なし | 前のバッファ |
| `<leader>x` / `<leader>X` | なし | バッファを閉じる / 強制 |
| `<leader>bo` / `<leader>bp` | なし | 他を閉じる / 選んで閉じる |
| `<leader>g*` | なし | gitsigns（preview / stage / reset / blame / diff） |

## 未適用の提案

- **blink.cmp への移行**: nvim-cmp + source 5つを 1 プラグインに統合でき高速。ただし現状の補完設定は完成度が高いので据え置いた。
- **`vim.pack` への移行**: Neovim 0.12 の組み込みプラグイン管理。mini.deps は開発が凍結されたが動作はする。
- **nvim-lint**: eslint_d / golangci-lint を動かす仕組みが無かったので、ツール一覧から外す方を選んだ。使うなら nvim-lint を追加する。
- **プロジェクト毎の rust-analyzer 設定**: `exrc` を有効にしてあるので、ベアメタルの Rust プロジェクト（`build-std` + カスタムターゲット）ではリポジトリ直下に `.nvim.lua` を置くと `cargo check --all-targets` の失敗を避けられる。

```lua
-- 例: mis_os/.nvim.lua
vim.g.rustaceanvim = vim.tbl_deep_extend("force", vim.g.rustaceanvim or {}, {
    server = { default_settings = { ["rust-analyzer"] = {
        cargo = { allFeatures = false, target = "x86_64-mis_os.json" },
        check = { allTargets = false, command = "check" },
    } } },
})
```
