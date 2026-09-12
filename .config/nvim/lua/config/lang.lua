local add = MiniDeps.add
local later = MiniDeps.later

later(function()
    -- 削除したもの:
    --   typescript.nvim … add() のみで未設定。ts_ls の設定は lsp.lua にある
    add({ source = "linux-cultist/venv-selector.nvim" }) -- regexp ブランチは main に統合済み
    add({ source = "hashivim/vim-terraform" })
    add({ source = "lervag/vimtex" })
    add({ source = "solarnz/thrift.vim" })
    add({ source = "ziglang/zig.vim" })
    add({ source = "ErickKramer/nvim-ros2" })
    add({ source = "chomosuke/typst-preview.nvim" })
    add({ source = "windwp/nvim-ts-autotag" })

    require("nvim-ts-autotag").setup()

    require("typst-preview").setup({
        dependencies_bin = { ["tinymist"] = "tinymist" },
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        callback = function(args)
            vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<cr>",
                { buffer = args.buf, desc = "Typst Preview toggle" })
        end,
    })

    require("venv-selector").setup({
        settings = {
            options = {
                notify_user_on_venv_activation = true,
            },
            search = {
                uv_python = {
                    command = "find " .. vim.fn.expand("~/.local/share/uv/python") .. " -name 'python3*' -type f 2>/dev/null",
                },
                cwd_venv = {
                    command = "find . -name 'python3*' -path '*/bin/python3*' -type f 2>/dev/null",
                },
            },
        },
    })
    vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Select Python venv" })
end)

-- Rust ------------------------------------------------------------------------
-- rustaceanvim は rust-analyzer を自前で起動する。lsp.lua 側で
-- vim.lsp.config('rust_analyzer') / enable を書くと二重起動になるため書いていない。
later(function()
    add({ source = "mrcjkb/rustaceanvim" })

    vim.g.rustaceanvim = {
        server = {
            -- lsp.lua と同じ on_attach を共有する（これが無いと rust バッファだけ
            -- gd/gr や inlay hint が効かない）
            on_attach = require("config.lsp_attach"),
            default_settings = {
                ["rust-analyzer"] = {
                    cargo = { allFeatures = true },
                    check = { command = "clippy" },
                    procMacro = { enable = true },
                    inlayHints = {
                        chainingHints = { enable = true },
                        closingBraceHints = { enable = true, minLines = 25 },
                        parameterHints = { enable = true },
                        typeHints = { enable = true },
                        maxLength = 25,
                        renderColons = true,
                    },
                },
            },
        },
    }

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function(args)
            local function m(lhs, action, desc)
                vim.keymap.set("n", lhs, function() vim.cmd.RustLsp(action) end,
                    { buffer = args.buf, desc = desc })
            end
            m("<leader>a", "codeAction", "Rust: code action (grouped)")
            m("<leader>rr", "runnables", "Rust: runnables")
            m("<leader>rd", "debuggables", "Rust: debuggables")
            m("<leader>rm", "expandMacro", "Rust: マクロ展開")
            m("<leader>rp", "parentModule", "Rust: 親モジュールへ")
            vim.keymap.set("n", "K", function() vim.cmd.RustLsp({ "hover", "actions" }) end,
                { buffer = args.buf, desc = "Rust: hover actions" })
        end,
    })

    -- Cargo.toml のバージョン補完・更新チェック
    add({ source = "saecki/crates.nvim" })
    -- crates.nvim は in-process LSP として動くので nvim-cmp の source 設定は不要
    -- （completion.cmp.enabled は deprecated）
    require("crates").setup()
end)
