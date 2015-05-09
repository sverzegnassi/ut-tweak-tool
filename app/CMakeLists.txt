# Make the files visible on qtcreator
file(GLOB_RECURSE QML_JS_FILES
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    *.qml *.js
)

add_custom_target(ut-tweak-tool_QMlFiles ALL SOURCES ${QML_JS_FILES})

# install app subdirs
install(DIRECTORY components DESTINATION ${UT-TWEAK-TOOL_DIR})
install(DIRECTORY scripts DESTINATION ${UT-TWEAK-TOOL_DIR})
install(DIRECTORY theme DESTINATION ${UT-TWEAK-TOOL_DIR})
install(DIRECTORY ui DESTINATION ${UT-TWEAK-TOOL_DIR})

if(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
add_custom_target(ut_tweak_tool-appdirs ALL
    COMMAND cp -r ${CMAKE_CURRENT_SOURCE_DIR}/components ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND cp -r ${CMAKE_CURRENT_SOURCE_DIR}/scripts ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND cp -r ${CMAKE_CURRENT_SOURCE_DIR}/theme ${CMAKE_CURRENT_BINARY_DIR}
    COMMAND cp -r ${CMAKE_CURRENT_SOURCE_DIR}/ui ${CMAKE_CURRENT_BINARY_DIR}
)
endif(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")

# Substitute variables in the main QML file
configure_file(main.qml ${CMAKE_CURRENT_BINARY_DIR}/main.qml)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/main.qml DESTINATION ${UT-TWEAK-TOOL_DIR})

# Substitute variables in the desktop file
configure_file(${DESKTOP_FILE_NAME}.in ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE_NAME}.in)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE_NAME} DESTINATION ${DESKTOP_DIR})

#foreach(file ${QML_JS_FILES})
#    get_filename_component(dir ${file} DIRECTORY)
#    message(${file} ${dir} ${UT-TWEAK-TOOL_DIR}/${dir})
#    install(FILES ${file} DESTINATION ${UT-TWEAK-TOOL_DIR}/${dir})
#endforeach()
