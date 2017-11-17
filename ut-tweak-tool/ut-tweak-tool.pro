TEMPLATE = app
TARGET = ut-tweak-tool

load(ubuntu-click)

CONFIG += c++11
QT += qml quick dbus
LIBS += -lgsettings-qt -lpam

SOURCES += main.cpp \
    systeminfo.cpp \
    systemfile.cpp \
    storagemanager.cpp \
    singleprocess.cpp \
    scopehelper.cpp \
    pamauthentication.cpp \
    packagesmodel.cpp \
    package.cpp \
    devicecapabilities.cpp \
    clickinstaller.cpp \
    desktopfileutils.cpp \
    applicationsmodel.cpp

RESOURCES += ut-tweak-tool.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  ut-tweak-tool.apparmor \
               ut-tweak-tool.png

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               ut-tweak-tool.desktop

#specify where the config files are installed to
config_files.path = /ut-tweak-tool
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /ut-tweak-tool
desktop_file.files = $$OUT_PWD/ut-tweak-tool.desktop
desktop_file.CONFIG += no_check_exist
INSTALLS+=desktop_file

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

HEADERS += \
    systemfile.h \
    storagemanager.h \
    singleprocess.h \
    scopehelper.h \
    pamauthentication.h \
    packagesmodel.h \
    package_p.h \
    devicecapabilities.h \
    desktopfileutils.h \
    applicationsmodel.h \
    systeminfo.h \
    clickinstaller.h
