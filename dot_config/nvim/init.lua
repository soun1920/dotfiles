-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.g["fern#renderer"] = "nerdfont"
require("lazy").setup({ { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" } })
