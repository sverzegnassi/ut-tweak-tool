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
import QtQuick.Layouts 1.1
import TweakTool 1.0
import Ubuntu.Components.Popups 1.0

import "../../../components"
import "../../../components/ListItems" as ListItem

TweakToolPage {
    id: rootItem

    property string cmdTemplate: "/bin/bash %1 %2"
    property string adbOnLockGetPath: Qt.resolvedUrl("../../../scripts/adb_on_lock_get").replace("file://", "")
    property string adbOnLockSetPath: Qt.resolvedUrl("../../../scripts/adb_on_lock_set").replace("file://", "")
    property string adbOnLockUnSetPath: Qt.resolvedUrl("../../../scripts/adb_on_lock_unset").replace("file://", "")

    function getSelectedIndex() {
        if (Process.launch("android-gadget-service status mtp") === "Enabled")
            return 0

        if (Process.launch("android-gadget-service status rndis") === "Enabled")
            return 1

        return -1
    }

    function setFromSelectedIndex(selectedIndex) {
        if (selectedIndex == 0)
            Process.launch("android-gadget-service enable mtp")

        if (selectedIndex == 1)
            Process.launch("android-gadget-service enable rndis")
    }

    function getAdbOnLockState() {
        var output = Process.launch(cmdTemplate.arg(adbOnLockGetPath).arg(pam.password))

        console.log(output)

        if ( output.indexOf("Not found") > -1 ) {
            adbSwitch.checked = false
        } else {
            adbSwitch.checked = true
        }
    }

    function toggleAdbOnLockState() {
        /*
          WORKAROUND: Why the hell adbSwitch.checked returns false when it's checked?!?!
          Use the Process.launch(adbOnLockGetPath) instead.
        */

        var state = Process.launch(cmdTemplate.arg(adbOnLockGetPath).arg(pam.password))

        if (state.indexOf("Not found") > -1) {
            PopupUtils.open(confirmAdbDialog);
        } else {
            console.log(Process.launch(cmdTemplate.arg(adbOnLockUnSetPath).arg(pam.password)))
        }

        getAdbOnLockState()
    }

    ListItem.Warning {
        iconName: "stock_usb"
        text: i18n.tr("Here you can switch your USB connection from MTP mode (data transfer) to the RNDIS mode, which allows you to share the internet connection of your PC when connected via USB.")
    }

    ListItem.SectionDivider { text: i18n.tr("USB mode") }

    ListItem.OptionSelector {
        id: selector
        model: [
            i18n.tr("MTP - Media Transfer Protocol"),
            i18n.tr("RNDIS - Remote Network Driver Interface Specification")
        ]

        Component.onCompleted: selectedIndex = getSelectedIndex()
        onSelectedIndexChanged: setFromSelectedIndex(selectedIndex)
    }

    ListItem.SectionDivider { text: i18n.tr("ADB settings") }

    ListItem.Base {
        RowLayout {
            anchors.fill: parent
            spacing: units.gu(2)

            Label {
                text: i18n.tr("Keep ADB active on screen locked")
                Layout.fillWidth: true
            }

            Switch {
                id: adbSwitch
                Component.onCompleted: getAdbOnLockState()
                onClicked: toggleAdbOnLockState()
            }
        }
    }

    Component {
        id: confirmAdbDialog

        Dialog {
            id: confirmAdbDialogue

            title: i18n.tr("Enable ADB on lock")
            text: i18n.tr("Before you confirm this operation, please mind that if you lose your device, anyone will be able to access to all the data on your phone, without the need to unlock it first.\nDo you want to continue?")

            Button {
                text: i18n.tr("Yes, I'm feeling brave!")

                /*
                  Use UbuntuColors.red for the affirmative action, since there
                  are strong security implications.
                */
                color: UbuntuColors.red
                onClicked: {
                    console.log(Process.launch(cmdTemplate.arg(adbOnLockSetPath).arg(pam.password)))
                    PopupUtils.close(rebootDialogue);
                }
            }

            Button {
                text: i18n.tr("No")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(confirmAdbDialogue);
                    getRwState();
                }
            }
        }
    }
}
