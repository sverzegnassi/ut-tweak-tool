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
import GSettings 1.0
import TweakTool 1.0
import TweakTool.Click 1.0
import QtQuick.Layouts 1.1

import "../components"
import "../components/ListItems" as ListItems

Page {
    id: addPageItem
    title: i18n.tr("Add new favorite")

    signal itemToBeAdded(string appId)

    ListView {
        anchors {
            fill: parent
            //leftMargin: units.gu(2)
            //rightMargin: units.gu(2)
        }

        clip: true

        model: SortFilterModel {
            model: appsModel

            sort.property: "name"
            sort.order: Qt.AscendingOrder
        }

        header: ListItems.SectionDivider { text: i18n.tr("Available apps") }

        delegate: ListItems.AppLauncher {
            title.text: model.name
            subtitle.text: model.exec
            iconSource: model.icon

            enabled: settings.coreApps.indexOf(model.exec) == -1

            onClicked: {
                addPageItem.itemToBeAdded(model.exec)

                // Close most-used app page
                pageStack.removePages(addPageItem)
            }
        }
    }
}
