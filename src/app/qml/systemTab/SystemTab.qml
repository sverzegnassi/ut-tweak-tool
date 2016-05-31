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

import QtQuick 2.4
import Ubuntu.Components 1.3
import TweakTool 1.0

import "../components/ListItems" as ListItems

ScrollView {
    id: rootItem
    anchors.fill: parent

    Column {
        width: rootItem.width

        ListItems.SectionDivider {
            iconName: "ubuntu-logo-symbolic"
            text: i18n.tr("System")
        }

        // FIXME
        ListItems.Page {
            text: i18n.tr("Make image writable")
            pageUrl: Qt.resolvedUrl("ImageWritable.qml")
            visible: DeviceCapabilities.isAndroidDevice
        }

        ListItems.Page {
            text: i18n.tr("System informations")
            pageUrl: Qt.resolvedUrl("SystemInfo.qml")
        }

        /*
          TODO: QML BatteryInfo is not yet integrated with the platform.
          See bug lp:1197542 - 2016/04/04

        ListItems.Page {
            text: i18n.tr("Battery informations")
            pageUrl: Qt.resolvedUrl("BatteryInfo.qml")
            visible: DeviceCapabilities.hasBattery
        }
        */

        ListItems.SectionDivider {
            iconName: "stock_usb"
            text: i18n.tr("USB settings")
            visible: DeviceCapabilities.isAndroidDevice
        }

        ListItems.Page {
            text: i18n.tr("ADB settings")
            pageUrl: Qt.resolvedUrl("UsbMode.qml")
            visible: DeviceCapabilities.isAndroidDevice
        }
    }
}
