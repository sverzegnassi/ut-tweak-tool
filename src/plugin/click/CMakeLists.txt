set(PLUGIN_DIR TweakTool/Click)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

#add the sources to compile
set(click_SRCS
    applicationsmodel.cpp
    backend.cpp
)

add_library(tweaktoolclickplugin MODULE
    ${click_SRCS}
)

qt5_use_modules(tweaktoolclickplugin Qml Quick)

# Copy the plugin, the qmldir file and other assets to the build dir for running in QtCreator
if(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
add_custom_command(TARGET tweaktoolclickplugin POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/qmldir ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:tweaktoolclickplugin> ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
)
endif(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")

# Install plugin file
install(TARGETS tweaktoolclickplugin DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN_DIR})
install(FILES qmldir DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN_DIR})
