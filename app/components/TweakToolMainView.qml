/*
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

/*
  This is a convenient way to provide a MainView already configured to
  provide a PageStack, toast notifications, and a manifest.json parser
  (used by the AboutPage component which is included in this module.
*/

MainView {
    id: mainView

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

    property alias pageStack: pageStack
    PageStack { id: pageStack }

    property url copyrightUrl

    property alias manifest: manifest
    property alias manifestUrl: manifest.manifestUrl
    ManifestParser { id: manifest }
}

