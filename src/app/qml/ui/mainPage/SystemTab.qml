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

Column {
    anchors.fill: parent

    ListItem.SectionDivider { text: i18n.tr("Click packages") }

    // TO BE FINISHED (FileChooserDialog refactioring + support for new component)
    ListItem.Page {
        text: i18n.tr("Install click packages from a local path")
        pageUrl: Qt.resolvedUrl("./systemTab/InstallClickFromLocal.qml")
    }

    ListItem.Page {
        text: i18n.tr("Uninstall scopes")
        pageUrl: Qt.resolvedUrl("./systemTab/UninstallScopes.qml")
    }

    ListItem.SectionDivider { text: i18n.tr("OS Image") }

    ListItem.Page {
        text: i18n.tr("Make image writable")
        pageUrl: Qt.resolvedUrl("./systemTab/ImageWritable.qml")
    }

    ListItem.SectionDivider { text: i18n.tr("USB mode") }

    ListItem.Page {
        text: i18n.tr("Set USB behavior when connected to a PC")
        pageUrl: Qt.resolvedUrl("./systemTab/UsbMode.qml")
    }

    ListItem.SectionDivider { text: i18n.tr("Stats") }

    ListItem.Page {
        text: i18n.tr("Application usage")
        pageUrl: Qt.resolvedUrl("./systemTab/AppsStats.qml")
    }
}
