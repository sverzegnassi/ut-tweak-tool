/*
  This file is part of ut-tweak-tool
  Copyright (C) 2015 Mutse Young
  Copyright (C) 2015, 2016 Stefano Verzegnassi <verzegnassi.stefano@gmail.com>

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
import Ubuntu.Components 1.3
import TweakTool 1.0 as TweakTool

import "../components/ListItems" as ListItems

Page {

    function convertKbToMb(kb) {
        if (kb === -1)
            return i18n.tr("<i>Unknown</i>")

        var total = parseInt(kb)/1024;
        return Math.floor(total) + " MB"
    }

    TweakTool.SystemInfo {
        id: systemInfo
    }

    header: PageHeader {
        title: i18n.tr("System information")
        flickable: view.flickableItem
    }

    ScrollView {
        id: view
        anchors.fill: parent

        Column {
            width: view.width

            // OS Informations
            ListItems.SectionDivider {
                iconName: "ubuntu-logo-symbolic"
                text: i18n.tr("Ubuntu Touch information")
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Kernel:")
                value: systemInfo.kernelVersion
            }

            ListItems.SingleValue {
                title.text: i18n.tr("System platform:")
                value: systemInfo.buildCpuArchitecture
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Distro:")
                value: systemInfo.productName
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Desktop environment:")
                value: systemInfo.currentDesktop
            }

            // System informations
            ListItems.SectionDivider {
                iconName: "system-settings-symbolic"
                text: i18n.tr("Hardware information")
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Device name:")
                value: systemInfo.deviceName
            }

            ListItems.SingleValue {
                title.text: i18n.tr("CPU:")
                value: systemInfo.cpuName
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Memory:")
                value: convertKbToMb(systemInfo.memoryTotal)
            }
        }
    }
}
