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

import "../../components/ListItems" as ListItem
import "behaviourTab"


Column {
    anchors.fill: parent

    // Unity 8 section
    ListItem.SectionDivider { text: i18n.tr("Unity 8") }

    ListItem.Page {
        text: i18n.tr("Usage mode")
        pageUrl: Qt.resolvedUrl("behaviourTab/Unity8Mode.qml")
    }

	ListItem.Page {
        text: i18n.tr("App scope favorites")
        pageUrl: Qt.resolvedUrl("behaviourTab/AppsScopeFavs.qml")
    }

    Loader {
        width: parent.width
        height: item ? item.height : 0
        source: Qt.resolvedUrl("behaviourTab/GestureTutorial.qml")
    }

    // Audio section
    ListItem.SectionDivider { text: i18n.tr("Audio") }

    ListItem.Page {
        text: i18n.tr("Set a custom ringtone")
        pageUrl: Qt.resolvedUrl("behaviourTab/Audio.qml")
    }
}
