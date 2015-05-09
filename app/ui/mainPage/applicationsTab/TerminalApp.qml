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
import StorageManager 1.0

import "../../../components"
import "../../../components/ListItems" as ListItem
import "../../../components/Dialogs"

TweakToolPage {
    id: rootItem

    function importKeybProfile(url) {
        var path = StorageManager.getXdgFolder(StorageManager.ConfigLocation) + "/com.ubuntu.terminal/Layouts"

        var fileSrcPath = url.toString().replace("file://", "");
        var fileName = StorageManager.getFileFullName(fileSrcPath);

        var msgText = [];
        var msgIndex;

        // Toast notification text
        msgText.push(i18n.tr("Keyboard layout '%1' successfully imported!").arg(fileName))
        msgText.push(i18n.tr("Error while importing the keyboard layout!"))
        msgText.push(i18n.tr("Keyboard layout '%1' already exists!").arg(fileName))
        msgText.push(i18n.tr("Error while importing the keyboard layout!"))

        if (StorageManager.mkPath(path)) {
            if (!StorageManager.exists(path + "/" + fileName)) {
                msgIndex = StorageManager.copyFile(fileSrcPath, path) ? 0 : 1
            } else {
                msgIndex = 2;
            }
        } else {
            msgIndex = 3;
        }

        showNotification({ "text": msgText[msgIndex] });
    }

    ListItem.SectionDivider { text: i18n.tr("Keyboard profiles") }

    ListItem.Warning {
        iconName: "input-keyboard-symbolic"
        text: i18n.tr("Ubuntu Terminal App allows users to add custom preset for the frequently used commands.<br>Check out <a href=\"https://swordfishslabs.wordpress.com/2015/02/27/json-profiles-in-ubuntu-terminal-app/\">Filippo Scognamiglio's post</a> for the details.")
    }

    ListItem.Button {
        title.text: i18n.tr("Add a custom profile")
        button {
            text: i18n.tr("Pick")
            onClicked: pageStack.push(fileDialog)
        }
    }

    Component {
        id: fileDialog

        FileChooserDialog {
            title: i18n.tr("Choose a keyb layout")
            folder: "file://" + StorageManager.getXdgFolder(StorageManager.HomeLocation)
            nameFilters: ["*.json"]

            onAccepted: rootItem.importKeybProfile(pathsList[0])
        }
    }
}
