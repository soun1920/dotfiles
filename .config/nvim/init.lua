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
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4


-- Keymaps
local map = vim.keymap.set
map({ "n", "t", "i" }, "<C-k>", ":bnext<CR>", { noremap = true, silent = true })
map("t", "<C-k>", "<C-\\><C-n>:bnext<CR>", { noremap = true, silent = true })
map("i", "jj", "<Esc>", { silent = true })
map("i", ";;", "<C-o>A;")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })
map("n", "<leader>[", "<C-w>h", { desc = "左のウィンドウへ" })
map("n", "<leader>]", "<C-w>l", { desc = "右のウィンドウへ" })

-- Common motion plugins (VSCode + terminal)
later(function()
    add({ source = "rhysd/clever-f.vim" })
    vim.g.clever_f_smart_case = 1
end)

-- treesitter（VSCode + ターミナル共通）
later(function()
    add({
        source = "nvim-treesitter/nvim-treesitter",
        hooks = { post_checkout = function() vim.cmd("TSUpdate") end }
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
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
    })
    -- 関数・クラス間の移動
    map("n", "gnf", function() MiniAi.move_cursor("left", "a", "f", { search_method = "next" }) end)
    map("n", "gpf", function() MiniAi.move_cursor("left", "a", "f", { search_method = "prev" }) end)
    map("n", "gnc", function() MiniAi.move_cursor("left", "a", "c", { search_method = "next" }) end)
    map("n", "gpc", function() MiniAi.move_cursor("left", "a", "c", { search_method = "prev" }) end)
end)

later(function()
    add({ source = "LudoPinelli/comment-box.nvim" })
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
    map({ "n", "v" }, "gc", function() vscode.call("editor.action.commentLine") end)

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
    add({ source = "vim-jp/nvimdoc-ja" })
    vim.opt.helplang = { 'ja', 'en' }
end)

-- vim-matchup（% 強化、ターミナルのみ）
later(function()
    add({ source = "andymass/vim-matchup" })
end)
-- Theme setup
now(function()
    vim.o.termguicolors = true
    -- add({ source = "oahlen/iceberg.nvim" })
    -- vim.cmd("colorscheme iceberg")
    vim.cmd("colorscheme sigewinne-hydro")
end)

-- Mini plugins
now(function()
    local starter = require("mini.starter")
    starter.setup({
        header = table.concat({
            "                                                    ",
            " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        }, "\n"),
        items = {
            {
                name = "Open directory",
                action = function()
                    require("oil").open(vim.fn.getcwd())
                end,
                section = "Directory",
            },
            starter.sections.recent_files(5, false), -- 最近のファイル
            starter.sections.recent_files(5, true),  -- 最近のディレクトリ内ファイル
            {
                name = "New file",
                action = "enew",
                section = "Actions",
            },
            {
                name = "Quit",
                action = "qall",
                section = "Actions",
            },
        },
        content_hooks = {
            starter.gen_hook.adding_bullet(),
            starter.gen_hook.aligning("center", "center"),
        },
    })
end)
now(function() require("mini.comment").setup() end)
now(function() require("mini.indentscope").setup() end)
now(function() require("mini.bracketed").setup() end)
now(function() require("mini.cursorword").setup() end)
-- now(function() require("mini.files").setup() end)
now(function() require("mini.tabline").setup() end)
now(function() require("mini.statusline").setup() end)
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
    local buf_transparent = false
    local function toggle_buf_transparent()
        buf_transparent = not buf_transparent
        if buf_transparent then
            local groups = {
                "Normal", "NormalNC",
                "DiagnosticVirtualTextError",
                "DiagnosticVirtualTextWarn",
                "DiagnosticVirtualTextInfo",
                "DiagnosticVirtualTextHint",
                "DiagnosticVirtualTextOk",
            }
            for _, group in ipairs(groups) do
                local hl = vim.api.nvim_get_hl(0, { name = group })
                hl.bg = nil
                vim.api.nvim_set_hl(0, group, hl)
            end
        else
            vim.cmd("colorscheme " .. vim.g.colors_name)
        end
    end
    map("n", "<leader>b", toggle_buf_transparent, { desc = "Toggle buffer transparency" })

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
    require("config.conform")
end)

-- nvim . でoilを開く
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local arg = vim.fn.argv(0)
        if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
            require("oil").open(arg)
        end
    end,
})

-- File explorer
now(function()
    add({ source = "stevearc/oil.nvim" })
    -- OilNormal は常にテーマの背景色を維持（透過トグルの影響を受けない）
    local function set_oil_hl()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        vim.api.nvim_set_hl(0, "OilNormal", { bg = normal.bg or "#161821" })
    end
    set_oil_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_oil_hl })
    require("oil").setup({
        default_file_explorer = true,
        view_options = {
            show_hidden = true,
        },
        keymaps = {
            ["<C-h>"] = false,
            ["<CR>"] = {
                mode = { "n", "v" },
                callback = function()
                    local oil = require("oil")
                    local dir = oil.get_current_dir()
                    if not dir then return end
                    local mode = vim.fn.mode()
                    if mode == "V" or mode == "v" then
                        -- Visual選択: 複数ファイルを右ウィンドウで開く
                        local start_line = vim.fn.line("v")
                        local end_line = vim.fn.line(".")
                        if start_line > end_line then
                            start_line, end_line = end_line, start_line
                        end
                        -- 移動前にoilのバッファ番号を保存
                        local oil_bufnr = vim.api.nvim_get_current_buf()
                        local paths = {}
                        for lnum = start_line, end_line do
                            local entry = oil.get_entry_on_line(oil_bufnr, lnum)
                            if entry and entry.type == "file" then
                                table.insert(paths, dir .. entry.name)
                            end
                        end
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
                        vim.cmd("wincmd l")
                        for _, path in ipairs(paths) do
                            vim.cmd("edit " .. vim.fn.fnameescape(path))
                        end
                    else
                        -- Normal: 単一ファイル/ディレクトリを開く
                        local entry = oil.get_cursor_entry()
                        if not entry then return end
                        if entry.type == "directory" then
                            oil.open(dir .. entry.name)
                        else
                            vim.cmd("wincmd l")
                            vim.cmd("edit " .. vim.fn.fnameescape(dir .. entry.name))
                        end
                    end
                end,
            },
        },
    })

    -- サイドバー風に開くトグル関数
    local sidebar_win = nil
    local function toggle_oil_sidebar()
        -- すでに開いていたら閉じる
        if sidebar_win and vim.api.nvim_win_is_valid(sidebar_win) then
            vim.api.nvim_win_close(sidebar_win, true)
            sidebar_win = nil
            return
        end
        -- 左に固定幅のsplitを開いてoilを表示
        vim.cmd("topleft vsplit")
        sidebar_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_width(sidebar_win, 35)
        require("oil").open(vim.fn.getcwd())
        -- サイドバー用のウィンドウオプション
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
        vim.wo.statuscolumn = ""
        -- 透過の影響を受けないよう独自のhighlight groupを使う
        vim.wo.winhighlight = "Normal:OilNormal,NormalNC:OilNormal"
        -- サイドバーが閉じられたとき状態をリセット
        vim.api.nvim_create_autocmd("WinClosed", {
            pattern = tostring(sidebar_win),
            once = true,
            callback = function() sidebar_win = nil end,
        })
    end

    map("n", "<leader>e", toggle_oil_sidebar, { desc = "Toggle oil sidebar" })
    map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
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


require("keylogger").start()
