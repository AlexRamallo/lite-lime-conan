local core = require "core"
local syntax = require "core.syntax"
local common = require "core.common"
local command = require "core.command"
local config = require "core.config"
local style = require "core.style"
local DocView = require "core.docview"
local LogView = require "core.logview"
local View = require "core.view"
local Object = require "core.object"


local StatusView = View:extend()

StatusView.separator  = "      "
StatusView.separator2 = "   |   "


function StatusView:new()
  StatusView.super.new(self)
  self.message_timeout = 0
  self.message = {}
  self.tooltip_mode = false
  self.tooltip = {}
end


function StatusView:on_mouse_pressed()
  core.set_active_view(core.last_active_view)
  if system.get_time() < self.message_timeout
  and not core.active_view:is(LogView) then
    command.perform "core:open-log"
  end
end


function StatusView:show_message(icon, icon_color, text)
  self.message = {
    icon_color, style.icon_font, icon,
    style.dim, style.font, StatusView.separator2, style.text, text
  }
  self.message_timeout = system.get_time() + config.message_timeout
end


function StatusView:show_tooltip(text)
  self.tooltip = { text }
  self.tooltip_mode = true
end


function StatusView:remove_tooltip()
  self.tooltip_mode = false
end


function StatusView:update()
  self.size.y = style.font:get_height() + style.padding.y * 2

  if system.get_time() < self.message_timeout then
    self.scroll.to.y = self.size.y
  else
    self.scroll.to.y = 0
  end

  StatusView.super.update(self)
end


local function draw_items(self, items, x, y, draw_fn)
  local font = style.font
  local color = style.text

  for _, item in ipairs(items) do
    if Object.is(item, renderer.font) then
      font = item
    elseif type(item) == "table" then
      color = item
    else
      x = draw_fn(font, color, item, nil, x, y, 0, self.size.y)
    end
  end

  return x
end


local function text_width(font, _, text, _, x)
  return x + font:get_width(text)
end


function StatusView:draw_items(items, right_align, yoffset)
  local x, y = self:get_content_offset()
  y = y + (yoffset or 0)
  if right_align then
    local w = draw_items(self, items, 0, 0, text_width)
    x = x + self.size.x - w - style.padding.x
    draw_items(self, items, x, y, common.draw_text)
  else
    x = x + style.padding.x
    draw_items(self, items, x, y, common.draw_text)
  end
end


function StatusView:get_items()
  if getmetatable(core.active_view) == DocView then
    local dv = core.active_view
    local line, col = dv.doc:get_selection()
    local dirty = dv.doc:is_dirty()
    local indent_type, indent_size, indent_confirmed = dv.doc:get_indent_info()
    local indent_label = (indent_type == "hard") and "tabs: " or "spaces: "
    local indent_size_str = tostring(indent_size) .. (indent_confirmed and "" or "*") or "unknown"
    local lang_name = dv.doc.syntax.name

    return {
      dirty and style.accent or style.text, style.icon_font, "f",
      style.dim, style.font, self.separator2, style.text,
      "Line ", line, ", Column: ", col,
    }, {
      style.text, indent_label, indent_size,
      self.separator,
      lang_name
    }
  end

  return {}, {}
end


function StatusView:draw()
  self:draw_background(style.background2)

  if self.message then
    self:draw_items(self.message, false, self.size.y)
  end

  if self.tooltip_mode then
    self:draw_items(self.tooltip)
  else
    local left, right = self:get_items()
    self:draw_items(left)
    self:draw_items(right, true)
  end
end


return StatusView
