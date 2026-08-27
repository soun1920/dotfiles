-- mini.deps bootstrap
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    vim.fn.system({
        'git', 'clone', '--filter=blob:none',
        'https://github.com/nvim-mini/mini.nvim', mini_path,
    })
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require('mini.deps').setup({ path = { package = path_package } })

-- Leader（プラグイン読み込みより前に設定必須）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.common") -- VSCode・ターミナル共通プラグイン

-- VSCode モードはここで終了
if vim.g.vscode ~= nil then
    require("config.vscode")
    return
end

-- ターミナル専用
require("config.mini")
require("config.ui")
require("config.editor")
require("config.lang")

MiniDeps.later(function() require("config.lsp") end)
MiniDeps.later(function() require("config.conform") end)
MiniDeps.later(function() require("config.telescope") end)
