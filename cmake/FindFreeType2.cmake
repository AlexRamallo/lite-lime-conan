#
# FREETYPE2_INCLUDE_DIRS
# FREETYPE2_LIBRARIES
# FREETYPE2_CFLAGS

find_package(PkgConfig QUIET)
if (PKG_CONFIG_FOUND)
	pkg_check_modules(_FREETYPE2 freetype2)

	if (BUILD_STATIC AND NOT _FREETYPE2_FOUND)
		 message(FATAL_ERROR "Cannot find static build information")
	endif()
endif()

if (_FREETYPE2_FOUND) # we can rely on pkg-config
	if (NOT BUILD_STATIC)
		set(FREETYPE2_LIBRARIES ${_FREETYPE2_LIBRARIES})
		set(FREETYPE2_INCLUDE_DIRS ${_FREETYPE2_INCLUDE_DIRS})
		set(FREETYPE2_CFLAGS ${_FREETYPE2_CFLAGS_OTHER})
	else()
		set(FREETYPE2_LIBRARIES ${_FREETYPE2_STATIC_LIBRARIES})
		set(FREETYPE2_INCLUDE_DIRS ${_FREETYPE2_STATIC_INCLUDE_DIRS})
		set(FREETYPE2_CFLAGS ${_FREETYPE2_STATIC_CFLAGS_OTHER})
	endif()
else()
	find_path(FREETYPE2_INC
		NAMES ft2build.h
		HINTS
			ENV freetype2Path
		PATHS
			/usr/include/freetype2 /usr/local/include/freetype2
	)

	find_library(FREETYPE2_LIB
		NAMES freetype fretype2
		HINTS
			ENV freetype2Path
		PATHS
			/usr/lib/ /usr/local/lib
	)

	include(FindPackageHandleStandardArgs)
	find_package_handle_standard_args(FREETYPE2 DEFAULT_MSG FREETYPE2_LIB FREETYPE2_INC)
	mark_as_advanced(FREETYPE2_INC FREETYPE2_LIB)

	if(FREETYPE2_FOUND)
		set(FREETYPE2_INCLUDE_DIRS ${FREETYPE2_INC})
		set(FREETYPE2_LIBRARIES ${FREETYPE2_LIB})
		if (BUILD_STATIC)
			set(FREETYPE2_LIBRARIES ${FREETYPE2_LIBRARIES} ${_FREETYPE2_STATIC_LIBRARIES})
		endif()
	endif()
endif()