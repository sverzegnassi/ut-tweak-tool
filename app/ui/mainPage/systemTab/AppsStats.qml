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
import TweakTool 1.0
import TweakTool.Click 1.0

import "../../../components"
import "../../../components/ListItems" as ListItem

TweakToolPage {
    id: rootItem

    function launchAppStatsProcess() {
        var entries = Process.launch("ubuntu-app-usage").split("\n");
        
        for (var i=0; i<entries.length; i++) {
            // We are not interested in gathering unity8 data
            if (entries[i].indexOf("unity8-dash") < 0
                    && entries[i] !== "") {
                var parts = entries[i].split(/\s+/);
                
                appStatsModel.append({ "appId": parts[0].split("_")[0], "usage": parts[1] });
            }
        }
    }

    function duration(i18n, time) {
        if (time >= 60 * 60)
            // TRANSLATORS: %1 is a time duration, expressed in hours
            return i18n.tr("%1 hours").arg((time / (60 * 60)).toFixed(2));

        if (time >= 60)
            // TRANSLATORS: %1 is a time duration, expressed in minutes
            return i18n.tr("%1 mins").arg((time / 60).toFixed(2));

        // TRANSLATORS: %1 is a time duration, expressed in seconds
        return i18n.tr("%1 secs").arg(time);
    }

    Component.onCompleted: launchAppStatsProcess()

    ListModel { id: appStatsModel }
    ApplicationsModel { id: appsModel }

    ListItem.Warning {
        // TODO: Need a proper icon for this
        iconName: "like"
        text: i18n.tr("This is the list of the top used application.")
    }

    ListItem.SectionDivider { text: i18n.tr("Time of usage") }

    Repeater {
        model: appStatsModel
        delegate: ListItem.Base {
            id: delegate

            property var appEntry: appsModel.get(model.appId)
            height: units.gu(9)

            RowLayout {
                anchors.fill: parent
                spacing: units.gu(2)

                UbuntuShape {
                    implicitHeight: units.gu(7); implicitWidth: implicitHeight
                    image: Image { source: appEntry.icon }
                }
                
                Label {
                    text: appEntry.name
                    Layout.fillWidth: true
                }

                Label { text: rootItem.duration(i18n, model.usage) }
            }
        }
    }
}
