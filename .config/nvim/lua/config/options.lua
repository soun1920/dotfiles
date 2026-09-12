vim.o.winborder = 'rounded'

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

vim.o.relativenumber = true
vim.o.number = true

-- ここから nvim-next で追加した分 ------------------------------------------

-- 履歴・安全性
vim.o.undofile = true      -- undo をファイルに永続化（telescope-undo がセッションを跨ぐ）
vim.o.confirm  = true      -- 未保存で :q したとき E37 で止まらず確認ダイアログ
vim.o.swapfile = true

-- 視界
vim.o.scrolloff     = 8
vim.o.sidescrolloff = 8
vim.o.cursorline    = true
vim.o.signcolumn    = "yes" -- 診断・gitsigns で幅が揺れないよう固定
vim.o.pumheight     = 10

-- 編集
vim.o.inccommand = "split" -- :s の結果をプレビュー
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 250     -- CursorHold / gitsigns の反応
vim.o.timeoutlen = 400
vim.o.jumpoptions = "view" -- <C-o> でスクロール位置も戻る

-- 不可視文字
vim.o.list = true
vim.opt.listchars = { tab = "▸ ", trail = "·", nbsp = "␣" }

-- 日本語・長文（typst / markdown 用）
vim.o.linebreak   = true
vim.o.breakindent = true

-- プロジェクト毎の .nvim.lua を読む（信頼確認あり）
vim.o.exrc = true
