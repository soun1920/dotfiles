return {
  -- LSP設定
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- 診断表示設定
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      -- 自動フォーマット設定
      autoformat = true,
      -- LSPサーバー設定
      servers = {
        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },

        -- Go
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
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
        },

        -- Python
        pyright = {
          settings = {
            python = {
              pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },

        -- TypeScript/JavaScript
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- C/C++
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
      },
      -- キーマップ設定
      setup = {
        -- 個別LSPのsetup関数（必要に応じて）
      },
    },
    init = function()
      -- キーマップ設定
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- カスタムキーマップを追加
      keys[#keys + 1] = { "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Goto Definition" }
      keys[#keys + 1] = { "K", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Hover" }
      keys[#keys + 1] = { "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Signature Help", mode = "n" }
      keys[#keys + 1] = { "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Goto Type Definition" }
      keys[#keys + 1] = { "rn", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename" }
      keys[#keys + 1] = { "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code Action" }
      keys[#keys + 1] = { "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "References" }
      keys[#keys + 1] = { "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Line Diagnostics" }
      keys[#keys + 1] = { "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Previous Diagnostic" }
      keys[#keys + 1] = { "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" }

      -- inlay hintの色設定
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- inlay hintの色をカスタマイズ
          vim.api.nvim_set_hl(0, "LspInlayHint", {
            fg = "#7d8199", -- 前景色（テキストの色）
            bg = "NONE", -- 背景色（透明）
            italic = true, -- イタリック体
          })
        end,
      })

      -- 初回起動時にも適用
      vim.api.nvim_set_hl(0, "LspInlayHint", {
        fg = "#7d8199",
        bg = "NONE",
        italic = true,
      })
    end,
  },

  -- Mason設定（LSPサーバー自動インストール）
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "rust-analyzer",
        "gopls",
        "pyright",
        "typescript-language-server",
        "clangd",
        "lua-language-server",

        -- Formatters
        "rustfmt",
        "gofumpt",
        "black",
        "prettier",
        "clang-format",
        "stylua",

        -- Linters
        "golangci-lint",
        "eslint_d",
      },
    },
  },
}

