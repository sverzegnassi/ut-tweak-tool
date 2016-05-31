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
import com.ubuntu.PamAuthentication 0.1
import QtQml.Models 2.1

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "ut-tweak-tool.sverzegnassi"

    width: units.gu(100)
    height: units.gu(76)

    Component.onCompleted: {
        window.minimumWidth = units.gu(100)
        window.minimumHeight = units.gu(60)
    }

    AdaptivePageLayout {
        id: pageStack
        anchors.fill: parent

        function push(page, properties) {
            return pageStack.addPageToNextColumn(primaryPage, page, properties)
        }

        primaryPage: Page {
            id: mainPage
            clip: pageStack.columns > 1

            // TODO: Revert to PageHeader.sections as soon as Ubuntu UITK component allows to scroll its labels.
            header: PageHeader {
                id: mainPageHeader
                property int selectedTabIndex: 0

                onSelectedTabIndexChanged: {
                    // Current section has changed, if there was an opened page
                    // in the second column, it is not anymore related to the
                    // new current section.
                    mainPage.pageStack.removePages(mainPage)
                }

                leadingActionBar.actions: [
                    Action {
                        text: i18n.tr("Behavior")
                        onTriggered: mainPage.header.selectedTabIndex = 0
                        iconName: mainPage.header.selectedTabIndex == 0 ? "tick" : ""
                    },

                    Action {
                        text: i18n.tr("Apps & Scopes")
                        onTriggered: mainPage.header.selectedTabIndex = 1
                        iconName: mainPage.header.selectedTabIndex == 1 ? "tick" : ""
                    },

                    Action {
                        text: i18n.tr("System")
                        onTriggered: mainPage.header.selectedTabIndex = 2
                        iconName: mainPage.header.selectedTabIndex == 2 ? "tick" : ""
                    }
                ]

                contents: ListItemLayout {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: units.gu(0.25)
                    title.text: "UT Tweak Tool"
                    subtitle.text: mainPageHeader.leadingActionBar.actions[mainPageHeader.selectedTabIndex].text
                }

                title: "UT Tweak Tool"
            }

            ListView {
                id: view
                anchors {
                    top: mainPage.header.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                clip: true
                orientation: ListView.Horizontal
                interactive: false
                snapMode: ListView.SnapOneItem
                highlightMoveDuration: 0
                currentIndex: mainPage.header.selectedTabIndex

                model: ObjectModel {
                    Loader {
                        width: view.width
                        height: view.height
                        asynchronous: true
                        source: Qt.resolvedUrl("behaviourTab/BehaviourTab.qml")
                    }
                    Loader {
                        width: view.width
                        height: view.height
                        asynchronous: true
                        source: Qt.resolvedUrl("applicationsTab/ApplicationsTab.qml")
                    }
                    Loader {
                        width: view.width
                        height: view.height
                        asynchronous: true
                        source: Qt.resolvedUrl("systemTab/SystemTab.qml")
                    }
                }
            }
        }
    }

    property alias pam: pamLoader.item
    Loader {
        id: pamLoader
        // A bit nonsense, but we're not using pam for security
        asynchronous: true
        sourceComponent: AuthenticationService {
            id: pam
            serviceName: "ut-tweak-tool"
            onDenied: Qt.quit();
        }
    }
}

