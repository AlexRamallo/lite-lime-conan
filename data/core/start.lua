-- this file is used by lite-lime to setup the Lua environment when starting
MOD_VERSION = "2"

SCALE = tonumber(os.getenv("LITE_SCALE") or os.getenv("GDK_SCALE") or os.getenv("QT_SCALE_FACTOR")) or SCALE
PATHSEP = package.config:sub(1, 1)

EXEDIR = EXEFILE:match("^(.+)[/\\][^/\\]+$")
if MACOS_RESOURCES then
  DATADIR = MACOS_RESOURCES
else
  local prefix = EXEDIR:match("^(.+)[/\\]bin$")
  DATADIR = prefix and (prefix .. '/share/lite-lime') or (EXEDIR .. '/data')
end
USERDIR = (os.getenv("XDG_CONFIG_HOME") and os.getenv("XDG_CONFIG_HOME") .. "/lite-lime")
  or (HOME and (HOME .. '/.config/lite-lime') or (EXEDIR .. '/user'))

package.path = DATADIR .. '/?.lua;' .. package.path
package.path = DATADIR .. '/?/init.lua;' .. package.path
package.path = USERDIR .. '/?.lua;' .. package.path
package.path = USERDIR .. '/?/init.lua;' .. package.path

local dynamic_suffix = PLATFORM == "Mac OS X" and 'lib' or (PLATFORM == "Windows" and 'dll' or 'so')
package.cpath = DATADIR .. '/?.' .. dynamic_suffix .. ";" .. USERDIR .. '/?.' .. dynamic_suffix
package.native_plugins = {}
package.searchers = { package.searchers[1], package.searchers[2], function(modname)
  local path = package.searchpath(modname, package.cpath)
  if not path then return nil end
  return system.load_native_plugin, path
end }

table.pack = table.pack or pack or function(...) return {...} end
table.unpack = table.unpack or unpack
