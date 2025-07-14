return {
  {
    "oahlen/iceberg.nvim",
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme iceberg]])
    end,
  },
  "mattn/vim-lexiv",
  "tpope/vim-surround",
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
  "ahmedkhalf/project.nvim",

  "lambdalisue/nerdfont.vim",
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
  },
  { "wakatime/vim-wakatime", lazy = false },
  -- { "neoclide/coc.nvim" },
  { "sainnhe/gruvbox-material" },
  {
    "lambdalisue/glyph-palette.vim",
  },
  { "akinsho/toggleterm.nvim", version = "*", config = true },
  { "xiyaowong/transparent.nvim" },
}
