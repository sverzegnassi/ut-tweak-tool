/*
  This file is part of ut-tweak-tool
  Copyright (C) 2015 Mutse Young
  Copyright (C) 2015 Stefano Verzegnassi <verzegnassi.stefano@gmail.com>

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

import QtQuick 2.4
import TweakTool 1.0

import "../components/ListItems" as ListItems

Column {
    anchors {
        fill: parent
        topMargin: 0
        margins: units.gu(2)
    }

    readonly property string catCmd:      "cat /etc/machine-info"
    readonly property string kerCmd:      "uname -pro"
    readonly property string osCmd:       "cat /etc/os-release | grep \"VERSION=\""
    readonly property string platformCmd: "uname -p"
    readonly property string cpuCmd:      "cat /proc/cpuinfo | grep Processor"
    readonly property string memCmd:      "cat /proc/meminfo | grep MemTotal"

    function parse_lines(response, splitstr) {
        var line;
        var lines = response.split('\n');
        for(var i in lines) {
            line = lines[i];
            if (line.indexOf(splitstr ) != -1) {
                if (splitstr.length != 0) {
                    line = line.replace(splitstr,  "");
                    line = line.replace(/"([^"]*)"/g, "$1");
                }
                return line;
            }
        }
    }

    function parse_cmd(cmd, s) {
        var s1  = Process.launch(cmd);
        return parse_lines(s1, s) || "<i>Unknown</i>";
    }

    function str_trim(s) {
        return s.replace(/^\s+|\s+$/g,"");
    }

    function calc_meminfo(cmd) {
        var s = str_trim(parse_cmd(cmd, "MemTotal:").replace("kB", ""))
        var total = parseInt(s)/1024;
        return Math.floor(total.toString())
    }


    // OS Informations
    ListItems.SectionDivider {
        iconName: "ubuntu-logo-symbolic"
        text: i18n.tr("Ubuntu Touch Information")
    }

    ListItems.SingleValue {
        title.text: i18n.tr("Kernel:")
        value:parse_cmd(kerCmd, "")
    }

    ListItems.SingleValue {
        title.text: i18n.tr("System Platform:")
        value: parse_cmd(platformCmd, "")
    }

    ListItems.SingleValue {
        title.text: i18n.tr("Distro:")
        value: parse_cmd(osCmd, "PRETTY_NAME=")
    }

    // FIXME: This should not be hard-coded.
    ListItems.SingleValue {
        title.text: i18n.tr("Desktop:")
        value: "Unity 8"
    }


    // System informations
    ListItems.SectionDivider {
        iconName: "system-settings-symbolic"
        text: i18n.tr("Hardware Information")
    }

    ListItems.SingleValue {
        title.text: i18n.tr("Device:")
        value: parse_cmd(catCmd, "PRETTY_HOSTNAME=").replace(/"([^"]*)"/g, "$1")
    }

    ListItems.SingleValue {
        title.text: i18n.tr("CPU:")
        value: str_trim(parse_cmd(cpuCmd, "Processor").replace(":", ""))
    }

    ListItems.SingleValue {
        title.text: i18n.tr("Memory:")
        value: calc_meminfo(memCmd) + (" MB")
    }
}
