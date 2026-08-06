-- VSCode・ターミナル両方で動くプラグイン
local add = MiniDeps.add
local now = MiniDeps.now
local later = MiniDeps.later

later(function()
    add({ source = "rhysd/clever-f.vim" })
    vim.g.clever_f_smart_case = 1
end)

later(function()
    add({
        source = "nvim-treesitter/nvim-treesitter",
        hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
    })
    add({ source = "nvim-treesitter/nvim-treesitter-textobjects" })
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then return end
    configs.setup({
        ensure_installed = { "python", "lua", "javascript", "typescript", "tsx", "cpp", "c" },
        highlight        = { enable = false },
        indent           = { enable = false },
    })
end)

later(function()
    add({ source = "lewis6991/gitsigns.nvim" })
    require("gitsigns").setup({
        signs = { add = { text = "" }, change = { text = "" }, delete = { text = "" } },
        signcolumn = false,
        current_line_blame = false,
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr })
            vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr })
        end,
    })
end)

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

later(function()
    add({ source = "LudoPinelli/comment-box.nvim" })
end)
