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
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- <leader>f でフォーマット
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
