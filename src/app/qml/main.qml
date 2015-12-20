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

// For making scripts executable
import StorageManager 1.0

import "components"
import "components/Models" as Models

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "ut-tweak-tool.sverzegnassi"

    function showNotification(args) {
        var component = Qt.createComponent("Toast.qml")
        var toast = component.createObject(mainView, args);

        return toast;
    }

    function showNotificationWithAction(args) {
        var component = Qt.createComponent("ToastWithAction.qml")
        var toast = component.createObject(mainView, args);

        return toast;
    }

    width: units.gu(100)
    height: units.gu(76)
    theme.name: "TweakTool.OrangeTheme"

    AdaptivePageLayout {
        id: pageStack
        anchors.fill: parent

        function push(page, properties) {
            // This function is called 'push' so we don't need to update
            // all the code.
            return pageStack.addPageToNextColumn(primaryPage, page, properties)
        }

        primaryPage: Page {
            id: mainPage

            property alias currentSectionIndex: view.currentIndex

            title: i18n.tr("UT Tweak Tool")

            head.sections.model: [ i18n.tr("Behavior"), i18n.tr("Apps & Scopes"), i18n.tr("System") ]

            ListView {
                id: view
                anchors.fill: parent

                clip: true

                orientation: ListView.Horizontal
                interactive: false
                snapMode: ListView.SnapOneItem

                highlightMoveDuration: UbuntuAnimation.FastDuration

                currentIndex: mainPage.head.sections.selectedIndex

                onCurrentIndexChanged: {
                    // Current section has changed, if there was an opened page
                    // in the second column, it is not anymore related to the
                    // new current section.
                    mainPage.pageStack.removePages(mainPage)
                }

                delegate: Loader {
                    width: view.width
                    height: view.height

                    source: modelData
                }

                model: [
                    Qt.resolvedUrl("behaviourTab/BehaviourTab.qml"),
                    Qt.resolvedUrl("applicationsTab/ApplicationsTab.qml"),
                    Qt.resolvedUrl("systemTab/SystemTab.qml")
                ]
            }
        }
    }

    Models.ClickModel { id: clickModel }

    AuthenticationService {
		id: pam
        serviceName: "ut-tweak-tool"
        onDenied: Qt.quit();
    }
}

