/*
  This file is part of ut-tweak-tool
  Copyright (C) 2016 Stefano Verzegnassi

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

#include "systeminfo.h"

#include <QSysInfo>
#include <QHostInfo>

#include <QFile>

#include <QDebug>

QString SystemInfo::kernelVersion() const
{
    return QSysInfo::kernelVersion();
}

QString SystemInfo::buildCpuArchitecture() const
{
    return QSysInfo::buildCpuArchitecture();
}

QString SystemInfo::currentCpuArchitecture() const
{
    return QSysInfo::currentCpuArchitecture();
}

QString SystemInfo::productName() const
{
    return QSysInfo::prettyProductName();
}

QString SystemInfo::currentDesktop() const
{
    return qgetenv("XDG_CURRENT_DESKTOP");
}

QString SystemInfo::deviceName() const
{
    // TODO: Use QSysInfo::machineHostName() as we'll have Qt 5.6
    return QHostInfo::localHostName();
}

QString SystemInfo::cpuName() const
{
    return QString();
}

int SystemInfo::memoryTotal() const
{
    QFile fi("/proc/meminfo");
    fi.open(QIODevice::ReadOnly);

    int mem = -1;

    QTextStream stream(&fi);
    QString output = stream.readAll();

    QStringList tmp = output.split(" ", QString::SkipEmptyParts);
    mem = tmp.at(tmp.indexOf("MemTotal:") + 1).toInt();

    fi.close();

    return mem;
}
