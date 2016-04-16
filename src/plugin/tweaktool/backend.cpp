/*
  Copyright (C) 2015 Stefano Verzegnassi

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License 3 as published by
  the Free Software Foundation.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see http://www.gnu.org/licenses/.
*/

#include <QtQml>
#include <QtQml/QQmlContext>
#include "backend.h"
#include "systemfile.h"
#include "singleprocess.h"
#include "applicationsmodel.h"
#include "packagesmodel.h"
#include "package_p.h"

static QObject *registerSingletonProcess (QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    SingleProcess *process = new SingleProcess();
    return process;
}

void BackendPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("TweakTool"));

    qmlRegisterSingletonType<SingleProcess>(uri, 1, 0, "Process", registerSingletonProcess);
    qmlRegisterType<SystemFile>(uri, 1, 0, "SystemFile");
    qmlRegisterType<ApplicationsModel>(uri, 1, 0, "ApplicationsModel");
    qmlRegisterType<PackagesModel>(uri, 1, 0, "PackagesModel");
    qmlRegisterUncreatableType<Package>(uri, 1, 0, "Package", "Package can only be created by PackagesModel, through the get(index) method.");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}

