local add = MiniDeps.add
add({ source = "williamboman/mason.nvim" })
add({ source = "WhoIsSethDaniel/mason-tool-installer.nvim" })
add({ source = "neovim/nvim-lspconfig" })
add({ source = "hrsh7th/nvim-cmp" })
add({ source = "hrsh7th/cmp-nvim-lsp" })
add({ source = "hrsh7th/cmp-buffer" })
add({ source = "hrsh7th/cmp-path" })
add({ source = "hrsh7th/cmp-emoji" })
add({ source = "saadparwaiz1/cmp_luasnip" })
add({ source = "zbirenbaum/copilot.lua" })
add({ source = "zbirenbaum/copilot-cmp" })
-- 削除: glance.nvim … telescope / trouble と役割が重複していて未使用だった

-- Copilot は copilot-cmp 経由で nvim-cmp の source として使うため、
-- 標準のゴーストテキスト/パネルは切っておく（cmp と二重に出るのを防ぐ）。
require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
})
require("copilot_cmp").setup()

require("mason").setup()

-- mason.nvim の setup() に ensure_installed は存在しない（旧設定では
-- 指定していたが黙って無視され、stylua / prettier / gofumpt が未導入だった）。
-- 実際に入れるのは mason-tool-installer の仕事。
require("mason-tool-installer").setup({
    ensure_installed = {
        -- LSP servers
        "rust-analyzer", "gopls", "ruff", "ty", "typescript-language-server",
        "clangd", "jdtls", "kotlin-language-server", "lua-language-server", "tinymist", "veryl-ls",
        "html-lsp", "css-lsp", "emmet-language-server",
        -- Formatters（rustfmt は rustup 側、clang-format は /usr/bin にあるので除外）
        "stylua", "prettier", "gofumpt",
    },
    run_on_start = true,
    start_delay = 3000,
    debounce_hours = 24,
})

-- LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- 共通 on_attach（rustaceanvim と共有するため別ファイル）
local on_attach = require("config.lsp_attach")

-- rust_analyzer は rustaceanvim（lang.lua）が起動するため、ここでは設定しない。

-- Java / Kotlin
vim.lsp.config('jdtls', {
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.config('kotlin_language_server', {
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Go
vim.lsp.config('gopls', {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.work', 'go.mod', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
            codelenses = {
                gc_details = false, generate = true, regenerate_cgo = true,
                run_govulncheck = true, test = true, tidy = true,
                upgrade_dependency = true, vendor = true,
            },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
})

-- Python (ruff)
vim.lsp.config('ruff', {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Python type checker (ty)
vim.lsp.config('ty', {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = { 'ty.toml', 'pyproject.toml', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
})

-- TypeScript/JavaScript
local ts_inlay_hints = {
    includeInlayParameterNameHints = "all",
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayEnumMemberValueHints = true,
}
vim.lsp.config('ts_ls', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
    root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        typescript = { inlayHints = ts_inlay_hints },
        javascript = { inlayHints = ts_inlay_hints },
    },
})

-- C/C++ clangd 専用 on_attach（switchSourceHeader を追加）
local on_attach_clangd = function(client, bufnr)
    on_attach(client, bufnr)
    vim.keymap.set('n', '<leader>h', '<cmd>ClangdSwitchSourceHeader<cr>',
        { noremap = true, silent = true, buffer = bufnr, desc = "Switch Header/Source" })
end

vim.lsp.config('clangd', {
    cmd = {
        "clangd", "--background-index", "--clang-tidy",
        "--header-insertion=iwyu", "--completion-style=detailed",
        "--function-arg-placeholders", "--fallback-style=llvm",
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
    on_attach = on_attach_clangd,
    capabilities = capabilities,
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
})

-- Protobuf
vim.lsp.config('buf_ls', {
    cmd = { 'buf', 'lsp', 'serve' },
    filetypes = { 'proto' },
    root_markers = { 'buf.yaml', 'buf.work.yaml', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Lua
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim', 'MiniDeps', 'MiniAi' } },
            workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
            hint = { enable = true },
        },
    },
})

-- Typst
vim.lsp.config('tinymist', {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    root_markers = { '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        formatterMode = "typstyle",
        exportPdf = "onSave",
    },
})

add({ source = "veryl-lang/veryl.vim" })

vim.lsp.config('veryl_ls', {
    on_attach = on_attach,
    capabilities = capabilities,
})

-- HTML
vim.lsp.config('html', {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    root_markers = { 'package.json', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = { provideFormatter = false }, -- フォーマットは conform (prettier) に任せる
})

-- CSS/SCSS/LESS
vim.lsp.config('cssls', {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_markers = { 'package.json', '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
})

-- Emmet
vim.lsp.config('emmet_ls', {
    cmd = { 'emmet-language-server', '--stdio' },
    filetypes = { 'html', 'css', 'scss', 'less', 'javascriptreact', 'typescriptreact' },
    root_markers = { '.git' },
    on_attach = on_attach,
    capabilities = capabilities,
})

vim.lsp.enable({
    'gopls', 'ruff', 'ty', 'ts_ls', 'clangd', 'jdtls', 'kotlin_language_server', 'lua_ls', 'tinymist', 'veryl_ls',
    'html', 'cssls', 'emmet_ls', 'buf_ls',
})

local function apply_hl()
    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#7d8199", bg = "NONE", italic = true })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#ffffff", bg = "NONE" })
end
apply_hl()
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_hl })

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = { prefix = '●' },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = true, -- 'always' は deprecated
        header = '',
        prefix = '',
    },
    jump = { float = true }, -- ]d / [d でジャンプしたとき診断をフロートで出す
})

-- Setup nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_lua').load({ paths = vim.fn.stdpath('config') .. '/lua/snippets' })

cmp.setup({
    performance = { max_view_entries = 10 },
    window = {
        completion    = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    -- copilot を最優先で並べる（cmp-copilot-cmp 推奨のコンパレータ）
    sorting = {
        priority_weight = 2,
        comparators = {
            require('copilot_cmp.comparators').prioritize,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    sources = cmp.config.sources({
        { name = 'copilot', group_index = 2 },
        { name = 'nvim_lsp', group_index = 2 },
        { name = 'luasnip', group_index = 2 },
    }, {
        { name = 'buffer' },
        { name = 'path' },
        { name = 'emoji' },
    })
})
