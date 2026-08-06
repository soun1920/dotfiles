local map = vim.keymap.set
local vscode = require("vscode")

map("n", "<C-k>", function() vscode.call("workbench.action.nextEditor") end)
map("n", "<C-j>", function() vscode.call("workbench.action.previousEditor") end)
map("n", "<leader>e", function() vscode.call("workbench.action.toggleSidebarVisibility") end)
map("n", "<leader>r", function() vscode.call("workbench.action.toggleAuxiliaryBar") end)
map("n", "<leader>j", function() vscode.call("workbench.action.togglePanel") end)
map("n", "<leader>m", function()
    vscode.call("workbench.action.toggleSidebarVisibility")
    vscode.call("workbench.action.toggleAuxiliaryBar")
    vscode.call("workbench.action.togglePanel")
end)
map("n", "<leader>h", function()
    local ok = pcall(vscode.call, "stm32cube-ide-clangd.switchheadersource")
    if not ok then ok = pcall(vscode.call, "clangd.switchSourceHeader") end
    if not ok then pcall(vscode.call, "C_Cpp.switchHeaderSource") end
end)
map("n", "<leader>ff", function() vscode.call("workbench.action.quickOpen") end)
map("n", "<leader>fg", function() vscode.call("workbench.action.findInFiles") end)
map("n", "gr", function() vscode.call("editor.action.goToReferences") end)
map("n", "gd", function() vscode.call("editor.action.revealDefinition") end)
map("n", "<leader>ca", function() vscode.call("editor.action.quickFix") end)
map("n", "<leader>rn", function() vscode.call("editor.action.rename") end)
map({ "n", "v" }, "gc", function() vscode.call("editor.action.commentLine") end)

-- パーサを明示的に起動（vscode-neovim では自動起動が信頼できないため）
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})

-- 日本語 IME 対策（im-select がある場合のみ）
local im_select = vim.fn.exepath("im-select")
if im_select ~= "" then
    vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
            vim.fn.system({ im_select, "com.apple.keylayout.ABC" })
        end,
    })
end
