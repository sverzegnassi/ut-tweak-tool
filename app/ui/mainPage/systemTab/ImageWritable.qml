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

import QtQuick 2.0
import Ubuntu.Components 1.2
import Ubuntu.Components.Popups 1.0
import TweakTool 1.0
import QtQuick.Layouts 1.1

import "../../../components"
import "../../../components/ListItems" as ListItem
import "../../../components/Commands" as Commands

TweakToolPage {
    id: rootItem

    property string cmdTemplate: "/bin/bash %1 %2"
    property string writableImageGetPath: Qt.resolvedUrl("../../../scripts/writable_image_get").replace("file://", "")
    property string writableImageSetPath: Qt.resolvedUrl("../../../scripts/writable_image_set").replace("file://", "")
    property string writableImageUnSetPath: Qt.resolvedUrl("../../../scripts/writable_image_unset").replace("file://", "")

    function getRwState() {
        var output = Process.launch(cmdTemplate.arg(writableImageGetPath).arg(pam.password))

        console.log(output)

        if ( output.indexOf("Not found") > -1 ) {
            rwSwitch.checked = false
        } else {
            rwSwitch.checked = true
        }
    }

    function toggleRwState() {
        /*
          WORKAROUND: Why the hell rwSwitch.checked returns false when it's checked?!?!
          Use the Process.launch(writableImageGetPath) instead.
        */

        var state = Process.launch(cmdTemplate.arg(writableImageGetPath).arg(pam.password))

        if (state.indexOf("Not found") > -1) {
            setRwPerm.launch()
        } else {
            unSetRwPerm.launch()
        }
    }

    Commands.Reboot { id: reboot }

    CommandLine {
        id: setRwPerm
        process: cmdTemplate.arg(writableImageSetPath).arg(pam.password)
        onFinished: reboot.launch()
    }

    CommandLine {
        id: unSetRwPerm
        process: cmdTemplate.arg(writableImageUnSetPath).arg(pam.password)
        onFinished: reboot.launch()
    }

    ListItem.Warning {
        iconName: "security-alert"
        text: i18n.tr("This setting unlocks write permission in the whole system image. You will be able to use commands like 'apt-get' on your device.<br /><b>NB:</b> Your device won't be enable to receive OTA updates. Be carefull!")
    }

    ListItem.SectionDivider { text: i18n.tr("System image") }

    ListItem.Base {
        RowLayout {
            anchors.fill: parent
            spacing: units.gu(2)

            Label {
                text: i18n.tr("Write permissions")
                Layout.fillWidth: true
            }

            Switch {
                id: rwSwitch
                Component.onCompleted: getRwState()
                onClicked: PopupUtils.open(rebootDialog)
            }
        }
    }

    Component {
        id: rebootDialog

        Dialog {
            id: rebootDialogue

            title: !rwSwitch.checked ? i18n.tr("Disable RW permissions")
                                     : i18n.tr("Enable RW permissions")
            text: !rwSwitch.checked ? i18n.tr("In order to disable RW permissions, you need to reboot your device.")
                                    : i18n.tr("In order to enable RW permissions, you need to reboot your device.")

            Button {
                text: i18n.tr("Reboot")
                color: UbuntuColors.orange
                onClicked: {
                    toggleRwState();
                    PopupUtils.close(rebootDialogue);
                }
            }

            Button {
                text: i18n.tr("Not now!")
                onClicked: {
                    PopupUtils.close(rebootDialogue);
                    getRwState();
                }
            }
        }
    }
}
