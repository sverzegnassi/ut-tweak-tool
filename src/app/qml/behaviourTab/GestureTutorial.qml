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
import Ubuntu.Components.Popups 1.3
import TweakTool 1.0

import "../components/ListItems" as ListItems

ListItems.Control {
    id: rootItem

    title.text: i18n.tr("Gesture tutorial")

    Button {
        text: i18n.tr("Show")
        onClicked: PopupUtils.open(rebootDialog)
        color: UbuntuColors.orange
    }

    CommandLine {
        id: enableTutorial
        process: "dbus-send --system --print-reply --dest=com.canonical.PropertyService \
                    /com/canonical/PropertyService com.canonical.PropertyService.SetProperty \
                    string:edge boolean:true"

        onFinished: {
            // Tutorial has been enabled. Reboot the device.
            reboot.launch()
        }
    }

    CommandLine {
        id: reboot
        process: "dbus-send --system --print-reply --dest=org.freedesktop.login1 \
                  /org/freedesktop/login1 org.freedesktop.login1.Manager.Reboot \
                  boolean:true"
    }

    Component {
        id: rebootDialog

        Dialog {
            id: rebootDialogue

            title: i18n.tr("Enable tutorial")
            text: i18n.tr("In order to show the tutorial, you need to reboot your device.")

            Button {
                text: i18n.tr("Enable tutorial and reboot")
                color: UbuntuColors.orange
                onClicked: {
                    enableTutorial.launch();
                    PopupUtils.close(rebootDialogue);
                }
            }

            Button {
                text: i18n.tr("Not now!")
                onClicked: PopupUtils.close(rebootDialogue)
            }
        }
    }
}
