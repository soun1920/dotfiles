-- 1. lazy.nvimのセットアップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",

    "clone",
    "--filter=blob:none",

    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. 基本的なオプション
vim.opt.termguicolors = true

-- 3. プラグインの定義（必要最小限の3つだけ）
local plugins = {
  -- 色設定
  {
    "cocopon/iceberg.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("iceberg")
    end,
  },

  -- アイコン
  { "nvim-tree/nvim-web-devicons", lazy = false },
  -- バッファライン
  { "akinsho/bufferline.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
}

-- 4. 今回の問題を解決するためのハイライト設定【変更点】
local augroup = vim.api.nvim_create_augroup("MyCustomHighlights", { clear = true })
-- ★★★ イベントを "ColorScheme" から "VimEnter" に変更 ★★★
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,

  pattern = "*", -- すべてのファイルで起動時に一度だけ実行
  callback = function()
    -- DevIconの背景を透過(NONE)に設定
    vim.api.nvim_set_hl(0, "DevIcon", { bg = "NONE" })
  end,
})

-- 5. lazy.nvimの実行
require("lazy").setup(plugins)
