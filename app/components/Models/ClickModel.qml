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
import TweakTool 1.0
import Ubuntu.Components 1.1

ListModel {
    id: rootItem

    readonly property string clickCmd: "click list --user=phablet --manifest"

    Component.onCompleted: refresh()

    function refresh() {
        console.time("appModel")
        rootItem.clear()

        // Is it slow because of dynamic rules? 545-650ms
        var json = Process.launch(clickCmd).split("_directory").join("directory")
        rootItem.append(JSON.parse(json))

        var entry;
        for (var i=0; i<rootItem.count; i++) {
            entry = get(i);
            if (JSON.stringify(entry.hooks).indexOf("desktop") > -1) {
                rootItem.set(i, { "isApp": true })
            } else {
                rootItem.set(i, { "isApp": false })
            }

            if (JSON.stringify(entry.hooks).indexOf("scope") > -1) {
                rootItem.set(i, { "isScope": true })
            } else {
                rootItem.set(i, { "isScope": false })
            }
        }
        console.timeEnd("appModel")
    }

    // METHOD 1: 550ms
    /*function checkAppExistsById(appId) {
        console.time("exists")

        var cmd = "%1 | grep %2".arg(clickCmd).arg(appId)
        var exists = Process.launch(cmd).indexOf(appId) > 0
        console.timeEnd("exists")
        return exists
    }
    */

    //METHOD 2: with 9 entry it takes 21ms when false, 0ms when true. we could suppose we need 230 entries to get 550ms
    function checkAppExistsById(appId) {
        console.time("exists")
        var entry;
        for (var i=0; i<rootItem.count; i++) {
            entry = get(i);

            if (entry.name === appId) {
                console.timeEnd("exists")
                return true;
            }
        }
        console.timeEnd("exists")
        return false
    }

    function getById(appId) {
        var entry;

        for (var i=0; i<rootItem.count; i++) {
            entry = get(i);

            if (entry.name === appId) {
                return entry;
            }
        }
    }
}
