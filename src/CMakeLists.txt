set(C_STANDARD gnu11)

set(MAIN_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/app.c
    ${CMAKE_CURRENT_SOURCE_DIR}/app.h
    ${CMAKE_CURRENT_SOURCE_DIR}/dirmonitor.c
    ${CMAKE_CURRENT_SOURCE_DIR}/dirmonitor.h
    ${CMAKE_CURRENT_SOURCE_DIR}/flag.c
    ${CMAKE_CURRENT_SOURCE_DIR}/flag.h
    ${CMAKE_CURRENT_SOURCE_DIR}/rencache.c
    ${CMAKE_CURRENT_SOURCE_DIR}/rencache.h
    ${CMAKE_CURRENT_SOURCE_DIR}/renderer.c
    ${CMAKE_CURRENT_SOURCE_DIR}/renderer.h
    ${CMAKE_CURRENT_SOURCE_DIR}/renwindow.c
    ${CMAKE_CURRENT_SOURCE_DIR}/renwindow.h
    ${CMAKE_CURRENT_SOURCE_DIR}/main.c
)

set(API_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/api/api.c
    ${CMAKE_CURRENT_SOURCE_DIR}/api/api.h
    ${CMAKE_CURRENT_SOURCE_DIR}/api/process.c
    ${CMAKE_CURRENT_SOURCE_DIR}/api/regex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/api/renderer.c
    ${CMAKE_CURRENT_SOURCE_DIR}/api/system.c
)

#Package names from Conan are slightly different
find_package(lua REQUIRED)
find_package(pcre2 REQUIRED)
find_package(Freetype REQUIRED)
find_package(SDL2 REQUIRED)

set(CFLAGS
    -Wall -Wextra -pedantic
    -Wconversion -Wshadow -Wstrict-aliasing
    -Winit-self -Wcast-align -Wpointer-arith
    -Wmissing-declarations -Wmissing-include-dirs
    -Wno-unused-parameter -Wuninitialized
    ${lua_CFLAGS}
    ${pcre2_CFLAGS}
    ${Freetype_CFLAGS}
)


add_library(core OBJECT ${MAIN_SOURCES})
target_include_directories(core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(core PUBLIC ${PROJECT_SOURCE_DIR}/lib/dmon)
target_include_directories(core PUBLIC ${lua_INCLUDE_DIRS})
target_include_directories(core PUBLIC ${pcre2_INCLUDE_DIRS})
target_include_directories(core PUBLIC ${Freetype_INCLUDE_DIRS})
target_include_directories(core PUBLIC ${SDL2_INCLUDE_DIR})

add_library(api OBJECT ${API_SOURCES})
target_include_directories(api PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(api PUBLIC ${PROJECT_SOURCE_DIR}/lib/dmon)
target_include_directories(api PUBLIC ${lua_INCLUDE_DIRS})
target_include_directories(api PUBLIC ${pcre2_INCLUDE_DIRS})
target_include_directories(api PUBLIC ${Freetype_INCLUDE_DIRS})
target_include_directories(api PUBLIC ${SDL2_INCLUDE_DIR})

target_compile_options(core PUBLIC ${CFLAGS})

add_executable(${CMAKE_PROJECT_NAME} $<TARGET_OBJECTS:core> $<TARGET_OBJECTS:api>)

target_link_libraries(${CMAKE_PROJECT_NAME} LINK_PUBLIC m dl)
target_link_libraries(${CMAKE_PROJECT_NAME} LINK_PUBLIC ${lua_LIBRARIES})
target_link_libraries(${CMAKE_PROJECT_NAME} LINK_PUBLIC ${pcre2_LIBRARIES})
target_link_libraries(${CMAKE_PROJECT_NAME} LINK_PUBLIC ${Freetype_LIBRARIES})
target_link_libraries(${CMAKE_PROJECT_NAME} LINK_PUBLIC ${SDL2_LIBRARY})


add_custom_command(
    OUTPUT ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/data
    COMMAND ${CMAKE_COMMAND}
    -E create_symlink
    ${PROJECT_SOURCE_DIR}/data
    ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/data
)

add_custom_target(link_data_dir ALL DEPENDS ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/data)

add_dependencies(${CMAKE_PROJECT_NAME} link_data_dir)

include(GNUInstallDirs)
install(TARGETS ${CMAKE_PROJECT_NAME})
install(DIRECTORY ${PROJECT_SOURCE_DIR}/data/ DESTINATION ${CMAKE_INSTALL_DATADIR}/${CMAKE_PROJECT_NAME})
install(FILES ${PROJECT_SOURCE_DIR}/resources/linux/org.lite_lime.lite_lime.desktop DESTINATION ${CMAKE_INSTALL_DATADIR}/applications/)
install(FILES ${PROJECT_SOURCE_DIR}/resources/linux/org.lite_lime.lite_lime.appdata.xml DESTINATION ${CMAKE_INSTALL_DATADIR}/metainfo/)
install(FILES ${PROJECT_SOURCE_DIR}/resources/icons/lite-lime.svg DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps/)