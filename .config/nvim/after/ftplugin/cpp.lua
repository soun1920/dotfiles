-- nvim-next/after/ftplugin/cpp.lua

if vim.g.vscode ~= nil then return end

local function float_term(cmd)
    local Terminal = require("toggleterm.terminal").Terminal
    Terminal:new({
        cmd = cmd,
        direction = "float",
        close_on_exit = false,
        on_open = function() vim.cmd("startinsert") end,
    }):toggle()
end

vim.keymap.set("n", "<leader>r", function()
    local current_file = vim.fn.expand("%:p")
    if current_file == "" then
        vim.notify("ファイルが開かれていません", vim.log.levels.WARN)
        return
    end
    vim.cmd("silent write")

    -- 修正点:
    --   1. fnameescape() は Ex コマンド用。シェルに渡すなら shellescape()。
    --   2. 出力先を a.out 固定にすると同じディレクトリで衝突するので、
    --      ファイル名ベースの一時ファイルにする。
    local out = vim.fn.stdpath("cache") .. "/cpp-run/" .. vim.fn.expand("%:t:r")
    vim.fn.mkdir(vim.fn.fnamemodify(out, ":h"), "p")

    local cmd = string.format(
        "g++ -std=gnu++20 -O2 -Wall -Wextra %s -o %s && %s",
        vim.fn.shellescape(current_file),
        vim.fn.shellescape(out),
        vim.fn.shellescape(out)
    )
    float_term(cmd)
end, { noremap = true, silent = true, buffer = true, desc = "Compile & Run C++" })

-- oj のテスト（旧 <leader>t。<leader>t は Toggle 系の prefix になったため移動）
vim.keymap.set("n", "<leader>rt", function()
    float_term("zsh -ic ot")
end, { noremap = true, silent = true, buffer = true, desc = "Test with oj" })
