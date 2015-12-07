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

ListModel {
    id: rootItem

    property ListModel availableApps: ListModel { }

    function init() {
        for (var i=0; i<rootItem.count; i++) {
            var entry = rootItem.get(i);

            if (clickModel.checkAppExistsById(entry.appId)) {
                var appEntry = clickModel.getById(entry.appId);

                // We need all the properties in appEntry in a "root" level
                // so we can use a SortFilterModel, but at the same time we need
                // an "aggregator" property for ListItem.Application.
                // For that reason we append appEntry inside appEntry.
                appEntry["appEntry"] = appEntry;
                appEntry["pageUrl"] = entry.pageUrl;

                availableApps.append(appEntry);
            }
        }
    }
}
