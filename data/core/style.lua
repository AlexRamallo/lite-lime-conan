local common = require "core.common"
local style = {}

style.padding = { x = common.round(14 * SCALE), y = common.round(7 * SCALE) }
style.divider_size = common.round(1 * SCALE)
style.scrollbar_size = common.round(4 * SCALE)
style.caret_width = common.round(2 * SCALE)
style.tab_width = common.round(170 * SCALE)

-- The function renderer.font.load can accept an option table as a second optional argument.
-- It shoud be like the following:
--
-- {antialiasing= "grayscale", hinting = "full"}
--
-- The possible values for each option are:
-- - for antialiasing: grayscale, subpixel
-- - for hinting: none, slight, full
--
-- The defaults values are antialiasing subpixel and hinting slight for optimal visualization
-- on ordinary LCD monitor with RGB patterns.
--
-- On High DPI monitor or non RGB monitor you may consider using antialiasing grayscale instead.
-- The antialiasing grayscale with full hinting is interesting for crisp font rendering.
style.font = renderer.font.load(DATADIR .. "/fonts/FiraSans-Regular.ttf", 15 * SCALE)
style.big_font = style.font:copy(46 * SCALE)
style.icon_font = renderer.font.load(DATADIR .. "/fonts/icons.ttf", 16 * SCALE, {antialiasing="grayscale", hinting="full"})
style.icon_big_font = style.icon_font:copy(23 * SCALE)
style.code_font = renderer.font.load(DATADIR .. "/fonts/JetBrainsMono-Regular.ttf", 15 * SCALE)

style.background = { common.color "#282923" }
style.background2 = { common.color "#181915" }
style.background3 = { common.color "#181915" }
style.text = { common.color "#9ea191" }
style.caret = { common.color "#f8f8f2" }
style.accent = { common.color "#f8f8f2" }
style.dim = { common.color "#5e6052" }
style.divider = { common.color "#1b1c17" }
style.selection = { common.color "#3a3a32" }
style.line_number = { common.color "#90918b" }
style.line_number2 = { common.color "#d2d0c6" }
style.line_highlight = { common.color "#282923" }
style.scrollbar = { common.color "#63635f" }
style.scrollbar2 = { common.color "#3d3d38" }

style.nagbar = { common.color "#282923" }
style.nagbar_text = { common.color "#f8f8f2" }
style.nagbar_dim = { common.color "rgba(0, 0, 0, 0.45)" }
style.drag_overlay = { common.color "rgba(255,255,255,0.1)" }
style.drag_overlay_tab = { common.color "#93DDFA" }

style.syntax = {}
style.syntax["normal"] = { common.color "#f8f8f2" }
style.syntax["symbol"] = { common.color "#f8f8f2" }
style.syntax["comment"] = { common.color "#75715E" }
style.syntax["keyword"] = { common.color "#f92472" }
style.syntax["keyword2"] = { common.color "#f92472" }
style.syntax["number"] = { common.color "#ac80ff" }
style.syntax["literal"] = { common.color "#e7db74" }
style.syntax["string"] = { common.color "#e7db74" }
style.syntax["operator"] = { common.color "#f92472" }
style.syntax["function"] = { common.color "#5cd5ef" }

-- This can be used to override fonts per syntax group.
-- The syntax highlighter will take existing values from this table and
-- override style.code_font on a per-token basis, so you can choose to eg.
-- render comments in an italic font if you want to.
style.syntax_fonts = {}
-- style.syntax_fonts["comment"] = renderer.font.load(path_to_font, size_of_font, rendering_options)

return style
