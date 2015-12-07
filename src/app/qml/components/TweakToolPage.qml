/*
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

Page {
    id: rootPage
    default property alias content: layout.data
    flickable: flicky

    Flickable {
        id: flicky
        //anchors.fill: parent
        interactive: true

        contentWidth: width
        contentHeight: layout.height

        Column {
            id: layout

            anchors {
                left: parent.left
                right: parent.right
            }
        }
    }

    onActiveChanged: {
        /*
           WORKAROUND: We use a custom header style, that completely hide the
           header divider is there's no section.
           This causes a wrong alignment of the page content when the new page
           has no section. We need to force the re-aligning of the page, in
           order to ensure that the first units.gu(3) pixel of the content are
           visible.
         */
        flicky.anchors.fill = flicky.parent
    }
}
