local add = MiniDeps.add
local now = MiniDeps.now
local later = MiniDeps.later
local map = vim.keymap.set

-- Oil（ファイルエクスプローラー）
now(function()
    add({ source = "stevearc/oil.nvim" })

    local function set_oil_hl()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        vim.api.nvim_set_hl(0, "OilNormal", { bg = normal.bg or "#161821" })
    end
    set_oil_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_oil_hl })

    require("oil").setup({
        default_file_explorer = true,
        view_options = { show_hidden = true },
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
                        local start_line = vim.fn.line("v")
                        local end_line = vim.fn.line(".")
                        if start_line > end_line then
                            start_line, end_line = end_line, start_line
                        end
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

    local sidebar_win = nil
    local function toggle_oil_sidebar()
        if sidebar_win and vim.api.nvim_win_is_valid(sidebar_win) then
            vim.api.nvim_win_close(sidebar_win, true)
            sidebar_win = nil
            return
        end
        local dir = vim.fn.expand("%:p:h")
        if dir == "" then dir = vim.fn.getcwd() end
        vim.cmd("topleft vsplit")
        sidebar_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_width(sidebar_win, 35)
        require("oil").open(dir)
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.signcolumn = "no"
        vim.wo.statuscolumn = ""
        vim.wo.winhighlight = "Normal:OilNormal,NormalNC:OilNormal"
        vim.api.nvim_create_autocmd("WinClosed", {
            pattern = tostring(sidebar_win),
            once = true,
            callback = function() sidebar_win = nil end,
        })
    end

    map("n", "<leader>e", toggle_oil_sidebar, { desc = "Toggle oil sidebar" })
    map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
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

later(function()
    add({ source = "sainnhe/gruvbox-material" })

    local buf_transparent = false
    local function toggle_buf_transparent()
        buf_transparent = not buf_transparent
        if buf_transparent then
            local groups = {
                "Normal", "NormalNC",
                "DiagnosticVirtualTextError", "DiagnosticVirtualTextWarn",
                "DiagnosticVirtualTextInfo", "DiagnosticVirtualTextHint",
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
        options = { separator_style = "slant" },
    })

    add({ source = "lambdalisue/fern.vim" })
    vim.g["fern#renderer"] = "nerdfont"
    add({ source = "lambdalisue/fern-renderer-nerdfont.vim" })
    add({ source = "lambdalisue/fern-git-status.vim" })
    add({ source = "lambdalisue/nerdfont.vim" })
    add({ source = "lambdalisue/glyph-palette.vim" })

    add({ source = "akinsho/toggleterm.nvim" })
    require("toggleterm").setup()

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
