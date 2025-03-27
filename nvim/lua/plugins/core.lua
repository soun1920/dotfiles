return {
  {
    "cocopon/iceberg.vim",
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme iceberg]])
    end,
  },
  "mattn/vim-lexiv",
  "tpope/vim-surround",
  "lambdalisue/fern.vim",
  "ahmedkhalf/project.nvim",
  "lambdalisue/fern-git-status.vim",
  "lambdalisue/nerdfont.vim",
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
  },
  {
    "lambdalisue/fern-renderer-nerdfont.vim",
  },
  { "neoclide/coc.nvim" },
  { "sainnhe/gruvbox-material" },
  {
    "lambdalisue/glyph-palette.vim",
  },
}
