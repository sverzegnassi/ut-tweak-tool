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
import "../components/ListItems" as ListItems

ScrollView {
    id: rootItem
    anchors.fill: parent

    Column {
        width: rootItem.width

        ListItems.SectionDivider {
            iconName: "ubuntu-store-symbolic"
            text: i18n.tr("Application scope")
        }

        ListItems.Page {
            text: i18n.tr("Favorite apps")
            pageUrl: Qt.resolvedUrl("AppsScopeFavs.qml")
        }

        // Unity 8 section
        ListItems.SectionDivider {
            iconName: "computer-symbolic"
            text: i18n.tr("Unity 8")
        }

        ListItems.Page {
            text: i18n.tr("Usage mode")
            pageUrl: Qt.resolvedUrl("Unity8Mode.qml")
        }

        ListItems.Page {
            text: i18n.tr("Launcher")
            pageUrl: Qt.resolvedUrl("Unity8Launcher.qml")
        }

        ListItems.Page {
            text: i18n.tr("Indicators")
            pageUrl: Qt.resolvedUrl("Unity8Indicators.qml")
        }

        ListItems.Page {
            text: i18n.tr("Edge sensitivity")
            pageUrl: Qt.resolvedUrl("Unity8EdgeSensitivity.qml")
        }
    }
}
