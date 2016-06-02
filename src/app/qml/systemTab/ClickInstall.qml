/*
  This file is part of ut-tweak-tool
  Copyright (C) 2016 Stefano Verzegnassi <verzegnassi.stefano@gmail.com>

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
import "../components"

Page {
    id: clickPage

    property string selectedPackage

    header: PageHeader {
        title: i18n.tr("Install click package")
        flickable: scrollView.flickableItem
        enabled: !clickInstaller.running
    }

    ClickInstaller {
        id: clickInstaller
        onFinished: { if (!errorString) PopupUtils.open(successDialog) }
        onError: {
            console.log("ClickInstaller:", errorString)
            PopupUtils.open(errorDialog)
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        Column {
            width: scrollView.width
            ListItems.Control {
                title.text: i18n.tr("Selected package")
                subtitle.text: clickPage.selectedPackage || i18n.tr("<i>None</i>")
                subtitle.maximumLineCount: -1

                Button {
                    text: i18n.tr("Pick...")
                    onClicked: pageStack.addPageToCurrentColumn(clickPage, fileDialog)
                    enabled: !clickInstaller.running
                }
            }

            ListItem {
                Button {
                    anchors.centerIn: parent
                    width: units.gu(16)
                    color: UbuntuColors.orange
                    text: i18n.tr("Install")
                    visible: !clickInstaller.running
                    enabled: clickPage.selectedPackage
                    onClicked: clickInstaller.installAllowUntrusted(clickPage.selectedPackage)
                }

                ActivityIndicator {
                    anchors.centerIn: parent
                    visible: clickInstaller.running
                    running: visible
                }
            }

            ListItems.SectionDivider {
                text: i18n.tr("Output:")
            }

            ListItem {
                height: outputLabel.height + outputLabel.anchors.topMargin * 2
                divider.visible: false

                Label {
                    id: outputLabel
                    text: clickInstaller.output
                    font.family: "Ubuntu Mono"
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: units.gu(1)
                    }
                }
            }
        }
    }

    Component {
        id: fileDialog

        FilePickerPage {
            id: pickerPage
            headerTitle: i18n.tr("Choose a package")
            folder: "file://" + StorageManager.getXdgFolder(StorageManager.HomeLocation)
            nameFilters: ["*.click"]

            onAccepted: {
                clickPage.selectedPackage = path.toString().replace("file://", "")
                clickPage.pageStack.removePages(pickerPage)
            }
        }
    }

    Component {
        id: errorDialog

        Dialog {
            id: errorDialogue
            title: i18n.tr("Error")
            text: clickInstaller.errorString
            Button {
                anchors { left: parent.left; right: parent.right }
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(errorDialogue)
            }
        }
    }

    Component {
        id: successDialog

        Dialog {
            id: successDialogue
            title: i18n.tr("Install click package")
            text: i18n.tr("The package has been successfully installed.")
            Button {
                anchors { left: parent.left; right: parent.right }
                text: i18n.tr("Close")
                onClicked: PopupUtils.close(successDialogue)
            }
        }
    }
}
