-- VSCode・ターミナル両方で動くプラグイン
local add = MiniDeps.add
local now = MiniDeps.now
local later = MiniDeps.later

-- treesitter -----------------------------------------------------------------
-- nvim-treesitter の main ブランチは install() でパーサを入れるだけで
-- ハイライトは起動しない。Neovim 同梱パーサ（c/lua/vim/markdown/query/vimdoc）は
-- ランタイムの ftplugin が start してくれるが、それ以外は自分で呼ぶ必要がある。
later(function()
    add({
        source = "nvim-treesitter/nvim-treesitter",
        checkout = "main",
        hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
    })
    add({ source = "nvim-treesitter/nvim-treesitter-textobjects" })

    require("nvim-treesitter").install({
        "python", "lua", "javascript", "typescript", "tsx", "cpp", "c",
        "html", "css", "rust", "go", "java", "kotlin", "toml", "json", "yaml", "markdown", "bash",
    })

    -- indentexpr は "indents" クエリ（queries/<lang>/indents.scm）が無い言語だと
    -- フォールバックせず 0 を返す（例: lua）。o/O で無条件に無インデントになる
    -- バグがあるため、クエリが存在する言語だけ treesitter に任せ、無ければ
    -- indentexpr を設定せず Neovim 標準の autoindent に委ねる。
    -- 参照: https://github.com/nvim-treesitter/nvim-treesitter/issues/7062
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TSStart", { clear = true }),
        callback = function(args)
            local ok = pcall(vim.treesitter.start, args.buf)
            if not ok then return end

            -- treesitter ベースの折りたたみ
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"

            local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
            if lang and vim.treesitter.query.get(lang, "indents") then
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })

    vim.o.foldmethod = "expr"
    vim.o.foldlevel = 99 -- 開いた状態で始める
end)

-- git ------------------------------------------------------------------------
later(function()
    add({ source = "lewis6991/gitsigns.nvim" })
    require("gitsigns").setup({
        signcolumn = true, -- 変更箇所を可視化（旧設定では無効だった）
        current_line_blame = false,
        on_attach = function(bufnr)
            local gs = require("gitsigns")
            local function m(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end
            m("n", "]h", function() gs.nav_hunk("next") end, "次の hunk")
            m("n", "[h", function() gs.nav_hunk("prev") end, "前の hunk")
            m("n", "<leader>gp", gs.preview_hunk, "hunk をプレビュー")
            m("n", "<leader>gs", gs.stage_hunk, "hunk を stage")
            m("n", "<leader>gr", gs.reset_hunk, "hunk を reset")
            m("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "行の blame")
            m("n", "<leader>gd", gs.diffthis, "diff")
        end,
    })
end)

-- テキストオブジェクト --------------------------------------------------------
now(function() require("mini.surround").setup() end)

later(function()
    local ai = require("mini.ai")
    ai.setup({
        n_lines = 500,
        custom_textobjects = {
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
    })
    local map = vim.keymap.set
    map("n", "gnf", function() MiniAi.move_cursor("left", "a", "f", { search_method = "next" }) end)
    map("n", "gpf", function() MiniAi.move_cursor("left", "a", "f", { search_method = "prev" }) end)
    map("n", "gnc", function() MiniAi.move_cursor("left", "a", "c", { search_method = "next" }) end)
    map("n", "gpc", function() MiniAi.move_cursor("left", "a", "c", { search_method = "prev" }) end)
end)

-- 移動: flash.nvim（clever-f の置き換え）--------------------------------------
-- mini.surround が s 系（sa/sd/sr）を使うため、flash は f/F/t/T の強化と
-- treesitter 選択(S)だけに限定して衝突を避けている。
later(function()
    add({ source = "folke/flash.nvim" })
    require("flash").setup({
        modes = {
            search = { enabled = false },
            char = { enabled = true, jump_labels = true, multi_line = false },
        },
    })
    local map = vim.keymap.set
    map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash treesitter" })
    map({ "n", "x", "o" }, "<leader>s", function() require("flash").jump() end, { desc = "Flash jump" })
end)

later(function()
    add({ source = "LudoPinelli/comment-box.nvim" })
end)
