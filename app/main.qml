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
import com.ubuntu.PamAuthentication 0.1

// For making scripts executable
import StorageManager 1.0

import "components"
import "components/Models" as Models

TweakToolMainView {
    id: mainView
    objectName: "mainView"

    // applicationName is set by CMake while building.
    applicationName: "@APP_ID@"
    manifestUrl: Qt.resolvedUrl("manifest.json")
    copyrightUrl: Qt.resolvedUrl("../../../copyright")

    width: units.gu(100)
    height: units.gu(76)

    Component.onCompleted: {
        // Use a custom header for this application
        mainView.header.style = Qt.createComponent(
                    Qt.resolvedUrl("theme/PageHeadStyle.qml"))

        // Push the main page on application start-up.
        pageStack.push(Qt.resolvedUrl("ui/MainPage.qml"))
    }

    Models.ClickModel { id: clickModel }

    AuthenticationService {
		id: pam
        serviceName: "ut-tweak-tool"
        onDenied: Qt.quit();
    }
}

