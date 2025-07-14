-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set
map({ "n", "t", "i" }, "<C-k>", ":bnext<CR>", { noremap = true, silent = true })

map("t", "<C-k>", "<C-\\><C-n>:bnext<CR>", { noremap = true, silent = true })

map("i", "jj", "<Esc>", { silent = true })

map("i", ";;", "<C-o>A;")
