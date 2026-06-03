-- Sigewinne Hydro colorscheme for Neovim
-- Place at: ~/.config/nvim/colors/sigewinne-hydro.lua
-- Load with: vim.cmd("colorscheme sigewinne-hydro")

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.g.colors_name = "sigewinne-hydro"
vim.o.background = "dark"

local c = {
  bg0        = "#0c1218", bg1 = "#0e141c", bg2 = "#101820",
  bg3        = "#131a24", bg4 = "#182028", bg5 = "#1a2230",
  bg6        = "#1e2a38", bg7 = "#283848",
  fg0        = "#364858", fg1 = "#405060", fg2 = "#506878",
  fg3        = "#607888", fg4 = "#8898a8", fg5 = "#c0ccda",
  blue       = "#5aa8c8", blue_l = "#78bcd8", blue_d = "#88b8d0",
  slate      = "#90a4c8", green = "#70b898", green_br = "#88c8a8",
  yellow     = "#c8a860", yellow_br = "#d4b878",
  red        = "#c07878", red_br = "#d09090",
  magenta    = "#d0909e", magenta_br = "#daa0b0",
  cyan       = "#60b0b8", cyan_br = "#78c0c8",
}

local function hi(g, o) vim.api.nvim_set_hl(0, g, o) end

-- Editor
hi("Normal",          {fg=c.fg5,   bg=c.bg3})
hi("NormalNC",        {fg=c.fg5,   bg=c.bg2})
hi("NormalFloat",     {fg=c.fg5,   bg=c.bg2})
hi("FloatBorder",     {fg=c.bg6,   bg=c.bg2})
hi("Cursor",          {fg=c.bg0,   bg=c.blue})
hi("CursorLine",      {bg=c.bg5})
hi("CursorLineNr",    {fg=c.blue,  bold=true})
hi("LineNr",          {fg=c.fg0})
hi("SignColumn",      {fg=c.fg0,   bg=c.bg3})
hi("ColorColumn",     {bg=c.bg5})
hi("EndOfBuffer",     {fg=c.bg6})
hi("NonText",         {fg=c.bg6})
hi("Whitespace",      {fg=c.bg6})
hi("Visual",          {bg=c.bg5})
hi("Search",          {fg=c.bg0,   bg=c.yellow})
hi("IncSearch",       {fg=c.bg0,   bg=c.blue})
hi("CurSearch",       {fg=c.bg0,   bg=c.blue})
hi("MatchParen",      {fg=c.blue,  bg=c.bg5, bold=true})
hi("WinSeparator",    {fg=c.bg0})
hi("Folded",          {fg=c.fg2,   bg=c.bg5})
hi("FoldColumn",      {fg=c.fg0,   bg=c.bg3})

-- Statusline / Tabline
hi("StatusLine",      {fg=c.fg4,   bg=c.bg0})
hi("StatusLineNC",    {fg=c.fg2,   bg=c.bg0})
hi("TabLine",         {fg=c.fg2,   bg=c.bg1})
hi("TabLineSel",      {fg=c.fg5,   bg=c.bg3, bold=true})
hi("TabLineFill",     {bg=c.bg1})

-- Popup / Completion
hi("Pmenu",           {fg=c.fg5,   bg=c.bg2})
hi("PmenuSel",        {fg=c.fg5,   bg=c.bg5})
hi("PmenuSbar",       {bg=c.bg6})
hi("PmenuThumb",      {bg=c.bg7})

-- Messages / Notifications
hi("ErrorMsg",        {fg=c.red})
hi("WarningMsg",      {fg=c.yellow})
hi("MoreMsg",         {fg=c.green})
hi("Question",        {fg=c.blue})
hi("Title",           {fg=c.blue,  bold=true})

