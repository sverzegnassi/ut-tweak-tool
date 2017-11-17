#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>

#include "pamauthentication.h"

#include "systemfile.h"
#include "singleprocess.h"
#include "applicationsmodel.h"
#include "packagesmodel.h"
#include "package_p.h"
#include "scopehelper.h"
#include "devicecapabilities.h"
#include "clickinstaller.h"
#include "storagemanager.h"
#include "systeminfo.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickView view;

    auto storage = new StorageManager();
    auto process = new SingleProcess();
    auto scopeHelper = new ScopeHelper();
    auto deviceCapabilities = new DeviceCapabilities();

    qmlRegisterType<PamAuthentication>("com.ubuntu.PamAuthentication", 0, 1, "PamAuthentication");

    view.rootContext()->setContextProperty("Process", process);
    view.rootContext()->setContextProperty("ScopeHelper", scopeHelper);
    view.rootContext()->setContextProperty("StorageManager", storage);
    view.rootContext()->setContextProperty("DeviceCapabilities", deviceCapabilities);

    qmlRegisterType<SystemFile>("TweakTool", 1, 0, "SystemFile");
    qmlRegisterType<ApplicationsModel>("TweakTool", 1, 0, "ApplicationsModel");
    qmlRegisterType<SystemInfo>("TweakTool", 1, 0, "SystemInfo");
    qmlRegisterType<PackagesModel>("TweakTool", 1, 0, "PackagesModel");
    qmlRegisterType<ClickInstaller>("TweakTool", 1, 0, "ClickInstaller");
    qmlRegisterUncreatableType<Package>("TweakTool", 1, 0, "Package", "Package can only be created by PackagesModel, through the get(index) method.");

    view.setSource(QUrl(QStringLiteral("qrc:///qrc/main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    return app.exec();
}
