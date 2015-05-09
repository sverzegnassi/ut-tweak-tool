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
import Ubuntu.Components.Popups 1.0
import StorageManager 1.0
import GSettings 1.0
import Ubuntu.SystemSettings.Sound 1.0

import "../../../components"
import "../../../components/ListItems" as ListItem
import "../../../components/Dialogs"

// TODO: Show an audio trimmer when a file is picked
// TODO: Always create a new copy of the file in the internal storage.

TweakToolPage {
    id: rootItem

    function getSettings() {
        callSoundItem.subtitle.text = StorageManager.getFileFullName(settings.incomingCallSound)
        messageSoundItem.subtitle.text = StorageManager.getFileFullName(settings.incomingMessageSound)
    }

    function setIncomingCallSound(file) {
        settings.incomingCallSound = file;
        backend.incomingCallSound = file;

        getSettings();
    }

    function setIncomingMessageSound(file) {
        settings.incomingMessageSound = file;
        backend.incomingMessageSound = file;

        getSettings();
    }

    Component.onCompleted: getSettings()

    ListItem.Warning {
        text: i18n.tr("Please note that if you choose an audio file from an external media (e.g. SD card), that file could not be played if the media will be removed.")
    }

    ListItem.SectionDivider { text: i18n.tr("Ringtone") }

    ListItem.Button {
        id: callSoundItem

        title.text: i18n.tr("Current sound:")
        subtitle.text: "Dummy text"

        button {
            text: i18n.tr("Pick")
            onClicked: {
                var picker = pageStack.push(fileDialog);
                picker.accepted.connect(function(pathsList) {
                    setIncomingCallSound(pathsList[0].toString().replace("file://", ""))
                });
            }
        }
    }

    ListItem.Base {
        Label {
            text: i18n.tr("Restore default...")
            anchors.verticalCenter: parent.verticalCenter
        }

        onClicked: {
            var dialog = PopupUtils.open(defaultDialog);
            dialog.accepted.connect(function() {
                setIncomingCallSound("/usr/share/sounds/ubuntu/ringtones/Harmonics.ogg")
            });
        }
    }

    ListItem.SectionDivider { text: i18n.tr("Message received") }

    ListItem.Warning {
        iconName: "messages-new"
        text: i18n.tr("Ensure your audio file length is max. 10 seconds.<br><b>N.B.</b> The file will be played until its end: if you use a 3 minutes song, your device will be ringing for that time!")
    }

    ListItem.Button {
        id: messageSoundItem

        title.text: i18n.tr("Current sound:")
        button {
            text: i18n.tr("Pick")
            onClicked: {
                var picker = pageStack.push(fileDialog);
                picker.accepted.connect(function(pathsList) {
                    setIncomingMessageSound(pathsList[0].toString().replace("file://", ""))
                })
            }
        }
    }

    ListItem.Base {
        Label {
            text: i18n.tr("Restore default...")
            anchors.verticalCenter: parent.verticalCenter
        }

        onClicked: {
            var dialog = PopupUtils.open(defaultDialog);
            dialog.accepted.connect(function() {
                setIncomingMessageSound("/usr/share/sounds/ubuntu/notifications/Xylo.ogg")
            })
        }
    }

    GSettings {
        id: settings
        schema.id: "com.ubuntu.touch.sound"
    }

    UbuntuSoundPanel { id: backend }

    Component {
        id: fileDialog

        FileChooserDialog {
            title: i18n.tr("Choose a ringtone")
            folder: "file://" + StorageManager.getXdgFolder(StorageManager.HomeLocation)
            nameFilters: ["*.mp3", "*.ogg"]
        }
    }

    Component {
        id: defaultDialog

        Dialog {
            id: defaultDialogue

            signal accepted

            title: i18n.tr("Restore default")
            text: i18n.tr("Are you sure?")

            Button {
                text: i18n.tr("Yes")
                color: UbuntuColors.orange
                onClicked: {
                    defaultDialogue.accepted();
                    PopupUtils.close(defaultDialogue);
                }
            }

            Button {
                text: i18n.tr("No")
                onClicked: PopupUtils.close(defaultDialogue);
            }
        }
    }
}
