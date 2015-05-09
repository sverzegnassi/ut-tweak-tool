/*
  Copyright (C) 2014, 2015 Stefano Verzegnassi

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

import QtQuick 2.3
import Ubuntu.Components 1.1

PageHeadState {
    id: rootItem

    property Page targetPage
    head: targetPage.head

    actions: [
        // TODO: This is an empty action used for design reason. Add an easter-egg here. :-)
        Action {
            iconSource: Qt.resolvedUrl("../../../../../graphics/empty.png")
        },

        Action {
            iconName: "search"
            text: i18n.tr("Search in this tab")
            enabled: false
        },

        Action {
            iconSource: Qt.resolvedUrl("../../../../../graphics/terminal.png")
            text: i18n.tr("Open a terminal session")
            onTriggered: Qt.openUrlExternally("appId://com.ubuntu.terminal/terminal/current-user-version")

            enabled: clickModel.checkAppExistsById("com.ubuntu.terminal")
        },

        Action {
            iconName: "ubuntu-store-symbolic"
            // TRANSLATORS: "Open Store" is the name of the unofficial free software store from Michael Zanetti.
            text: i18n.tr("Launch Open Store")
            onTriggered: Qt.openUrlExternally("appId://openstore.mzanetti/openstore/current-user-version")

            enabled: clickModel.checkAppExistsById("openstore.mzanetti")
        },

        Action {
            iconName: "info"
            text: i18n.tr("About")
            onTriggered: pageStack.push(Qt.resolvedUrl("../AboutPage.qml"))
        }
    ]
}
