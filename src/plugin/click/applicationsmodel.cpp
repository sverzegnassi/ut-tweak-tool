/*
  This file is part of ut-tweak-tool
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

#include "applicationsmodel.h"
#include <QDebug>

#include <QDir>
#include <QDirIterator>
#include <QSettings>
#include <QFileInfo>

ApplicationsModel::ApplicationsModel(QAbstractListModel *parent):
    QAbstractListModel(parent)
{
    this->init();
}

QHash<int, QByteArray> ApplicationsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[IconRole] = "icon";
    roles[ExecRole] = "exec";

    return roles;
}

int ApplicationsModel::rowCount(const QModelIndex & parent) const
{
    Q_UNUSED(parent)
    return m_entries.count();
}

QVariant ApplicationsModel::data(const QModelIndex & index, int role) const
{
    if (index.row() < 0 || index.row() > m_entries.count())
        return QVariant();

    const AppEntry &appEntry = m_entries.at(index.row());

    switch (role) {
    case NameRole:
        return appEntry.name;
    case IconRole:
        return appEntry.icon;
    case ExecRole:
        return appEntry.exec;

    default:
        return 0;
    }
}

void ApplicationsModel::init()
{
    m_entries.clear();

    QString userAppsFolder = QDir::homePath() + "/.local/share/applications";
    QString systemAppsFolder = "/usr/share/applications";

    QStringList userDesktopFiles = searchRecursively(userAppsFolder, QStringList("*.desktop"));
    QStringList systemDesktopFiles = searchRecursively(systemAppsFolder, QStringList("*.desktop"));

    Q_FOREACH(const QString &path, userDesktopFiles) {
        AppEntry entry = processDesktopFile(path);

        if (entry.valid) {
            m_entries.append(entry);
        }
    }

    Q_FOREACH(const QString &path, systemDesktopFiles) {
        AppEntry entry = processDesktopFile(path);

        if (entry.valid) {
            m_entries.append(entry);
        }
    }
}

QVariantMap ApplicationsModel::get(QString exec) const
{
    QVariantMap map;
    int row=0;

    Q_FOREACH(const AppEntry &entry, m_entries) {
        if (entry.exec == exec) {
            QHash<int,QByteArray> names = roleNames();
            QHashIterator<int, QByteArray> i(names);

            while (i.hasNext()) {
                i.next();
                QModelIndex idx = index(row, 0);
                QVariant data = idx.data(i.key());
                map[i.value()] = data;
            }

            break;
        }

        row++;
    }

    return map;
}

AppEntry ApplicationsModel::processDesktopFile(QString path)
{
    QSettings appInfo(path, QSettings::IniFormat);
    AppEntry appEntry;

    if (appInfo.value("Desktop Entry/X-Ubuntu-Touch", bool(false)).toBool() &&
            appInfo.value("Desktop Entry/NoDisplay", bool(true)).toBool()) {
        appEntry.name = appInfo.value("Desktop Entry/Name").toString();
        appEntry.icon = appInfo.value("Desktop Entry/Icon").toString();

        if (appInfo.contains("Desktop Entry/X-Ubuntu-Application-ID")) {
            appEntry.exec = appInfo.value("Desktop Entry/X-Ubuntu-Application-ID").toString().split("_").at(0);
        } else {
            QFileInfo fi(path);
            appEntry.exec = fi.baseName();
        }

        appEntry.valid = true;
    }

    return appEntry;
}

QStringList ApplicationsModel::searchRecursively(QString path, QStringList filters)
{
    QDirIterator dir(path, QDir::Files | QDir::NoDotAndDotDot | QDir::Readable,
                     QDirIterator::Subdirectories);

    QStringList results;
    QRegExp rx;
    while (dir.hasNext()) {
        dir.next();

        Q_FOREACH(const QString &filter, filters) {
            rx = QRegExp(filter, Qt::CaseInsensitive);
            rx.setPatternSyntax(QRegExp::Wildcard);

            if (rx.exactMatch(dir.fileName()))
                results.append(dir.fileInfo().absoluteFilePath());
        }
    }

    return results;
}

ApplicationsModel::~ApplicationsModel()
{
    //
}
