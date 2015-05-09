/* Copyright (C) 2014-2015 Dan Chapman <dpniel@ubuntu.com>

   This file is part of Dekko email client for Ubuntu Devices/

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License or (at your option) version 3

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.3
import Ubuntu.Components 1.1

AbstractButton {
    id: sectionButton

    property int defaultWidth: sectionsRow.width / sectionsRepeater.count
    property int wideScreenWidth: sectionLabel.paintedWidth + units.gu(4)

    width: sectionsRow.width > units.gu(80) ? wideScreenWidth : defaultWidth
    height: divider.height

    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
    enabled: sectionsRow.enabled

    property bool selected: index === divider.sections.selectedIndex
    onClicked: divider.sections.selectedIndex = index;

    Label {
        id: sectionLabel

        text: modelData
        color: headerStyle.sectionColor
        opacity: sectionButton.selected ? 1.0 : 0.65
        font.weight: sectionButton.selected ? Font.DemiBold : Font.Normal

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
    }

    Rectangle {
        color: headerStyle.sectionColor
        opacity: sectionButton.selected ? 1.0 : 0.65

        height: units.gu(0.3)
        width: parent.width
        anchors.bottom: parent.bottom
    }
}
