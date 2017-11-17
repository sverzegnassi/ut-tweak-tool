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
import QtQuick.Layouts 1.1
import TweakTool 1.0

import "../components"
import "../components/ListItems" as ListItems

Page {
    id: rootItem

    header: PageHeader {
        title: i18n.tr("ADB settings")
        flickable: view.flickableItem
    }

    ScrollView {
        id: view
        anchors.fill: parent

        Column {
            width: view.width

            ListItems.SectionDivider {
                iconName: "stock_usb"
                text: i18n.tr("USB mode")
            }

            ListItems.OptionSelector {
                id: selector
                model: [
                    i18n.tr("MTP - Media Transfer Protocol"),
                    i18n.tr("RNDIS - Remote Network Driver Interface Specification")
                ]

                Component.onCompleted: {
                    if (Process.launch("android-gadget-service status mtp").indexOf("mtp enabled") > -1) {
                        selectedIndex = 0
                        return
                    }

                    if (Process.launch("android-gadget-service status rndis").indexOf("rndis enabled") > -1) {
                        selectedIndex = 1
                    }

                    selectedIndex = -1
                }
                onSelectedIndexChanged:  {
                    if (selectedIndex == 0)
                        Process.launch("android-gadget-service enable mtp")

                    if (selectedIndex == 1)
                        Process.launch("android-gadget-service enable rndis")
                }
            }

            ListItems.SectionDivider {
                iconName: "ubuntu-sdk-symbolic"
                text: i18n.tr("Debugging")
            }

            ListItem {
                ListItemLayout {
                    anchors.fill: parent
                    title.text: i18n.tr("Revoke USB debugging authorizations")
                }
                onClicked: PopupUtils.open(revokeAdbDialog)
            }
        }
    }

    SystemFile {
        id: adb_keys
        filename: "/data/misc/adb/adb_keys"
        onPasswordRequested: providePassword(pam.password)
    }

    Component {
        id: revokeAdbDialog

        Dialog {
            id: revokeAdbDialogue

            title: i18n.tr("Revoke USB debugging authorizations")
            text: i18n.tr("Revoke access to USB debugging from all computers you've previously authorized?")

            RowLayout {
                width: parent.width
                spacing: units.gu(1)

                Button {
                    Layout.fillWidth: true
                    text: i18n.tr("Cancel")
                    onClicked: PopupUtils.close(revokeAdbDialogue);
                }

                Button {
                    Layout.fillWidth: true
                    text: i18n.tr("OK")
                    color: UbuntuColors.green
                    onClicked: {
                        if (adb_keys.exists)
                            adb_keys.rm()

                        PopupUtils.close(revokeAdbDialogue);
                    }
                }
            }
        }
    }
}
