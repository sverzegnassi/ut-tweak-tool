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

Item {
    anchors.fill: parent

    property string version: "0.1"

    Column {
        anchors {
            top: parent.top
            topMargin: units.gu(6)
            horizontalCenter: parent.horizontalCenter
        }

        width: mainView.width > units.gu(50) ? units.gu(50) : parent.width
        spacing: units.gu(4)

        UbuntuShape {
            id: logo

            width: mainView.width > units.gu(50) ? units.gu(25) : parent.width / 2
            height: width
            radius: "medium"

            image: Image {
                source: Qt.resolvedUrl(manifest.get("x-icon-url"))
            }

            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            width: parent.width

            Label {
                fontSize: "x-large"
                font.weight: Font.DemiBold
                text: manifest.get("title")

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                // TRANSLATORS: Version of the software (e.g. "Version 0.3.51")
                text: i18n.tr("Version %1").arg(manifest.get("version"))
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Column {
            width: parent.width

            Label {
                // TRANSLATORS: This string will look like "(C) 2015 Tizio Caio"
                // %1 is the years, %2 is the name of the maintainer
                text: i18n.tr("(C) %1 %2").arg(manifest.get("x-copyright-year"))
                                          .arg(manifest.get("maintainer"))

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Label {
                fontSize: "small"
                text: i18n.tr("Released under the terms of the %1")
                          .arg(manifest.get("x-license"))

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
        }

        Column {
            width: parent.width
            spacing: units.gu(2)

            Label {
                // TRANSLATORS: <a href=\"%1\">%2</a> is the HTML tag for hyperlinks
                // %1 is the URL, %2 is the text shown for the URL.
                // e.g. <a href=\"http://www.ubuntu.com\">Ubuntu</a>
                text: i18n.tr("Source code available on <a href=\"%1\">%2</a>")
                          .arg(manifest.get("x-source-code-url"))
                          .arg(manifest.get("x-source-code-service"))

                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                fontSize: "small"

                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }
}