-- Diagnostics
hi("DiagnosticError",          {fg=c.red})
hi("DiagnosticWarn",           {fg=c.yellow})
hi("DiagnosticInfo",           {fg=c.blue})
hi("DiagnosticHint",           {fg=c.green})
hi("DiagnosticUnderlineError", {sp=c.red,    underline=true})
hi("DiagnosticUnderlineWarn",  {sp=c.yellow, underline=true})
hi("DiagnosticUnderlineInfo",  {sp=c.blue,   underline=true})
hi("DiagnosticUnderlineHint",  {sp=c.green,  underline=true})
hi("DiagnosticVirtualTextError",{fg=c.red,    bg=c.bg3, italic=true})
hi("DiagnosticVirtualTextWarn", {fg=c.yellow, bg=c.bg3, italic=true})
hi("DiagnosticVirtualTextInfo", {fg=c.blue,   bg=c.bg3, italic=true})
hi("DiagnosticVirtualTextHint", {fg=c.green,  bg=c.bg3, italic=true})

-- Diff
hi("DiffAdd",    {fg=c.green,  bg=c.bg3})
hi("DiffChange", {fg=c.yellow, bg=c.bg3})
hi("DiffDelete", {fg=c.red,    bg=c.bg3})
hi("DiffText",   {fg=c.blue,   bg=c.bg3})
hi("Added",      {fg=c.green})
hi("Changed",    {fg=c.yellow})
hi("Removed",    {fg=c.red})

-- Syntax
hi("Comment",      {fg=c.fg0,    italic=true})
hi("Constant",     {fg=c.slate})
hi("String",       {fg=c.green})
hi("Character",    {fg=c.cyan})
hi("Number",       {fg=c.slate})
hi("Boolean",      {fg=c.slate})
hi("Identifier",   {fg=c.fg5})
hi("Function",     {fg=c.yellow})
hi("Statement",    {fg=c.blue})
hi("Keyword",      {fg=c.blue})
hi("Operator",     {fg=c.fg4})
hi("PreProc",      {fg=c.magenta})
hi("Include",      {fg=c.blue})
hi("Macro",        {fg=c.magenta})
hi("Type",         {fg=c.blue_l})
hi("StorageClass", {fg=c.blue})
hi("Special",      {fg=c.cyan})
hi("Delimiter",    {fg=c.fg3})
hi("Error",        {fg=c.red})
hi("Todo",         {fg=c.bg0, bg=c.yellow, bold=true})

-- Treesitter
hi("@comment",               {fg=c.fg0,    italic=true})
hi("@comment.documentation", {fg=c.fg2,    italic=true})
hi("@keyword",               {fg=c.blue})
hi("@keyword.import",        {fg=c.blue})
hi("@keyword.return",        {fg=c.blue})
hi("@keyword.operator",      {fg=c.fg4})
hi("@variable",              {fg=c.fg5})
hi("@variable.builtin",      {fg=c.blue,   italic=true})
hi("@variable.parameter",    {fg=c.fg5,    italic=true})
hi("@variable.member",       {fg=c.blue_d})
hi("@string",                {fg=c.green})
hi("@string.escape",         {fg=c.cyan})
hi("@string.regex",          {fg=c.cyan})
hi("@number",                {fg=c.slate})
hi("@boolean",               {fg=c.slate})
hi("@constant",              {fg=c.slate})
hi("@constant.builtin",      {fg=c.slate})
hi("@constant.macro",        {fg=c.magenta})
hi("@function",              {fg=c.yellow})
hi("@function.call",         {fg=c.yellow})
hi("@function.builtin",      {fg=c.yellow})
hi("@function.method",       {fg=c.yellow})
hi("@function.macro",        {fg=c.magenta})
hi("@type",                  {fg=c.blue_l})
hi("@type.builtin",          {fg=c.blue_l})
hi("@type.qualifier",        {fg=c.blue})
hi("@constructor",           {fg=c.blue_l})
hi("@operator",              {fg=c.fg4})
hi("@punctuation",           {fg=c.fg3})
hi("@punctuation.bracket",   {fg=c.fg3})
hi("@punctuation.delimiter", {fg=c.fg3})
hi("@namespace",             {fg=c.blue_l})
hi("@module",                {fg=c.blue_l})
hi("@attribute",             {fg=c.magenta, italic=true})
hi("@property",              {fg=c.blue_d})
hi("@tag",                   {fg=c.blue})
hi("@tag.attribute",         {fg=c.yellow, italic=true})
hi("@tag.delimiter",         {fg=c.fg2})
hi("@markup.heading",        {fg=c.blue,   bold=true})
hi("@markup.strong",         {bold=true})
hi("@markup.italic",         {italic=true})
hi("@markup.link",           {fg=c.green,  underline=true})
hi("@markup.raw",            {fg=c.yellow})

