-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/nvim-mini/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Options
vim.g.lazyvim_python_ruff = "ruff"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

-- Keymaps
local map = vim.keymap.set
map({ "n", "t", "i" }, "<C-k>", ":bnext<CR>", { noremap = true, silent = true })
map("t", "<C-k>", "<C-\\><C-n>:bnext<CR>", { noremap = true, silent = true })
map("i", "jj", "<Esc>", { silent = true })
map("i", ";;", "<C-o>A;")

-- Common motion plugins (VSCode + terminal)
-- clever-f（f/F 強化）
later(function()
    add({ source = "rhysd/clever-f.vim" })
    vim.g.clever_f_smart_case = 1
end)

-- treesitter（VSCode + ターミナル共通）
later(function()
    add({ source = "nvim-treesitter/nvim-treesitter",
          hooks = { post_checkout = function() vim.cmd("TSUpdate") end } })
    add({ source = "nvim-treesitter/nvim-treesitter-textobjects" })
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then return end
    configs.setup({
        ensure_installed = { "python", "lua", "javascript", "typescript", "tsx", "cpp", "c" },
        highlight = { enable = false },
        indent    = { enable = false },
    })
end)

-- gitsigns（ハンク移動のみ）
later(function()
    add({ source = "lewis6991/gitsigns.nvim" })
    require("gitsigns").setup({
        signs = { add = { text = "" }, change = { text = "" }, delete = { text = "" } },
        signcolumn = false,
        current_line_blame = false,
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            map("n", "]h", gs.next_hunk, { buffer = bufnr })
            map("n", "[h", gs.prev_hunk, { buffer = bufnr })
        end,
    })
end)

-- mini.surround（共通）
now(function() require("mini.surround").setup() end)

-- mini.ai（treesitter クエリで f/c を強化）
later(function()
    local ai = require("mini.ai")
    ai.setup({
        n_lines = 500,
        custom_textobjects = {
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
            c = ai.gen_spec.treesitter({ a = "@class.outer",    i = "@class.inner" }),
        },
    })
    -- 関数・クラス間の移動
    map("n", "gnf", function() MiniAi.move_cursor("left", "a", "f", { search_method = "next" }) end)
    map("n", "gpf", function() MiniAi.move_cursor("left", "a", "f", { search_method = "prev" }) end)
    map("n", "gnc", function() MiniAi.move_cursor("left", "a", "c", { search_method = "next" }) end)
    map("n", "gpc", function() MiniAi.move_cursor("left", "a", "c", { search_method = "prev" }) end)
end)

later(function()
	add({source="LudoPinelli/comment-box.nvim"})

end)

-- VSCode compatibility
if vim.g.vscode ~= nil then
    local vscode = require("vscode")

    -- VSCode コマンドマッピング
    map("n", "<C-k>", function() vscode.call("workbench.action.nextEditor") end)
    map("n", "<C-j>", function() vscode.call("workbench.action.previousEditor") end)
    map("n", "<leader>e", function() vscode.call("workbench.action.toggleSidebarVisibility") end)
    map("n", "<leader>r", function() vscode.call("workbench.action.toggleAuxiliaryBar") end)
    map("n", "<leader>j", function() vscode.call("workbench.action.togglePanel") end)
    map("n", "<leader>m", function()
        vscode.call("workbench.action.toggleSidebarVisibility")
        vscode.call("workbench.action.toggleAuxiliaryBar")
        vscode.call("workbench.action.togglePanel")
    end)
    map("n", "<leader>h", function()
        local ok = pcall(vscode.call, "stm32cube-ide-clangd.switchheadersource")
        if not ok then ok = pcall(vscode.call, "clangd.switchSourceHeader") end
        if not ok then pcall(vscode.call, "C_Cpp.switchHeaderSource") end
    end)
    map("n", "<leader>ff", function() vscode.call("workbench.action.quickOpen") end)
    map("n", "<leader>fg", function() vscode.call("workbench.action.findInFiles") end)
    map("n", "gr", function() vscode.call("editor.action.goToReferences") end)
    map("n", "gd", function() vscode.call("editor.action.revealDefinition") end)
    map("n", "<leader>ca", function() vscode.call("editor.action.quickFix") end)
    map("n", "<leader>rn", function() vscode.call("editor.action.rename") end)
    map({"n","v"}, "gc", function() vscode.call("editor.action.commentLine") end)

    -- パーサを明示的に起動（vscode-neovim では自動起動が信頼できないため）
    vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
            pcall(vim.treesitter.start, args.buf)
        end,
    })

    -- 日本語 IME 対策（im-select がある場合のみ）
    local im_select = vim.fn.exepath("im-select")
    if im_select ~= "" then
        vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
                vim.fn.system({ im_select, "com.apple.keylayout.ABC" })
            end,
        })
    end

    return
