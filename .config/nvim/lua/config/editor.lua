local add = MiniDeps.add
local later = MiniDeps.later
local map = vim.keymap.set

later(function()
    add({ source = "vim-jp/nvimdoc-ja" })
    vim.opt.helplang = { 'ja', 'en' }
end)

later(function()
    add({ source = "andymass/vim-matchup" })
end)

later(function()
    add({ source = "mattn/vim-lexiv" })
    add({ source = "ahmedkhalf/project.nvim" })
    add({ source = "wakatime/vim-wakatime" })
    add({
        source = "L3MON4D3/LuaSnip",
        hooks = { post_checkout = function() vim.cmd("!make install_jsregexp") end },
    })
    add({ source = "kdheepak/lazygit.nvim", depends = { "nvim-lua/plenary.nvim" } })
    map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
end)

-- later(function()
--     add({ source = "echasnovski/mini.animate" })
--     require("mini.animate").setup()
-- end)
