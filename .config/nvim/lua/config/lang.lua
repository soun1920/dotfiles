local add = MiniDeps.add
local later = MiniDeps.later

later(function()
    add({ source = "linux-cultist/venv-selector.nvim", checkout = "regexp" })
    add({ source = "hashivim/vim-terraform" })
    add({ source = "lervag/vimtex" })
    add({ source = "solarnz/thrift.vim" })
    add({ source = "jose-elias-alvarez/typescript.nvim" })
    add({ source = "ziglang/zig.vim" })
    add({ source = "ErickKramer/nvim-ros2" })
    add({ source = "chomosuke/typst-preview.nvim" })

    require("typst-preview").setup({
        dependencies_bin = { ["tinymist"] = "tinymist" },
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        callback = function(args)
            vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<cr>", { buffer = args.buf, desc = "Typst Preview toggle" })
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
