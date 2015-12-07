if(CLICK_MODE)
  configure_file(manifest.json.in ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json DESTINATION ${CMAKE_INSTALL_PREFIX})
  install(FILES ut-tweak-tool.apparmor DESTINATION ${CMAKE_INSTALL_PREFIX})
endif(CLICK_MODE)


# Make the click files visible in Qt Creator
file(GLOB CLICK_FILES
  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
  *.json *.json.in *.apparmor
)

add_custom_target(ut-tweak-tool_CLICKFiles ALL SOURCES ${CLICK_FILES})
