MiniDeps.add({ source = "stevearc/conform.nvim" })

local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        rust = { "rustfmt" },
        go = { "gofumpt" },
        python = { "ruff_format" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        lua = { "stylua" },
        c = { "clang_format" },
        cpp = { "clang_format" },
    },
    format_on_save = function(bufnr)
        -- 一時的に保存時フォーマットを止めたいとき: :FormatDisable / :FormatEnable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 1500, lsp_format = "fallback" } -- 旧設定の 500ms は rustfmt/prettier に短い
    end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, { desc = "保存時フォーマットを止める（! でこのバッファだけ）", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, { desc = "保存時フォーマットを再開" })

vim.keymap.set({ "n", "v" }, "<leader>f", function()
    conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
