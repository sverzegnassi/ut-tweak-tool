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

#include "cmdlauncher.h"
#include <QTextStream>
#include <QDebug>

CmdLauncher::CmdLauncher(QObject *parent):
    QObject(parent),
    m_process(""),
    m_running(false),
    m_output(""),
    m_error("")
{
    // This space is intentionally empty.
}

void CmdLauncher::launch() {
    reset();

    ProcessThread *p = new ProcessThread();
    p->setProcess(m_process);

    connect(p, SIGNAL(outputChanged(QString, QString)), this, SLOT(setOutput(QString, QString)));
    connect(p, SIGNAL(errorChanged(QString)), this, SLOT(setError(QString)));
    connect(p, SIGNAL(runningStateChanged(bool)), this, SLOT(setRunningState(bool)));
    connect(p, SIGNAL(finished()), p, SLOT(deleteLater()));
    connect(p, SIGNAL(finished()), this, SIGNAL(finished()));

    p->start();
}

void CmdLauncher::launch(QString command) {
    setProcess(command);
    launch();
}

void CmdLauncher::setOutput(QString newLine, QString output)
{
    if (output != m_output) {
        m_output = output;
        Q_EMIT outputChanged(newLine);
    }
}

void CmdLauncher::setProcess(QString process)
{
    if (m_process != process) {
        m_process = process;
        Q_EMIT processChanged();

        reset();
    }
}

void CmdLauncher::reset()
{
    setRunningState(false);

    m_output = QString("");
    Q_EMIT outputChanged(QString(""));

    m_error = QString("");
    Q_EMIT errorChanged();
}

void CmdLauncher::setRunningState(bool state)
{
    if (state != m_running) {
        m_running = state;
        Q_EMIT runningChanged();
    }
}

void CmdLauncher::setError(QString error)
{
    if (error != m_error) {
        m_error = error;
        Q_EMIT errorChanged();
    }
}

void ProcessThread::run()
{
    Q_EMIT runningStateChanged(true);
    this->connect(&p, SIGNAL(readyReadStandardOutput()), this, SLOT(appendOutput()));
    p.start(m_process, QIODevice::ReadOnly);

    // Wait until the process has finished, and disable timeout.
    p.waitForFinished(-1);

    Q_EMIT errorChanged(p.readAllStandardError());
    Q_EMIT runningStateChanged(false);
}

void ProcessThread::appendOutput()
{
    QString newLine = p.readAllStandardOutput();
    m_output.append(newLine + "\n");
    Q_EMIT outputChanged(newLine, m_output);
}
