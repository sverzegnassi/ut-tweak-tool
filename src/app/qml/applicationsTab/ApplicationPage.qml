import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.1
import Ubuntu.Components.Popups 1.3
import QtQml.Models 2.1

Page {
    id: applicationPage

    property var pkg
    signal uninstallRequested()

    header: PageHeader {
        title: i18n.tr("Application Details")

        extension: Sections {
            id: pageSections
            model: [ i18n.tr("Overview"), i18n.tr("Hooks") ]
        }

        trailingActionBar.actions: Action {
            text: i18n.tr("Uninstall")
            iconName: "delete"
            enabled: pkg.isRemovable
            visible: enabled

            onTriggered: {
                var popup = PopupUtils.open(uninstallDialog, applicationPage, { appTitle: pkg.title })

                popup.accepted.connect(function() {
                    applicationPage.pageStack.removePages(applicationPage)
                    applicationPage.uninstallRequested()
                })
            }
        }
    }

    Component.onCompleted: pkg.updateSize()

    ListView {
        id: view
        anchors {
            top: applicationPage.header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        clip: true

        orientation: ListView.Horizontal
        interactive: false
        snapMode: ListView.SnapOneItem

        highlightMoveDuration: UbuntuAnimation.FastDuration

        currentIndex: pageSections.selectedIndex

        model: ObjectModel {
            ScrollView {
                width: view.width
                height: view.height

                ApplicationPageOverviewTab {
                    pkg: applicationPage.pkg
                }
            }

            ScrollView {
                width: view.width
                height: view.height

                ApplicationPageHooksTab {
                    pkg: applicationPage.pkg
                }
            }
        }
    }

    Component {
        id: uninstallDialog
        Dialog {
            id: uninstallDialogue
            signal accepted()

            property string appTitle
            title: i18n.tr("Uninstall %1").arg(appTitle)
            text: i18n.tr("Are you sure to continue?")

            RowLayout {
                width: parent.width
                spacing: units.gu(1)

                Button {
                    text: i18n.tr("Cancel")
                    Layout.fillWidth: true
                    onClicked: PopupUtils.close(uninstallDialogue)
                }

                Button {
                    text: i18n.tr("Uninstall")
                    color: UbuntuColors.green
                    Layout.fillWidth: true
                    onClicked:  {
                        uninstallDialogue.accepted();
                        PopupUtils.close(uninstallDialogue)
                    }
                }
            }
        }
    }
}
