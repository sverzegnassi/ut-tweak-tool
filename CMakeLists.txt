project(ut-tweak-tool.sverzegnassi C CXX)
cmake_minimum_required(VERSION 2.8.9)

# Do not remove this line, its required for the correct functionality of the Ubuntu-SDK
set(UBUNTU_MANIFEST_PATH "manifest.json.in" CACHE INTERNAL "Tells QtCreator location and name of the manifest file")
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

find_package(Qt5Core)
find_package(Qt5Qml)
find_package(Qt5Quick)
# find_package(ubuntu-sdk-libs)

# Automatically create moc files
set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fno-permissive -pedantic -Wall -Wextra -fPIC")

# Components PATH
execute_process(
    COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
    OUTPUT_VARIABLE ARCH_TRIPLET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(QT_IMPORTS_DIR "lib/${ARCH_TRIPLET}")

option(INSTALL_TESTS "Install the tests on make install" on)

set(APP_NAME           "Ubuntu Touch Tweak Tool")
set(APP_DESC           "Tweak your device! Unlock its full power!")
set(APP_ID             ${PROJECT_NAME})
set(APP_LICENSE        "GNU GPL v3")
set(APP_COPYRIGHT_YEAR "2015")
set(APP_VERSION        "0.1")
set(APP_SOURCE_URL     "https://code.launchpad.net/~verzegnassi-stefano/+junk/ut-tweak-tool")
set(APP_SOURCE_SERVICE "launchpad.net")
set(LP_PROJECT         "")
set(UT-TWEAK-TOOL_DIR  "share/qml/ut-tweak-tool")
set(MAIN_QML           "main.qml")
set(ICON               "graphics/ut-tweak-tool.png")
set(ICON_PATH_FROM_MAIN_QML "../../../../../${ICON}")

# Sets BZR_REVNO
execute_process(
    COMMAND bzr revno ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE BZR_REVNO
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if(NOT BZR_REVNO)
    set(BZR_REVNO "latest")
endif(NOT BZR_REVNO)

# Set install paths
set(CMAKE_INSTALL_PREFIX /)
set(DATA_DIR /)
set(DESKTOP_DIR ${DATA_DIR})
set(DESKTOP_FILE_NAME "ut-tweak-tool.desktop")

set(EXEC "qmlscene $@ ${UT-TWEAK-TOOL_DIR}/${MAIN_QML}")

# This command figures out the target architecture for use in the manifest file
execute_process(
  COMMAND dpkg-architecture -qDEB_HOST_ARCH
  OUTPUT_VARIABLE CLICK_ARCH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

configure_file(manifest.json.in ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json
        DESTINATION ${CMAKE_INSTALL_PREFIX})
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json
        DESTINATION ${UT-TWEAK-TOOL_DIR})

install(DIRECTORY "app/graphics" DESTINATION ${DATA_DIR})
install(FILES "ut-tweak-tool.apparmor" DESTINATION ${DATA_DIR})
install(FILES "COPYING" DESTINATION ${DATA_DIR})
install(FILES "copyright" DESTINATION ${DATA_DIR})

add_subdirectory(app)
add_subdirectory(plugins)
add_subdirectory(po)

add_custom_target("autopilot" chmod +x ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
                    COMMAND ${CMAKE_SOURCE_DIR}/app/tests/autopilot/run
                    WORKING_DIRECTORY ./app)

add_custom_target("check" /usr/bin/qmltestrunner -input ${CMAKE_SOURCE_DIR}/app/tests/unit -import ${CMAKE_BINARY_DIR}/plugins
                    WORKING_DIRECTORY ./app)

add_custom_target("run" /usr/bin/qmlscene -I ${CMAKE_BINARY_DIR}/plugins  ${CMAKE_SOURCE_DIR}/app/main.qml
                    WORKING_DIRECTORY ./app)

# No op custom target for all not compiled files, so they show up in the QtCreator project tree
add_custom_target("ut-tweak-tool_ClickFiles" ALL SOURCES "ut-tweak-tool.apparmor" "manifest.json.in")

