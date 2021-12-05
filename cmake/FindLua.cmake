#
# LUA_INCLUDE_DIRS
# LUA_LIBRARIES
# LUA_CFLAGS

find_package(PkgConfig QUIET)
if (PKG_CONFIG_FOUND)
	pkg_check_modules(_LUA ${LUA_VERSION})

	if (BUILD_STATIC AND NOT _LUA_FOUND)
		 message(FATAL_ERROR "Cannot find static build information")
	endif()
endif()

if (_LUA_FOUND) # we can rely on pkg-config
	if (NOT BUILD_STATIC)
		set(LUA_LIBRARIES ${_LUA_LIBRARIES})
		set(LUA_INCLUDE_DIRS ${_LUA_INCLUDE_DIRS})
		set(LUA_CFLAGS ${_LUA_CFLAGS_OTHER})
	else()
		set(LUA_LIBRARIES ${_LUA_STATIC_LIBRARIES})
		set(LUA_INCLUDE_DIRS ${_LUA_STATIC_INCLUDE_DIRS})
		set(LUA_CFLAGS ${_LUA_STATIC_CFLAGS_OTHER})
	endif()
else()
	find_path(LUA_INC
		NAMES ${LUA_VERSION} liblua
		HINTS
			ENV luaPath
		PATHS
			/usr/include/ /usr/local/include/
	)

	find_library(LUA_LIB
		NAMES lib${LUA_VERSION} liblua
		HINTS
			ENV luaPath
		PATHS
			/usr/lib /usr/local/lib
	)

	include(FindPackageHandleStandardArgs)
	find_package_handle_standard_args(LUA DEFAULT_MSG LUA_LIB LUA_INC)
	mark_as_advanced(LUA_INC LUA_LIB)

	if(LUA_FOUND)
		set(LUA_INCLUDE_DIRS ${LUA_INC})
		set(LUA_LIBRARIES ${LUA_LIB})
		if (BUILD_STATIC)
			set(LUA_LIBRARIES ${LUA_LIBRARIES} ${_LUA_STATIC_LIBRARIES})
		endif()
	endif()
endif()