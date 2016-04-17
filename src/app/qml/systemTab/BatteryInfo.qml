/*
  This file is part of ut-tweak-tool
  Copyright (C) 2015 Mutse Young
  Copyright (C) 2015, 2016 Stefano Verzegnassi <verzegnassi.stefano@gmail.com>

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
import QtSystemInfo 5.5

import "../components/ListItems" as ListItems

Page {
    header: PageHeader {
        title: i18n.tr("Battery information")
        flickable: view.flickableItem
    }

    BatteryInfo {
        id: batteryInfo
    }

    ScrollView {
        id: view
        anchors.fill: parent

        Column {
            width: view.width

            ListItems.SingleValue {
                title.text: i18n.tr("Level:")
                value: batteryInfo.level + "%"
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Cycle count:")
                value: batteryInfo.cycleCount
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Maximum capacity:")
                value: "%1 mAh".arg(batteryInfo.maximumCapacity)
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Remaining capacity:")
                value: "%1 mAh".arg(batteryInfo.remainingCapacity)
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Capacity:")
                value: (batteryInfo.remainingCapacity / batteryInfo.maximumCapacity) + "%"
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Health:")
                value: {
                    switch (batteryInfo.health) {
                    case BatteryInfo.HealthUnknown:
                        return i18n.tr("<i>Unknown</i>")
                    case BatteryInfo.HealthOk:
                        return i18n.tr("Ok")
                    case BatteryInfo.HealthBad:
                        return i18n.tr("Bad")
                    }
                }
            }

            ListItems.SingleValue {
                title.text: i18n.tr("Temperature:")
                value: batteryInfo.temperature + "°C"
            }
        }
    }
}
