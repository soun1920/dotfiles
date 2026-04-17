-- ~/.config/nvim/after/ftplugin/cpp.lua

if vim.g.vscode ~= nil then return end

vim.keymap.set("n", "<leader>r", function()
  -- 現在のファイル名を取得
  local current_file = vim.fn.expand("%")
  if not current_file or current_file == "" then
    vim.notify("ファイルが開かれていません", vim.log.levels.WARN)
    return
  end

  -- コマンドを組み立て
  local escaped_file = vim.fn.fnameescape(current_file)
  local output_file = "a.out"
  local cmd =
    string.format("g++ -std=gnu++20 -O2 -Wall -Wextra %s -o %s && ./%s", escaped_file, output_file, output_file)

  -- ToggleTermをフローティングウィンドウで実行
  -- ↓↓↓ この行を修正しました！ ↓↓↓
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = cmd,
    direction = "float",
    close_on_exit = false, -- デバッグのためfalseのままにしておきます
    on_open = function(t)
      vim.cmd("startinsert")
    end,
  })
  term:toggle()
end, {
  noremap = true,
  silent = true,
  buffer = true,
  desc = "Compile & Run C++",
})

vim.keymap.set("n", "<leader>t", function()
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new({
    cmd = "zsh -ic ot",
    direction = "float",
    close_on_exit = false,
    on_open = function(t)
      vim.cmd("startinsert")
    end,
  })
  term:toggle()
end, { noremap = true, silent = true, buffer = true, desc = "Test with oj" })
