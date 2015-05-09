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

#ifndef CMDLAUNCHER_H
#define CMDLAUNCHER_H

#include <QObject>
#include <QThread>
#include <QProcess>

class CmdLauncher : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString process READ process WRITE setProcess NOTIFY processChanged)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(QString output READ output NOTIFY outputChanged)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)

public:
    explicit CmdLauncher(QObject *parent = 0);

    Q_INVOKABLE void launch();
    Q_INVOKABLE void launch(QString command);

    QString process() const { return m_process; }
    void setProcess(QString process);

    bool running() const { return m_running; }

    QString output() const { return m_output; }

    QString error() const { return m_error; }

Q_SIGNALS:
    void processChanged();
    void runningChanged();
    void outputChanged(QString newLine);
    void errorChanged();
    void finished();

public slots:
    void setOutput(QString newLine, QString output);
    void setRunningState(bool state);
    void setError(QString error);

private:
    void reset();

    QString m_process;
    bool m_running;
    QString m_output;
    QString m_error;
};

class ProcessThread : public QThread
{
    Q_OBJECT

public:
    void run();
    void setProcess(QString process) { m_process = process; }

Q_SIGNALS:
    void errorChanged(QString error);
    void outputChanged(QString newLine, QString output);
    void runningStateChanged(bool runningState);

private Q_SLOTS:
    void appendOutput();

private:
    QString m_process;
    QString m_output;
    QProcess p;
};

#endif // CMDLAUNCHER_H
