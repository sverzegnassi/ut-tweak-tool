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
import QtQuick.Layouts 1.1

Base {
    id: rootItem

    property alias text: label.text
    property alias iconName: icon.name
    property alias iconSource: icon.source
    property alias imageUrl: image.source
    height: Math.max(units.gu(12), label.paintedHeight + units.gu(2))

    RowLayout {
        anchors.fill: parent
        spacing: units.gu(2)

        UbuntuShape {
            id: shape

            height: units.gu(10); width: height
            source: Image { id: image }
            visible: image.source != ""
        }

        Icon {
            id: icon
            height: units.gu(10); width: height
            //name: "security-alert"
            name: "dialog-warning-symbolic" // Need a warning icon with the style of security-alert
            color: UbuntuColors.orange

            visible: image.source == ""
        }

        Label {
            id: label
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            textFormat: Text.RichText
            verticalAlignment: Text.AlignVCenter

            linkColor: UbuntuColors.orange
            onLinkActivated: Qt.openUrlExternally(link)

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
