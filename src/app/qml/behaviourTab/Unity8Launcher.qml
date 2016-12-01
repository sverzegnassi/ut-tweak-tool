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
import GSettings 1.0

import "../components"
import "../components/ListItems" as ListItems

Page {
    id: rootItem

    header: PageHeader {
        title: i18n.tr("Launcher")
        flickable: view.flickableItem
    }

    ScrollView {
        id: view
        anchors.fill: parent

        Column {
            width: view.width

            ListItems.SectionDivider { text: i18n.tr("General") }

            ListItems.Control {
                title.text: i18n.tr("Enable the launcher")
                summary.text: i18n.tr("Enable or disable the launcher")
                summary.maximumLineCount: Number.MAX_VALUE

                control: Switch {
                    Component.onCompleted: checked = settings.enableLauncher
                    onClicked: {
                        settings.enableLauncher = !settings.enableLauncher
                    }
                }
            }

            ListItems.Control {
                title.text: i18n.tr("Autohide")
                summary.text: i18n.tr("This will only be applied in windowed mode. In staged mode, the launcher will always hide.")
                summary.maximumLineCount: Number.MAX_VALUE

                control: Switch {
                    Component.onCompleted: checked = settings.autohideLauncher
                    onClicked: {
                        settings.autohideLauncher = !settings.autohideLauncher
                    }
                }
            }

            ListItems.SectionDivider { text: i18n.tr("Launcher width") }

            ListItem {
                height: Math.max(implicitHeight, widthlayout.height)

                ListItemLayout {
                    id: widthlayout
                    anchors.centerIn: parent
                    title.text: i18n.tr("Current value: %1").arg(widthSlider.value.toFixed(0))
                    subtitle.text: i18n.tr("Width of the launcher in grid units.")
                    summary.text: i18n.tr("Changes the width of the launcher in all usage modes.")
                }
            }

            ListItem {
                height: units.gu(12)
                Button {
                    id: widthResetButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: units.gu(2)
                    color: UbuntuColors.orange

                    action: Action {
                        text: i18n.tr("Reset")
                        onTriggered: {
                            settings.schema.reset("launcherWidth")
                            widthSlider.value = settings.launcherWidth
                        }
                    }
                }

                Slider {
                    id: widthSlider
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: widthResetButton.right
                    anchors.right: parent.right
                    anchors.margins: units.gu(2)

                    minimumValue: 6
                    maximumValue: 12

                    Component.onCompleted: {
                        value = settings.launcherWidth
                    }
                    onValueChanged: {
                        settings.launcherWidth = value.toFixed(0)
                    }
                }
            }
        }
    }

    GSettings {
        id: settings
        schema.id: "com.canonical.Unity8"
    }
}
