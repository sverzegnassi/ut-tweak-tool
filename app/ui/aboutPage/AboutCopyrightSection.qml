/*
  This file is part of ut-tweak-tool
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

import QtQuick 2.0
import Ubuntu.Components 1.2

Flickable {
    anchors.fill: parent

    clip: true
    contentHeight: copyrightText.height

    // Indipendent GU flickable speed workaround
    flickDeceleration: 1500 * units.gridUnit / 8
    maximumFlickVelocity: 2500 * units.gridUnit / 8

    Label {
        id: copyrightText
        wrapMode: Text.WordWrap
        width: parent.width
        fontSize: "x-small"

        Component.onCompleted: {
            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.DONE) {
                    text = doc.responseText;
                }
            }
            doc.open("get", mainView.copyrightUrl);
            doc.setRequestHeader("Content-Encoding", "UTF-8");
            doc.send();
        }
    }
}