end

later(function()
    add({ source = "vim-jp/nvimdoc-ja"})
    vim.opt.helplang = { 'ja', 'en' }
end)

-- vim-matchup（% 強化、ターミナルのみ）
later(function()
    add({ source = "andymass/vim-matchup" })
end)
-- Theme setup
now(function()
    vim.o.termguicolors = true
    add({ source = "oahlen/iceberg.nvim" })
    vim.cmd("colorscheme iceberg")
end)

-- Mini plugins
now(function() require("mini.comment").setup() end)
now(function() require("mini.indentscope").setup() end)
now(function() require("mini.bracketed").setup() end)
now(function() require("mini.cursorword").setup() end)
now(function() require("mini.files").setup() end)
now(function() require("mini.tabline").setup() end)
now(function() require("mini.pick").setup() end)
later(function() require("mini.pairs").setup() end)

-- Editor plugins
later(function()
    add({ source = "mattn/vim-lexiv" })
    add({ source = "ahmedkhalf/project.nvim" })
    add({ source = "wakatime/vim-wakatime" })
    add({
        source = "L3MON4D3/LuaSnip",
        hooks = { post_checkout = function() vim.cmd("!make install_jsregexp") end }
    })

    add({ source = "kdheepak/lazygit.nvim", depends = { "nvim-lua/plenary.nvim" } })
    map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
end)

-- UI plugins
later(function()
    add({ source = "sainnhe/gruvbox-material" })
    add({ source = "xiyaowong/transparent.nvim" })

    add({ source = "akinsho/bufferline.nvim" })
    require("bufferline").setup({
        options = {
            separator_style = "slant",
        },
    })

    add({ source = "lambdalisue/fern.vim" })
    vim.g["fern#renderer"] = "nerdfont"
    add({ source = "lambdalisue/fern-renderer-nerdfont.vim" })
    add({ source = "lambdalisue/fern-git-status.vim" })
    add({ source = "lambdalisue/nerdfont.vim" })
    add({ source = "lambdalisue/glyph-palette.vim" })
    add({ source = "akinsho/toggleterm.nvim" })
    require("toggleterm").setup()

    -- Fern configuration
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "fern",
        group = vim.api.nvim_create_augroup("FernSetting", { clear = true }),
        callback = function(args)
            vim.keymap.set("n", "<CR>", "<Plug>(fern-action-open:background)", {
                buffer = args.buf,
                noremap = true,
                silent = true,
                desc = "Fern: Open file in background",
            })
        end,
    })
end)

-- LSP and completion
later(function()
    add({ source = "williamboman/mason.nvim" })
    add({ source = "williamboman/mason-lspconfig.nvim" })
    add({ source = "neovim/nvim-lspconfig" })
    add({ source = "hrsh7th/nvim-cmp" })
    add({ source = "hrsh7th/cmp-nvim-lsp" })
    add({ source = "hrsh7th/cmp-buffer" })
    add({ source = "hrsh7th/cmp-path" })
    add({ source = "hrsh7th/cmp-emoji" })
    add({ source = "saadparwaiz1/cmp_luasnip" })

    require("config.lsp")
end)

-- Formatting
later(function()
    add({ source = "stevearc/conform.nvim" })
end)

-- Language-specific plugins
later(function()
    -- Python
    add({ source = "linux-cultist/venv-selector.nvim" })

    -- Terraform
    add({ source = "hashivim/vim-terraform" })

    -- LaTeX
    add({ source = "lervag/vimtex" })

    -- Thrift
    add({ source = "solarnz/thrift.vim" })

    -- TypeScript
    add({ source = "jose-elias-alvarez/typescript.nvim" })

    -- Zig
    add({ source = "ziglang/zig.vim" })

    -- Additional UI enhancements (from LazyVim extras)
    add({ source = "echasnovski/mini.animate" })
    require("mini.animate").setup()
end)

