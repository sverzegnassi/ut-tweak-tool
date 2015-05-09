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

import QtQuick 2.0
import Ubuntu.Components 1.2

Page {
    id: aboutPage

    title: i18n.tr("About")
    head.sections.model: [
        i18n.tr("General"),
    //    i18n.tr("Credits"),
        i18n.tr("Copyright")
    ]

    onActiveChanged: view.anchors.fill = view.parent

    ListView {
        id: view

        orientation: ListView.Horizontal
        interactive: false
        snapMode: ListView.SnapOneItem

        highlightMoveDuration: 200

        currentIndex: head.sections.selectedIndex

        delegate: Loader {
            width: view.width
            height: view.height

            source: modelData
        }

        model: [
            Qt.resolvedUrl("aboutPage/AboutGeneralSection.qml"),
           // Qt.resolvedUrl("aboutPage/AboutCreditsSection.qml"),
            Qt.resolvedUrl("aboutPage/AboutCopyrightSection.qml")
        ]
    }
}


