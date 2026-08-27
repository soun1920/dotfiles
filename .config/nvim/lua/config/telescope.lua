MiniDeps.add({ source = "nvim-telescope/telescope.nvim", depends = { "nvim-lua/plenary.nvim" } })
MiniDeps.add({ source = "debugloop/telescope-undo.nvim" })

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
    },
    extensions = {
        undo = {
            use_delta = vim.fn.executable("delta") == 1,
            side_by_side = vim.fn.executable("delta") == 1,
            layout_strategy = "vertical",
            layout_config = { preview_height = 0.6 },
        },
    },
})

telescope.load_extension("undo")

local function get_git_root()
    return vim.fs.root(0, ".git") or vim.fn.getcwd()
end

local grep_excludes = {
    "--hidden",
    "--glob=!.git/*",
    "--glob=!.cache/*",
    "--glob=!.venv/*",
    "--glob=!.direnv/*",
    "--glob=!.mypy_cache/*",
    "--glob=!.pytest_cache/*",
    "--glob=!.ruff_cache/*",
}

map("n", "<leader>ff", builtin.find_files,  { desc = "Find files" })
map("n", "<leader>fg", function()
    builtin.live_grep({ cwd = get_git_root(), additional_args = grep_excludes })
end, { desc = "Live grep (git root)" })
map("n", "<leader>fb", builtin.buffers,     { desc = "Buffers" })
map("n", "<leader>fh", builtin.help_tags,   { desc = "Help tags" })
map("n", "<leader>fr", builtin.oldfiles,    { desc = "Recent files" })
map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
map("n", "gr",         builtin.lsp_references,       { desc = "LSP references" })
map("n", "gd",         builtin.lsp_definitions,      { desc = "LSP definitions" })
map("n", "<leader>fu", telescope.extensions.undo.undo, { desc = "Undo tree" })
