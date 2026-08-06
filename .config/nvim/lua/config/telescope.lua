MiniDeps.add({ source = "nvim-telescope/telescope.nvim", depends = { "nvim-lua/plenary.nvim" } })

local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local map = vim.keymap.set

telescope.setup({
    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-u>"] = false,
                ["<Esc>"] = actions.close,
            },
        },
    },
    pickers = {
        find_files = { hidden = true },
        live_grep = { additional_args = { "--hidden" } },
    },
})

map("n", "<leader>ff", builtin.find_files,  { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep,   { desc = "Live grep" })
map("n", "<leader>fb", builtin.buffers,     { desc = "Buffers" })
map("n", "<leader>fh", builtin.help_tags,   { desc = "Help tags" })
map("n", "<leader>fr", builtin.oldfiles,    { desc = "Recent files" })
map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
map("n", "gr",         builtin.lsp_references,       { desc = "LSP references" })
map("n", "gd",         builtin.lsp_definitions,      { desc = "LSP definitions" })
