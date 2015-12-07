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

Item {
    id: rootItem

    property url manifestUrl

    function get(value) {
        var entry = model.get(0);

        if (value in entry)
            return entry[value]

        return ""
    }

    onManifestUrlChanged: {
        model.clear()
        d.init()
    }

    ListModel { id: model }

    QtObject {
        id: d

        function init() {
            // Read manifest.json data
            var doc = new XMLHttpRequest();
            doc.onreadystatechange = function() {
                if (doc.readyState == XMLHttpRequest.DONE) {
                    model.append(JSON.parse(doc.responseText));
                }
            }
            doc.open("get", rootItem.manifestUrl);
            doc.setRequestHeader("Content-Encoding", "UTF-8");
            doc.send();
        }
    }
}
