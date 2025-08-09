return {
  -- LaTeX support - lazy load on tex files
  {
    "lervag/vimtex",
    ft = { "tex", "latex", "plaintex" },
    config = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
    end,
  },
  
  -- Python venv selector - load after startup
  {
    "linux-cultist/venv-selector.nvim",
    event = "VeryLazy",
    opts = {
      name = "venv",
      auto_refresh = false,
      notify_user_on_activate = false,
    },
  },
}