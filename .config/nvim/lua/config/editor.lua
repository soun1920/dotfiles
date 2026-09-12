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
    -- 削除したもの:
    --   vim-lexiv    … mini.pairs と役割が重複
    --   project.nvim … add() だけで setup() されておらず機能していなかった
    add({ source = "wakatime/vim-wakatime" })
    add({
        source = "L3MON4D3/LuaSnip",
        hooks = { post_checkout = function() vim.cmd("!make install_jsregexp") end },
    })
    add({ source = "kdheepak/lazygit.nvim", depends = { "nvim-lua/plenary.nvim" } })
    map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
end)

-- プロジェクト全体の検索・置換（telescope では置換ができないため）
later(function()
    add({ source = "MagicDuck/grug-far.nvim" })
    require("grug-far").setup({})
    map("n", "<leader>fR", function() require("grug-far").open() end, { desc = "検索して置換 (grug-far)" })
    map("v", "<leader>fR", function() require("grug-far").with_visual_selection() end, { desc = "選択範囲で置換" })
end)

-- 診断・参照・quickfix の一覧
later(function()
    add({ source = "folke/trouble.nvim" })
    require("trouble").setup({})
    map("n", "<leader>vt", "<Cmd>Trouble diagnostics toggle<CR>", { desc = "Trouble: 診断一覧" })
    map("n", "<leader>vT", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Trouble: このバッファの診断" })
    map("n", "<leader>vq", "<Cmd>Trouble qflist toggle<CR>", { desc = "Trouble: quickfix" })
end)

-- ディレクトリ単位でセッションを復元
later(function()
    add({ source = "folke/persistence.nvim" })
    require("persistence").setup()
    map("n", "<leader>qs", function() require("persistence").load() end, { desc = "セッションを復元" })
    map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "最後のセッションを復元" })

    -- :Restart … 保存してプロセスごと再起動し、その次の起動時だけ自動復元する
    -- （小文字の :restart はコマンド名として登録できない。Vim/Neovim の仕様で
    -- ユーザー定義コマンドは大文字始まりが必須）。普段の `nvim` 起動では
    -- 自動復元しない。
    vim.api.nvim_create_user_command("Restart", function()
        require("persistence").save()

        local env = vim.fn.environ()
        env.NVIM_RESTART = "1"
        local env_list = {}
        for k, v in pairs(env) do
            table.insert(env_list, k .. "=" .. tostring(v))
        end

        ;(vim.uv or vim.loop).spawn(vim.v.progpath, {
            args = {},
            cwd = vim.fn.getcwd(),
            stdio = { 0, 1, 2 }, -- 今の端末をそのまま引き継ぐ
            detached = true,
            env = env_list,
        })

        vim.schedule(function() vim.cmd("qa!") end)
    end, { desc = "セッションを保存してnvimを再起動" })

    if vim.env.NVIM_RESTART == "1" then
        vim.api.nvim_create_autocmd("VimEnter", {
            once = true,
            nested = true,
            callback = function() require("persistence").load() end,
        })
    end
end)
