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
import QtQuick.Layouts 1.1

import "../components"
import "../components/ListItems" as ListItems

Page {
    id: rootItem

    header: PageHeader {
        title: i18n.tr("Make image writable")
        flickable: view.flickableItem
    }

    ScrollView {
        id: view
        anchors.fill: parent

        Column {
            width: view.width

            ListItems.Warning {
                iconName: "security-alert"
                text: i18n.tr("Be very careful when editing the filesystem image. There is a high risk of breaking OTA updates.")
            }

            ListItems.SectionDivider { text: i18n.tr("Available settings") }

            ListItems.Control {
                title.text: i18n.tr("Write permissions")

                Switch {
                    id: switcher
                    checked: writable_image.exists
                    onClicked: {
                        if (writable_image.exists)
                            writable_image.rm()
                        else
                            writable_image.touch()
                    }
                }
            }
        }
    }

    SystemFile {
        id: writable_image
        filename: "/userdata/.writable_image"
        onPasswordRequested: providePassword(pam.password)
        onExistsChanged: PopupUtils.open(rebootDialog)
    }

    Component {
        id: rebootDialog

        Dialog {
            id: rebootDialogue

            title: i18n.tr("Reboot device")
            text:  i18n.tr("This change require a reboot to take effect. Do you want to reboot the device now?")

            RowLayout {
                width: parent.width
                spacing: units.gu(1)

                Button {
                    Layout.fillWidth: true
                    text: i18n.tr("Cancel")
                    onClicked: {
                        PopupUtils.close(rebootDialogue);
                        switcher.checked = writable_image.exists
                    }
                }

                Button {
                    Layout.fillWidth: true
                    text: i18n.tr("OK")
                    color: UbuntuColors.green
                    onClicked: {
                        Process.launch("dbus-send --system --print-reply --dest=org.freedesktop.login1 \
                                        /org/freedesktop/login1 org.freedesktop.login1.Manager.Reboot \
                                        boolean:true")
                    }
                }
            }
        }
    }
}
