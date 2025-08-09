return {
  {
    "oahlen/iceberg.nvim",
    main = "iceberg",
    lazy = false,
    opt = {
      background = "hard",
    },
  },
  "mattn/vim-lexiv",
  "tpope/vim-surround",
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant",
        -- または、よりパディングの入った "padded_slant"
        -- separator_style = "padded_slant",
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
