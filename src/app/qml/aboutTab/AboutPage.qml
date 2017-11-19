
import QtQuick 2.4
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import "../components"

Page {
    id: aboutPage

    header: PageHeader {
        id: header
        title: i18n.tr("About")
        opacity: 1

        //leadingActionBar.delegate: HeaderButton {}
        //trailingActionBar.delegate: HeaderButton {}

        //leadingActionBar.actions: Action {
        //    iconName: "back"
         //   onTriggered: {
         //       pageLayout.removePage(aboutPage)
         //   }
        //}

        extension: Sections {
            id: sections
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }

            actions: [
                Action {
                    text: i18n.tr("About")
                },
                Action {
                    text: i18n.tr("Credits")
                }
            ]
            onSelectedIndexChanged: {
                tabView.currentIndex = selectedIndex
            }

        }
    }

    ListModel {
        id: creditsModel
        Component.onCompleted: initialize()

        function initialize() {
            // Resources
            creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Bugs"), link: "https://bugs.launchpad.net/ubuntu-touch-tweak-tool" })
            creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Contact"), link: "mailto:stefano92.100@gmail.com " })
            creditsModel.append({ category: i18n.tr("Resources"), name: i18n.tr("Translations"), link: "https://translations.launchpad.net/ubuntu-touch-tweak-tool"})

            // Developers
            creditsModel.append({ category: i18n.tr("Developers"), name: "Verzegnassi Stefano (" + i18n.tr("Founder") + ")", link: "https://launchpad.net/~verzegnassi-stefano" })
        }

    }

    VisualItemModel {
        id: tabs

        Item {
            id: aboutItem
            width: tabView.width
            height: tabView.height
            opacity: tabView.currentIndex == 0 ? 1 : 0

            Behavior on opacity {
                NumberAnimation {duration: 200; easing.type: Easing.InOutCubic }
            }

            Flickable {
                id: flickable
                anchors.fill: parent
                contentHeight: layout.height

                Column {
                    id: layout

                    spacing: units.gu(3)
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        topMargin: units.gu(5)
                    }

                    UbuntuShape {
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: width
                        width: Math.min(parent.width/2, parent.height/2)
                        source: Image {
                            source: Qt.resolvedUrl("../../ut-tweak-tool.png")
                        }
                        radius: "large"
                    }

                    Column {
                        width: parent.width
                        Label {
                            width: parent.width
                            textSize: Label.XLarge
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            text: i18n.tr("Ubuntu Touch Tweak Tool")
                        }
                        Label {
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            // TRANSLATORS: Tuner version number e.g Version 1.0.0
                            text: i18n.tr("Version %1").arg("0.4.0")
                        }
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        text: i18n.tr("A Tweak tool application for Ubuntu Touch.<br/>Tweak your device, unlock its full power! Advanced settings for your ubuntu device.")
                    }

                    Column {
                        anchors {
                            left: parent.left
                            right: parent.right
                            margins: units.gu(2)
                        }
                        Label {
                            width: parent.width
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            text: "(C) 2014-2016 Stefano Verzegnassi"
                        }
                        Label {
                            textSize: Label.Small
                            width: parent.width
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            text: i18n.tr("Released under the terms of the GNU GPL v3")
                        }
                    }

                    Label {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        textSize: Label.Small
                        horizontalAlignment: Text.AlignHCenter
                        linkColor: UbuntuColors.blue
                        text: i18n.tr("Source code available on %1").arg("<a href=\"https://launchpad.net/ubuntu-touch-tweak-tool\">Launchpad</a>")
                        onLinkActivated: Qt.openUrlExternally(link)
                    }

                }
            }
        }

        Item {
            id: creditsItem
            width: tabView.width
            height: tabView.height
            opacity: tabView.currentIndex == 1 ? 1 : 0

            Behavior on opacity {
                NumberAnimation {duration: 200; easing.type: Easing.InOutCubic }
            }

            ListView {
                id: creditsListView

                model: creditsModel
                anchors.fill: parent
                section.property: "category"
                section.criteria: ViewSection.FullString
                section.delegate: ListItemHeader {
                    title: section
                }

                delegate: ListItem {
                    height: creditsDelegateLayout.height
                    divider.visible: false
                    ListItemLayout {
                        id: creditsDelegateLayout
                        title.text: model.name
                        ProgressionSlot {}
                    }
                    onClicked: Qt.openUrlExternally(model.link)
                }
            }

        }
    }


    ListView {
        id: tabView
        anchors {
            top: aboutPage.header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        model: tabs
        currentIndex: 0

        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: UbuntuAnimation.FastDuration

        onCurrentIndexChanged: {
            sections.selectedIndex = currentIndex
        }

    }
}
