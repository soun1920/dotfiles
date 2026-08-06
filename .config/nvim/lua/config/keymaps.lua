local map = vim.keymap.set

map({ "n", "t", "i" }, "<C-k>", ":bnext<CR>", { noremap = true, silent = true })
map("t", "<C-k>", "<C-\\><C-n>:bnext<CR>", { noremap = true, silent = true })
map("i", "jj", "<Esc>", { silent = true })
map("i", ";;", "<C-o>A;")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })
map("n", "<leader>[", "<C-w>h", { desc = "左のウィンドウへ" })
map("n", "<leader>]", "<C-w>l", { desc = "右のウィンドウへ" })
