local map = vim.keymap.set

-- バッファ移動
-- 修正: 旧設定は RHS が ":bnext<CR>" だったため insert モードで文字列がそのまま
-- 挿入されていた（i<C-k> でバッファに ":bnext" が入る）。<Cmd> なら全モード安全。
map({ "n", "i", "t" }, "<C-k>", "<Cmd>bnext<CR>", { silent = true, desc = "次のバッファ" })
map({ "n", "i", "t" }, "<C-j>", "<Cmd>bprevious<CR>", { silent = true, desc = "前のバッファ" })

map("i", "jj", "<Esc>", { silent = true })
map("i", ";;", "<C-o>A;")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })
map("n", "<leader>[", "<C-w>h", { desc = "左のウィンドウへ" })
map("n", "<leader>]", "<C-w>l", { desc = "右のウィンドウへ" })

-- ターミナルから抜ける
map("t", "<C-\\><C-n>", "<C-\\><C-n>", { desc = "ターミナル: normal モードへ" })

vim.api.nvim_create_user_command("Config", function()
    vim.cmd("tabnew " .. vim.fn.stdpath("config"))
end, { desc = "Open Neovim config directory" })
