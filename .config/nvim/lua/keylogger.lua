-- keylogger.lua
-- vim.on_key を使いプラグインのキーマップと干渉せず記録する
--
-- 使い方（init.lua の末尾に追記）:
--   require('keylogger').start()
--
-- 停止:
--   :lua require('keylogger').stop()
--
-- ログクリア:
--   :lua require('keylogger').clear()

local M = {}

local log_path = vim.fn.expand("~/nvim_keylog.txt")
local ns_id = nil  -- on_key のハンドラID

-- ログに1行書き込む
local function write(line)
  local f = io.open(log_path, "a")
  if f then
    f:write(line .. "\n")
    f:close()
  end
end

local function ts()
  return os.date("%H:%M:%S")
end

local function cursor_pos()
  local ok, pos = pcall(vim.api.nvim_win_get_cursor, 0)
  if not ok then return "?:?" end
  return string.format("L%d:C%d", pos[1], pos[2] + 1)
end

local function filename()
  local name = vim.fn.expand("%:t")
  return name ~= "" and name or "[no name]"
end

local mode_names = {
  n         = "NORMAL",
  i         = "INSERT",
  v         = "VISUAL",
  V         = "V-LINE",
  ["\22"]   = "V-BLOCK",  -- Ctrl-V
  c         = "COMMAND",
  R         = "REPLACE",
  s         = "SELECT",
  t         = "TERMINAL",
}

-- 制御文字を人間が読める形式に変換
local function key_display(key)
  if key == "\27" then return "<Esc>" end
  if key == "\r" then return "<CR>" end
  if key == "\t" then return "<Tab>" end
  if key == "\8" or key == "\127" then return "<BS>" end
  if key == " " then return "<Space>" end
  -- Ctrl 系
  local byte = string.byte(key)
  if byte and byte >= 1 and byte <= 26 then
    return string.format("<C-%s>", string.char(byte + 96))
  end
  -- 印字可能文字
  if byte and byte >= 32 and byte < 127 then return key end
  -- その他（特殊キーのバイト列など）は16進で表示
  return string.format("<0x%02x>", byte or 0)
end

local last_mode = nil
local autocmd_group = nil

function M.start()
  if ns_id then
    vim.notify("keylogger: already running", vim.log.levels.WARN)
    return
  end

  -- キーストローク記録
  ns_id = vim.on_key(function(key)
    vim.schedule(function()
      local mode = vim.api.nvim_get_mode().mode
      local mode_name = mode_names[mode] or mode

      -- モード遷移を検出
      if mode_name ~= last_mode then
        write(string.format(
          "[%s] MODE  %-10s  %s  %s",
          ts(), mode_name, cursor_pos(), filename()
        ))
        last_mode = mode_name
      end

      -- キーを記録（インサートモードは制御文字のみ、文字入力は量が多いためスキップ）
      local display = key_display(key)
      local byte = string.byte(key)
      local is_printable = byte and byte >= 32 and byte < 127
      if not (mode == "i" and is_printable) then
        write(string.format(
          "[%s] KEY   %-10s  %s  %s",
          ts(), display, cursor_pos(), filename()
        ))
      end
    end)
  end)

  -- ModeChanged でも補完（on_key だけでは拾えないケース用）
  autocmd_group = vim.api.nvim_create_augroup("KeyLogger", { clear = true })
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = autocmd_group,
    callback = function()
      vim.schedule(function()
        local mode = vim.api.nvim_get_mode().mode
        local mode_name = mode_names[mode] or mode
        if mode_name ~= last_mode then
          write(string.format(
            "[%s] MODE  %-10s  %s  %s",
            ts(), mode_name, cursor_pos(), filename()
          ))
          last_mode = mode_name
        end
      end)
    end,
  })

  write(string.format(
    "\n=== Session started: %s ===",
    os.date("%Y-%m-%d %H:%M:%S")
  ))
  vim.notify("keylogger: started -> " .. log_path, vim.log.levels.INFO)
end

function M.stop()
  if not ns_id then
    vim.notify("keylogger: not running", vim.log.levels.WARN)
    return
  end
  vim.on_key(nil, ns_id)
  ns_id = nil

  if autocmd_group then
    vim.api.nvim_del_augroup_by_id(autocmd_group)
    autocmd_group = nil
  end

  write(string.format("=== Session ended:   %s ===\n", os.date("%Y-%m-%d %H:%M:%S")))
  vim.notify("keylogger: stopped", vim.log.levels.INFO)
end

function M.clear()
  local f = io.open(log_path, "w")
  if f then
    f:close()
    vim.notify("keylogger: log cleared", vim.log.levels.INFO)
  end
end

return M