-- LSP Semantic Tokens
hi("@lsp.type.namespace",    {fg=c.blue_l})
hi("@lsp.type.type",         {fg=c.blue_l})
hi("@lsp.type.class",        {fg=c.blue_l})
hi("@lsp.type.interface",    {fg=c.blue_l, italic=true})
hi("@lsp.type.enum",         {fg=c.blue_l})
hi("@lsp.type.enumMember",   {fg=c.slate})
hi("@lsp.type.function",     {fg=c.yellow})
hi("@lsp.type.method",       {fg=c.yellow})
hi("@lsp.type.macro",        {fg=c.magenta})
hi("@lsp.type.variable",     {fg=c.fg5})
hi("@lsp.type.parameter",    {fg=c.fg5,    italic=true})
hi("@lsp.type.property",     {fg=c.blue_d})
hi("@lsp.type.decorator",    {fg=c.magenta, italic=true})
hi("@lsp.mod.readonly",      {fg=c.slate})

-- Git signs
hi("GitSignsAdd",    {fg=c.green})
hi("GitSignsChange", {fg=c.yellow})
hi("GitSignsDelete", {fg=c.red})

-- Telescope
hi("TelescopeBorder",       {fg=c.bg6,  bg=c.bg2})
hi("TelescopeNormal",       {fg=c.fg5,  bg=c.bg2})
hi("TelescopePromptBorder", {fg=c.blue, bg=c.bg5})
hi("TelescopePromptNormal", {fg=c.fg5,  bg=c.bg5})
hi("TelescopePromptTitle",  {fg=c.bg0,  bg=c.blue,  bold=true})
hi("TelescopePreviewTitle", {fg=c.bg0,  bg=c.green, bold=true})
hi("TelescopeResultsTitle", {fg=c.bg0,  bg=c.bg6})
hi("TelescopeSelection",    {fg=c.fg5,  bg=c.bg5})
hi("TelescopeMatching",     {fg=c.blue, bold=true})

-- nvim-cmp
hi("CmpItemAbbr",           {fg=c.fg5})
hi("CmpItemAbbrMatch",      {fg=c.blue, bold=true})
hi("CmpItemKind",           {fg=c.blue_d})
hi("CmpItemMenu",           {fg=c.fg2,  italic=true})

-- Which-key
hi("WhichKey",      {fg=c.blue})
hi("WhichKeyGroup", {fg=c.green})
hi("WhichKeyDesc",  {fg=c.fg5})

-- Indent Blankline
hi("IblIndent", {fg=c.bg6})
hi("IblScope",  {fg=c.bg7})

-- NvimTree
hi("NvimTreeNormal",           {fg=c.fg4, bg=c.bg2})
hi("NvimTreeRootFolder",       {fg=c.blue, bold=true})
hi("NvimTreeOpenedFolderName", {fg=c.blue})
hi("NvimTreeGitDirty",         {fg=c.yellow})
hi("NvimTreeGitNew",           {fg=c.green})
hi("NvimTreeGitDeleted",       {fg=c.red})
hi("NvimTreeIndentMarker",     {fg=c.bg6})
