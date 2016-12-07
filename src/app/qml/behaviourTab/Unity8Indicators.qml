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

import "../components"
import "../components/ListItems" as ListItems

Page {
    id: rootItem

    header: PageHeader {
        title: i18n.tr("Indicators")
        flickable: view.flickableItem
    }

    ScrollView {
        id: view
        anchors.fill: parent

        Column {
            width: view.width

            ListItems.SectionDivider {
                text: i18n.tr("General")

                // Check for "undefined"
                // Ref. http://askubuntu.com/questions/527799/how-do-you-check-if-a-property-is-undefined-in-qml
                visible: settings.enableIndicatorMenu ? true : false
            }

            ListItems.Control {
                title.text: i18n.tr("Enable the indicator menu")
                summary.text: i18n.tr("Enable or disable the indicator menu")
                summary.maximumLineCount: Number.MAX_VALUE

                // Check for "undefined"
                // Ref. http://askubuntu.com/questions/527799/how-do-you-check-if-a-property-is-undefined-in-qml
                visible: settings.enableIndicatorMenu ? true : false

                control: Switch {
                    Component.onCompleted: checked = settings.enableIndicatorMenu
                    onClicked: {
                        settings.enableIndicatorMenu = !settings.enableIndicatorMenu
                    }
                }
            }

            ListItems.SectionDivider { text: i18n.tr("Battery") }

            ListItems.Control {
                title.text: i18n.tr("Show percentage on panel")

                Switch {
                    Component.onCompleted: checked = powerSettings.showPercentage
                    onClicked: powerSettings.showPercentage = checked
                }
            }
        }
    }

    GSettings {
        id: settings
        schema.id: "com.canonical.Unity8"
    }


    GSettings {
        id: powerSettings
        schema.id: "com.canonical.indicator.power"
    }
}
