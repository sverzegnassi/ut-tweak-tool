/*
 * Copyright (C) 2013 Canonical, Ltd.
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
 * Author: Michael Terry <michael.terry@canonical.com>
 */

#include <QtDebug>
#include <QGuiApplication>

/*
 * FIXME should really include powerd.h, but not available right now */
//#include <powerd.h>
enum SysPowerStates {
    //Note that callers will be notified of suspend state changes
    //but may not request this state.
    POWERD_SYS_STATE_SUSPEND = 0,

    //The Active state will prevent system suspend
    POWERD_SYS_STATE_ACTIVE,
    POWERD_DISPLAY_STATE_ON = POWERD_SYS_STATE_ACTIVE,

    POWERD_NUM_POWER_STATES
};

#include "QtPowerd.h"

QtPowerd::QtPowerd(QObject* parent)
  : QObject(parent),
    m_keepAlive(false),
    m_keepDisplayOn(false),
    m_qtpowerd(NULL)
{
    m_qtpowerd = new QDBusInterface("com.canonical.powerd",
                                    "/com/canonical/powerd",
                                    "com.canonical.powerd",
                                    QDBusConnection::systemBus(), this);

    m_lockName = QString::number(QGuiApplication::instance()->applicationPid());
    m_lockName.append("-background");
}

bool QtPowerd::keepAlive() const
{
    return m_keepAlive;
}

void QtPowerd::setKeepAlive(const bool keep)
{
    if (m_keepAlive == keep) {
        // nothing to do
        return;
    }

    if (keep) {
        QDBusReply<QString> reply = m_qtpowerd->call("requestSysState",
                                                     m_lockName,
                                                     POWERD_SYS_STATE_ACTIVE);
        if (!reply.isValid()) {
            qCritical() << "requestSysState:" << reply.error();
            return;
        }
        m_sysCookie = reply.value();
    } else {
        QDBusReply<void> reply = m_qtpowerd->call("clearSysState", m_sysCookie);
        if (!reply.isValid()) {
            qCritical() << "clearSysState:" << reply.error();
            return;
        }
    }

    m_keepAlive = keep;
    Q_EMIT keepAliveChanged();
}

bool QtPowerd::keepDisplayOn() const
{
    return m_keepDisplayOn;
}

void QtPowerd::setDisplayOn(const bool keep)
{
    if (m_keepDisplayOn == keep) {
        // nothing to do
        return;
    }

    if (keep) {
        QDBusReply<QString> reply = m_qtpowerd->call("requestDisplayState",
                                 m_lockName,
                                 POWERD_DISPLAY_STATE_ON,
                                 QVariant((uint) 0));
        if (!reply.isValid()) {
            qCritical() << "requestDisplayState:" << reply.error();
            return;
        }
        m_dispCookie = reply.value();
    } else {
        QDBusReply<void> reply = m_qtpowerd->call("clearDisplayState", m_dispCookie);
        if (!reply.isValid()) {
            qCritical() << "clearDisplayState:" << reply.error();
            return;
        }
    }

    m_keepDisplayOn = keep;
    Q_EMIT keepDisplayOnChanged();
}
