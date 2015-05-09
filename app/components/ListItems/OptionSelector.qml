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

import "." as ListItem

Column {
    id: rootItem
    anchors { left: parent.left; right: parent.right }
    opacity: rootItem.enabled ? 1.0 : 0.3

    property var model
    property int selectedIndex: -1

    Repeater {
        model: rootItem.model
        delegate: ListItem.Base {
            height: units.gu(8)
            width: parent.width
            color: "white"

            onClicked: rootItem.selectedIndex = model.index

            RowLayout {
                anchors.fill: parent

                Label {
                    text: modelData
                    Layout.fillWidth: true
                }

                Icon {
                    width: units.gu(2); height: width

                    name: "tick"
                    visible: rootItem.selectedIndex == model.index
                }
            }
        }
    }
}
