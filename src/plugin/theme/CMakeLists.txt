set(PLUGIN_DIR TweakTool/OrangeTheme)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Make file visible in QtCreator
file(GLOB_RECURSE THEME_SRCS *.qml *.js parent_theme)
add_custom_target(theme_FILES ALL SOURCES ${THEME_SRCS})

# Copy the plugin, the qmldir file and other assets to the build dir for running in QtCreator
if(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
add_custom_target(tweaktooltheme ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/parent_theme ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/PageHeadStyle.qml ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
)
endif(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")

# Install plugin file
install(FILES parent_theme DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN_DIR})
install(FILES PageHeadStyle.qml DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN_DIR})
