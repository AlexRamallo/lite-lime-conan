#
# PCRE_INCLUDE_DIRS
# PCRE_LIBRARIES
# PCRE_CFLAGS

find_package(PkgConfig QUIET)
if (PKG_CONFIG_FOUND)
	pkg_check_modules(_PCRE libpcre2-8)

	if (BUILD_STATIC AND NOT _PCRE_FOUND)
		 message(FATAL_ERROR "Cannot find static build information")
	endif()
endif()

if (_PCRE_FOUND) # we can rely on pkg-config
	if (NOT BUILD_STATIC)
		set(PCRE_LIBRARIES ${_PCRE_LIBRARIES})
		set(PCRE_INCLUDE_DIRS ${_PCRE_INCLUDE_DIRS})
		set(PCRE_CFLAGS ${_PCRE_CFLAGS_OTHER})
	else()
		set(PCRE_LIBRARIES ${_PCRE_STATIC_LIBRARIES})
		set(PCRE_INCLUDE_DIRS ${_PCRE_STATIC_INCLUDE_DIRS})
		set(PCRE_CFLAGS ${_PCRE_STATIC_CFLAGS_OTHER})
	endif()
else()
	find_path(PCRE_INC
		NAMES pcre2.h
		HINTS
			ENV pcrePath
		PATHS
			/usr/include/ /usr/local/include/
	)

	find_library(PCRE_LIB
		NAMES pcre
		HINTS
			ENV pcrePath
		PATHS
			/usr/lib /usr/local/lib
	)

	include(FindPackageHandleStandardArgs)
	find_package_handle_standard_args(PCRE DEFAULT_MSG PCRE_LIB PCRE_INC)
	mark_as_advanced(PCRE_INC PCRE_LIB)

	if(PCRE_FOUND)
		set(PCRE_INCLUDE_DIRS ${PCRE_INC})
		set(PCRE_LIBRARIES ${PCRE_LIB})
		if (BUILD_STATIC)
			set(PCRE_LIBRARIES ${PCRE_LIBRARIES} ${_PCRE_STATIC_LIBRARIES})
		endif()
	endif()
endif()