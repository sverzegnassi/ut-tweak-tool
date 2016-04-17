/*
  Copyright (C) 2015, 2016 Stefano Verzegnassi

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

#include <QDir>
#include <QDirIterator>
#include <QSettings>
#include <QFileInfo>

#include <QDebug>

#define DESKTOP_FILES_FOLDER_USER       QDir::homePath() + "/.local/share/applications"
#define DESKTOP_FILES_FOLDER_SYSTEM     "/usr/share/applications"

#define DESKTOP_FILE_KEY_NAME           "Desktop Entry/Name"
#define DESKTOP_FILE_KEY_ICON           "Desktop Entry/Icon"
#define DESKTOP_FILE_KEY_NO_DISPLAY     "Desktop Entry/NoDisplay"
#define DESKTOP_FILE_KEY_APP_ID         "Desktop Entry/X-Ubuntu-Application-ID"
#define DESKTOP_FILE_KEY_UBUNTU_TOUCH   "Desktop Entry/X-Ubuntu-Touch"
#define DESKTOP_FILE_KEY_ONLY_SHOW_IN   "Desktop Entry/OnlyShowIn"
#define DESKTOP_FILE_KEY_NOT_SHOW_IN    "Desktop Entry/NotShowIn"

static QString KeyWithLocale(const QString &key, const QString &locale) {
    return key + QString("[%1]").arg(locale);
}

ApplicationsModel::ApplicationsModel(QAbstractListModel *parent)
    : QAbstractListModel(parent)
{
    qRegisterMetaType<AppEntryList>("AppEntryList");
    refresh();
}

ApplicationsModel::~ApplicationsModel()
{ }

QHash<int, QByteArray> ApplicationsModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles.insert(NameRole, "name");
    roles.insert(IconRole, "icon");
    roles.insert(ExecRole, "exec");

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

void ApplicationsModel::refresh()
{
    qDebug() << Q_FUNC_INFO << "called";

    beginResetModel();
    m_entries.clear();
    endResetModel();

    QStringList desktopFiles;

    desktopFiles << searchDesktopFiles(DESKTOP_FILES_FOLDER_USER);
    desktopFiles << searchDesktopFiles(DESKTOP_FILES_FOLDER_SYSTEM);

    Q_FOREACH(const QString &path, desktopFiles) {
        AppEntry entry = processDesktopFile(path);

        if (entry.valid) {
            beginInsertRows(QModelIndex(), rowCount(), rowCount());
            m_entries.append(entry);
            endInsertRows();
        }
    }
}

QVariantMap ApplicationsModel::get(QString exec) const
{
    QVariantMap map;

    Q_FOREACH(const AppEntry &entry, m_entries) {
        if (entry.exec == exec) {
            map["name"] = entry.name;
            map["icon"] = entry.icon;
            map["exec"] = entry.exec;

            break;
        }
    }

    return map;
}

AppEntry ApplicationsModel::processDesktopFile(QString path)
{
    QSettings appInfo(path, QSettings::IniFormat);
    appInfo.setIniCodec("UTF-8");

    AppEntry appEntry; 

    if (isDesktopFileVisible(appInfo)) {
        appEntry.name = getNameFromDesktopFile(appInfo);
        appEntry.icon = getIconFromDesktopFile(appInfo);
        appEntry.exec = getExecFromDesktopFile(appInfo);
        appEntry.valid = true;
    }

    return appEntry;
}

QStringList ApplicationsModel::searchDesktopFiles(const QString &path)
{
    QDirIterator dir(path, QDir::Files | QDir::NoDotAndDotDot | QDir::Readable,
                     QDirIterator::Subdirectories);

    QStringList results;
    QRegExp rx;

    while (dir.hasNext()) {
        dir.next();

        rx = QRegExp(QString("*.desktop"), Qt::CaseInsensitive);
        rx.setPatternSyntax(QRegExp::Wildcard);

        if (rx.exactMatch(dir.fileName()))
            results.append(dir.fileInfo().absoluteFilePath());
    }

    return results;
}

bool ApplicationsModel::isDesktopFileVisible(const QSettings &ini)
{
    bool isUbuntuTouchApp = ini.value(DESKTOP_FILE_KEY_UBUNTU_TOUCH, bool(false)).toBool();
    bool shouldNotBeDisplay = ini.value(DESKTOP_FILE_KEY_NO_DISPLAY, bool(false)).toBool();
    bool shouldDisplayOnUnity = ini.value(DESKTOP_FILE_KEY_ONLY_SHOW_IN, QString("Unity")).toString() == QString("Unity");
    bool shouldNotDisplayOnUnity = ini.value(DESKTOP_FILE_KEY_ONLY_SHOW_IN).toString() == QString("Unity");

    if (shouldNotDisplayOnUnity || shouldNotBeDisplay)
        return false;

    return isUbuntuTouchApp || shouldDisplayOnUnity;
}

QString ApplicationsModel::getIconFromDesktopFile(const QSettings &ini) const
{
    QString iconName = ini.value(DESKTOP_FILE_KEY_ICON).toString();

    if (iconName.isEmpty())
        return QString();

    if (QFileInfo(iconName).isAbsolute())
        return iconName;

    else
        // Use Ubuntu UITK's UnityThemeIconProvider
        return QString("image://theme/%1").arg(iconName);
}

QString ApplicationsModel::getNameFromDesktopFile(const QSettings &ini) const
{
    // https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s04.html
    // http://comments.gmane.org/gmane.comp.window-managers.sawfish/6112

    QString locale = qgetenv("LANG");

    if (locale.isEmpty())
        locale = qgetenv("LANGUAGE");

    if (locale.isEmpty())
        locale = qgetenv("LC_MESSAGE");

    if (locale.isEmpty())
        locale = qgetenv("LC_ALL");

    QString name;

    name = ini.value(KeyWithLocale(DESKTOP_FILE_KEY_NAME, locale)).toString();

    if (name.isEmpty()) {
        int n = locale.indexOf("@");
        if (n > -1)
            locale.truncate(n);

        name = ini.value(KeyWithLocale(DESKTOP_FILE_KEY_NAME, locale)).toString();
    }

    if (name.isEmpty()) {
        int n = locale.indexOf(".");
        if (n > -1)
            locale.truncate(n);

        name = ini.value(KeyWithLocale(DESKTOP_FILE_KEY_NAME, locale)).toString();
    }

    if (name.isEmpty()) {
        int n = locale.indexOf("_");
        if (n > -1)
            locale.truncate(n);

        name = ini.value(KeyWithLocale(DESKTOP_FILE_KEY_NAME, locale)).toString();
    }

    if (name.isEmpty())
        name = ini.value(DESKTOP_FILE_KEY_NAME).toString();

    return name;
}

QString ApplicationsModel::getExecFromDesktopFile(const QSettings &ini) const
{
    if (ini.contains(DESKTOP_FILE_KEY_APP_ID))
        return ini.value(DESKTOP_FILE_KEY_APP_ID).toString().split("_").at(0);

    else {
        QFileInfo fi(ini.fileName());
        return fi.completeBaseName();
    }
}
