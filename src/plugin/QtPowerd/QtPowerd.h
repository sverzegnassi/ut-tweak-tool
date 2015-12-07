/*
 * Copyright (C) 2012,2013 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors: Gerry Boland <gerry.boland@canonical.com>
 *          Michael Terry <michael.terry@canonical.com>
 */

#ifndef QTPOWERD_H
#define QTPOWERD_H

#include <QtCore/QObject>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>

class QtPowerd: public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool keepAlive READ keepAlive WRITE setKeepAlive NOTIFY keepAliveChanged)
    Q_PROPERTY(bool keepDisplayOn READ keepDisplayOn WRITE setDisplayOn NOTIFY keepDisplayOnChanged)

public:
    explicit QtPowerd(QObject *parent = 0);

    bool keepAlive() const;
    void setKeepAlive(const bool keepAlive);

    bool keepDisplayOn() const;
    void setDisplayOn(const bool keepDisplayOn);

Q_SIGNALS:
    void keepAliveChanged();
    void keepDisplayOnChanged();

private:
    QString m_lockName;
    QString m_dispCookie;
    QString m_sysCookie;
    bool m_keepAlive;
    bool m_keepDisplayOn;
    QDBusInterface *m_qtpowerd;
};

#endif
