return {
  { "lazyvim.plugins.extras.ui.alpha", enabled = false },
  
  {
    "oahlen/iceberg.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme iceberg")
    end,
  },
  { "sainnhe/gruvbox-material" },
  { "xiyaowong/transparent.nvim" },

  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant",
      },
    },
  },
  {
    "lambdalisue/fern.vim",
    dependencies = { "lambdalisue/fern-renderer-nerdfont.vim", "lambdalisue/fern-git-status.vim" },
    config = function()
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
    end,
  },
  "lambdalisue/nerdfont.vim",
  { "lambdalisue/glyph-palette.vim" },
  { "akinsho/toggleterm.nvim", version = "*", config = true },
}