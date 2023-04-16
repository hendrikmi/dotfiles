local status, neosolarized = pcall(require, "neosolarized")
if not status then
	return
end

neosolarized.setup({
	comment_italics = true,
	background_set = false,
})

local cb = require("colorbuddy.init")
local Color = cb.Color
local colors = cb.colors
local Group = cb.Group
local groups = cb.groups
local styles = cb.styles

Color.new("white", "#ffffff")
Color.new("black", "#000000")
Group.new("Normal", colors.base1, colors.NONE, styles.NONE)
Group.new("CursorLine", colors.none, colors.base03, styles.NONE, colors.base1)
Group.new("CursorLineNr", colors.yellow, colors.black, styles.NONE, colors.base1)
Group.new("Visual", colors.none, colors.base03, styles.reverse)

-- background color for dianostics
-- local cError = groups.Error.fg
-- local cInfo = groups.Information.fg
-- local cWarn = groups.Warning.fg
-- local cHint = groups.Hint.fg

-- Group.new("DiagnosticVirtualTextError", cError, cError:dark():dark():dark():dark(), styles.NONE)
-- Group.new("DiagnosticVirtualTextInfo", cInfo, cInfo:dark():dark():dark(), styles.NONE)
-- Group.new("DiagnosticVirtualTextWarn", cWarn, cWarn:dark():dark():dark(), styles.NONE)
-- Group.new("DiagnosticVirtualTextHint", cHint, cHint:dark():dark():dark(), styles.NONE)
-- Group.new("DiagnosticUnderlineError", colors.none, colors.none, styles.undercurl, cError)
-- Group.new("DiagnosticUnderlineWarn", colors.none, colors.none, styles.undercurl, cWarn)
-- Group.new("DiagnosticUnderlineInfo", colors.none, colors.none, styles.undercurl, cInfo)
-- Group.new("DiagnosticUnderlineHint", colors.none, colors.none, styles.undercurl, cHint)
-- Group.new("HoverBorder", colors.yellow, colors.none, styles.NONE)
-- Group.new("TabLine", colors.none, colors.none, styles.NONE, colors.base0)

Group.new("TabLineFill", colors.none, colors.none)
Group.new("TabLineSel", colors.yellow, colors.bg)
Group.new("TabLineSeparatorSel", colors.cyan, colors.none)
