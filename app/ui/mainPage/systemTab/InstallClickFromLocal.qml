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
import QtQuick.Layouts 1.1
import StorageManager 1.0
import TweakTool 1.0

import "../../../components/Functions.js" as Utils
import "../../../components/ListItems" as ListItem
import "../../../components/Dialogs"
import "../../../components/Upstream"

// TODO: Add --allow-untrusted flag option

Page {
    id: rootItem

    function generateScript() {
        var scriptContent;
        var cmdTemplate = "pkcon install-local --allow-untrusted '%1'"

        scriptContent += "#!/bin/bash" + "\n"

        var path;
        for (var i=0; i<pathModel.count; i++) {
            path = pathModel.get(i).path
            scriptContent += "\n" + "echo $'\n*** Installing %1: %2\n'".arg(i+1).arg(path) + "\n"
            scriptContent += cmdTemplate.arg(path) + "\n"
        }

        scriptContent += "\n" + "echo $'\nProcess completed'"

        var scriptFolder = StorageManager.getXdgFolder(StorageManager.CacheLocation) + "/clickscripts/"
        var scriptName = "%1.sh".arg(Utils.getCurrentDateTime())
        StorageManager.mkPath(scriptFolder)
        StorageManager.createTextFile(scriptFolder + scriptName, scriptContent)

        return scriptFolder + scriptName
    }

    ListModel { id: pathModel }

    ListView {
        id: view

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: installContainer.top
        }

        model: pathModel
        header: Column {
            width: parent.width

            ListItem.Warning {
                id: warning
                iconName: "stock_application"
                text: i18n.tr("Install a package from the storage.\nYou can target a single package or all the packages in a given directory and its subfolders.")
            }

            ListItem.Button {
                id: addButton
                title.text: i18n.tr("Add package")
                button {
                    text: i18n.tr("Pick")
                    onClicked: {
                        var picker = pageStack.push(fileDialog);
                        picker.accepted.connect(function(pathsList) {
                            for (var i=0; i<pathsList.length; i++) {
                                pathModel.append(
                                    {
                                        "path": pathsList[i].toString()
                                                            .replace("file://", "")
                                    }
                                )
                            }
                        })
                    }
                }
            }

            ListItem.SectionDivider {
                id: section
                text: i18n.tr("Packages from the following paths will be installed:")
                visible: pathModel.count > 0
            }

            Item {
                visible: view.count == 0
                width: parent.width
                height: view.height - (warning.height + section.height + addButton.height)

                EmptyState {
                    title: i18n.tr("No package added")
                    subTitle: i18n.tr("Tap the 'Add package' button to add a package in the list")
                    iconName: "package-x-generic-symbolic"

                    width: parent.width
                    anchors.centerIn: parent
                }
            }
        }

        delegate: ListItem.Base {
            height: Math.max(units.gu(7), pathLabel.paintedHeight + units.gu(2))

            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        text: i18n.tr("Delete")
                        onTriggered: pathModel.remove(index)
                    }
                ]
            }

            RowLayout {
                anchors.fill: parent
                spacing: units.gu(2)

                Label {
                    id: pathLabel
                    wrapMode: Text.WrapAnywhere
                    text: model.path

                    Layout.fillWidth: true
                }
            }
        }
    }

    Item {
        id: installContainer

        height: installBase.height
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        // Ugly trick to get the divider on the top of the item
        ListItem.Base {
            id: installBase
            rotation: 180

            Button {
                anchors.centerIn: parent
                rotation: -180

                color: UbuntuColors.orange
                text: i18n.tr("Install package...", "Install packages...", pathModel.count)
                enabled: pathModel.count > 0

                onTriggered: {
                    var dialog = PopupUtils.open(confirmInstallDialog);
                    dialog.accepted.connect(function() {
                        PopupUtils.open(runInstallDialog)
                    })
                }
            }
        }
    }

    Component {
        id: fileDialog

        FileChooserDialog {
            title: i18n.tr("Choose a package")
            folder: "file://" + StorageManager.getXdgFolder(StorageManager.HomeLocation)
            nameFilters: ["*.click"]
            multipleSelection: true
        }
    }

    Component {
        id: confirmInstallDialog

        Dialog {
            id: confirmInstallDialogue

            signal accepted

            title: i18n.tr("Install package", "Install packages", pathModel.count)
            text: i18n.tr("You are about to install %1 package. This operation will take some time to be completed and cannot be interrupted.\nAre you sure to continue?",
                          "You are about to install %1 packages. This operation will take some time to be completed and cannot be interrupted.\nAre you sure to continue?",
                          pathModel.count).arg(pathModel.count)

            Button {
                text: i18n.tr("Yes")
                color: UbuntuColors.orange
                onClicked: {
                    confirmInstallDialogue.accepted();
                    PopupUtils.close(confirmInstallDialogue);
                }
            }

            Button {
                text: i18n.tr("No")
                onClicked: PopupUtils.close(confirmInstallDialogue);
            }
        }
    }

    // TODO: Add a way to interrupt the install.
    Component {
        id: runInstallDialog

        Dialog {
            id: runInstallDialogue

            property int currentlyProcessedPackageIndex: 0

            function installPkgs() {
                clickProcess.scriptPath = rootItem.generateScript();
                clickProcess.launch();
            }

            title: i18n.tr("Installing package", "Installing packages", pathModel.count)
            text: i18n.tr("Package %1 of %2").arg(currentlyProcessedPackageIndex + 1)
                                             .arg(pathModel.count)

            Component.onCompleted: installPkgs()

            CommandLine {
                id: clickProcess

                property string scriptPath
                process: "/bin/bash %1".arg(scriptPath)

                onScriptPathChanged: console.log("New script at:", scriptPath)
                onOutputChanged: {
                    // Get the number of the currently processed package
                    var checker = new RegExp(/\*\*\* Installing (\d+)/)
                    var number = newLine.split(checker)[1]

                    if (number)
                        runInstallDialogue.currentlyProcessedPackageIndex = parseInt(number)

                    // Update the log
                    outputLabel.text += newLine + "\n"
                }

                onFinished: {
                    // Save log in the application data folder
                    var logFileName = "click-%1.txt".arg(Utils.getCurrentDateTime())
                    var logFolderPath = StorageManager.getXdgFolder(StorageManager.DataLocation) + "/logs"

                    if (StorageManager.mkPath(logFolderPath))
                        StorageManager.createTextFile(logFolderPath + "/" + logFileName, clickProcess.output)

                    StorageManager.rm(scriptPath)

                    runInstallDialogue.title = i18n.tr("Install completed")
                    runInstallDialogue.text = i18n.tr("You can find the log of the installation in %1.").arg(logFolderPath + "/" + logFileName)
                    pkgNameLabel.visible = false
                    progressBar.visible = false
                    closeButton.visible = true
                }
            }

            Label {
                id: pkgNameLabel
                text: StorageManager.getFileFullName(pathModel.get(currentlyProcessedPackageIndex).path)
                wrapMode: Text.Wrap
            }

            ProgressBar {
                id: progressBar
                minimumValue: 1
                maximumValue: pathModel.count
                value: currentlyProcessedPackageIndex + 1
            }

            AbstractButton {
                height: units.gu(4)

                onClicked: {
                    logFlickable.visible = !logFlickable.visible
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: units.gu(2)

                    Icon {
                        width: units.gu(2); height: width

                        name: "go-down"
                        rotation: logFlickable.visible ? 180 : 0

                        Behavior on rotation {
                            UbuntuNumberAnimation {}
                        }
                    }

                    Label {
                        text: logFlickable.visible ? i18n.tr("Hide log") : i18n.tr("Show log")
                        anchors.verticalCenter: parent.verticalCenter
                        Layout.fillWidth: true
                    }
                }
            }

            Flickable {
                id: logFlickable
                width: parent.width
                height: visible ? width : 0
                visible: false

                clip: true
                interactive: contentHeight > height

                contentHeight: outputScreen.height
                Rectangle {
                    id: outputScreen
                    color: "#2C2C2C"

                    width: parent.width
                    height: Math.max(outputLabel.paintedHeight, logFlickable.height)

                    Label {
                        id: outputLabel
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: rootItem.log
                    }
                }

                Behavior on height {
                    UbuntuNumberAnimation {}
                }
            }

            Button {
                id: closeButton
                visible: false
                enabled: visible

                color: UbuntuColors.orange
                text: i18n.tr("Close")
                onClicked: {
                    PopupUtils.close(runInstallDialogue);

                    // Clean the model on close
                    pathModel.clear();
                }
            }
        }
    }
}
