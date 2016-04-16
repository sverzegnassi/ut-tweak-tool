import QtQuick 2.4
import Ubuntu.Components 1.3
import TweakTool 1.0
import QtQuick.Layouts 1.1
import Ubuntu.Components.Popups 1.3

import "../components"
import "../components/ListItems" as ListItems

Flickable {
    id: overviewTab
    anchors.fill: parent
    interactive: true

    property var pkg

    contentWidth: parent.width
    contentHeight: column.height

    Column {
        id: column
        anchors {
            left: parent.left
            right: parent.right
            //margins: units.gu(2)
        }

        ListItem {
            height: units.gu(12)
            divider.visible: false

            ListItemLayout {
                anchors.fill: parent

                title {
                    text: "%1 %2".arg(pkg.title).arg(pkg.version)
                    textSize: Label.Large
                }

                subtitle {
                    text: pkg.maintainer
                    wrapMode: Text.WrapAnywhere
                }

                summary {
                    text: pkg.appId
                    font.italic: true
                }

                UbuntuShape {
                    SlotsLayout.position: SlotsLayout.Leading
                    height: units.gu(8); width: height
                    aspect: UbuntuShape.DropShadow

                    image: Image { source: pkg.iconPath }
                }
            }
        }

        ListItem {
            height: units.gu(4)

            Row {
                anchors { fill: parent; margins: units.gu(2); topMargin: 0 }
                layoutDirection: Qt.RightToLeft
                spacing: units.gu(1)

                Icon {
                    width: units.gu(3); height: width
                    color: UbuntuColors.blue
                    name: "notification"
                    visible: pkg.containsPushHelper
                }
                Icon {
                    width: units.gu(3); height: width
                    color: UbuntuColors.blue
                    name: "account"
                    visible: pkg.containsOnlineAccount
                }
                Icon {
                    width: units.gu(3); height: width
                    color: UbuntuColors.blue
                    name: "search"
                    visible: pkg.containsScope
                }
                Icon {
                    width: units.gu(3); height: width
                    color: UbuntuColors.blue
                    name: "stock_application"
                    visible: pkg.containsApp
                }
            }
        }

        ListItem {
            height: Math.max(units.gu(7), descLayout.height)
            ListItemLayout {
                id: descLayout

                title {
                    text: i18n.tr("Description")
                    color: UbuntuColors.blue
                }

                summary {
                    text: pkg.description
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    maximumLineCount: 20
                }
            }
        }

        ListItems.Control {
            title.text: i18n.tr("Prevent app suspension")
            visible: pkg.containsApp

            Switch {
                checked: pkg.lifeCycleException
                onClicked: pkg.lifeCycleException = !pkg.lifeCycleException
            }
        }

        ListItem {
            height: usageLayout.height + units.gu(4)
            Column {
                id: usageLayout
                spacing: units.gu(0.5)
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    margins: units.gu(2)
                }

                Label {
                    text: i18n.tr("Disk usage — %1").arg(printSize(i18n, pkg.installedSize + pkg.cacheSize + pkg.dataSize + pkg.configSize))
                    color: UbuntuColors.blue
                }

                RowLayout {
                    anchors { left: parent.left; right: parent.right }
                    Label { text: i18n.tr("Application size"); Layout.fillWidth: true }
                    Label { text: printSize(i18n, pkg.installedSize) }
                }

                RowLayout {
                    anchors { left: parent.left; right: parent.right }
                    Label { text: i18n.tr("Cache size"); Layout.fillWidth: true }
                    Label { text: printSize(i18n, pkg.cacheSize) }
                }

                RowLayout {
                    anchors { left: parent.left; right: parent.right }
                    Label { text: i18n.tr("Data size"); Layout.fillWidth: true }
                    Label { text: printSize(i18n, pkg.dataSize) }
                }

                RowLayout {
                    anchors { left: parent.left; right: parent.right }
                    Label { text: i18n.tr("Config size"); Layout.fillWidth: true }
                    Label { text: printSize(i18n, pkg.configSize) }
                }

                Button {
                    anchors.right: parent.right
                    width: units.gu(12)
                    text: i18n.tr("Clear...")
                    color: theme.palette.normal.negative

                    onClicked: {
                        var popup = PopupUtils.open(clearDialog, applicationPage)
                        popup.title = i18n.tr("Clear %1 data").arg(pkg.title)

                        popup.accepted.connect(function(clearCache, clearData, clearConfig) {
                            if (clearCache)
                                pkg.clearAppCache()

                            if (clearData)
                                pkg.clearAppData()

                            if (clearConfig)
                                pkg.clearAppConfig()
                        })
                    }
                }
            }
        }

        Component {
            id: clearDialog
            Dialog {
                id: clearDialogue
                signal accepted(var clearCache, var clearData, var clearConfig)

                RowLayout {
                    Label { text: i18n.tr("Cache:"); Layout.fillWidth: true }
                    CheckBox { id: cacheCheckBox }
                }

                RowLayout {
                    Label { text: i18n.tr("Application data:"); Layout.fillWidth: true }
                    CheckBox { id: dataCheckBox }
                }

                RowLayout {
                    Label { text: i18n.tr("Config:"); Layout.fillWidth: true }
                    CheckBox { id: configCheckBox }
                }

                RowLayout {
                    width: parent.width
                    spacing: units.gu(1)
                    Button {
                        text: i18n.tr("Cancel")
                        Layout.fillWidth: true
                        onClicked: PopupUtils.close(clearDialogue)
                    }
                    Button {
                        text: i18n.tr("Clear")
                        color: UbuntuColors.green
                        Layout.fillWidth: true
                        onClicked:  {
                            clearDialogue.accepted(cacheCheckBox.checked, dataCheckBox.checked, configCheckBox.checked);
                            PopupUtils.close(clearDialogue)
                        }
                    }
                }
            }
        }
    }

    function printSize(i18n, size) {
        var s

        s = 1024 * 1024 * 1024
        if (size >= s)
            // TRANSLATORS: %1 is the size of a file, expressed in GB
            return i18n.tr("%1 GB").arg((size / s).toFixed(2));

        s = 1024 * 1024
        if (size >= s)
            // TRANSLATORS: %1 is the size of a file, expressed in MB
            return i18n.tr("%1 MB").arg((size / s).toFixed(2));

        s = 1024
        if (size >= s)
            // TRANSLATORS: %1 is the size of a file, expressed in kB
            return i18n.tr("%1 kB").arg(parseInt(size / s));

        // TRANSLATORS: %1 is the size of a file, expressed in byte
        return i18n.tr("%1 byte").arg(size);
    }
}

