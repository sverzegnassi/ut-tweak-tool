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
import GSettings 1.0

import "../../../components"
import "../../../components/ListItems" as ListItem

TweakToolPage {
    id: rootItem
       
    function getSelectedIndex() {
        if (settings.usageMode === "Staged")
            return 0;

        if (settings.usageMode === "Windowed")
            return 1;
    }

    function setFromSelectedIndex(selectedIndex) {
        if (selectedIndex == 0)
            settings.usageMode = "Staged"

        if (selectedIndex == 1)
            settings.usageMode = "Windowed"
    }

    ListItem.Warning {
        iconName: "computer-symbolic"
        text: i18n.tr("This setting allows you to switch from the stage mode (default for mobile device) to the windowed mode (which will become the UI of the future Ubuntu desktops).")
    }

    ListItem.SectionDivider { text: i18n.tr("Usage mode")}

    ListItem.OptionSelector {
        model: [ i18n.tr("Staged"), i18n.tr("Windowed") ]

        Component.onCompleted: selectedIndex = getSelectedIndex()
        onSelectedIndexChanged: setFromSelectedIndex(selectedIndex)
    }
    
    GSettings {
        id: settings
        schema.id: "com.canonical.Unity8"
    }
}
