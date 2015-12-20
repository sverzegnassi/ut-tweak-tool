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
import TweakTool 1.0
import TweakTool.Click 1.0
import QtQuick.Layouts 1.1

import "../components"
import "../components/ListItems" as ListItems
import "../components/Upstream"

Page {
    id: rootItem
       
    head.actions: Action {
        iconName: "add"
        text: i18n.tr("Add new favorite")
        onTriggered: pageStack.addPageToNextColumn(rootItem, addAppsToScopePage)
    }

    Component {
        id: addAppsToScopePage

        AppsScopeFavsAddFromInstalled {
            onItemToBeAdded: {
                var a = settings.coreApps
                a.push(appId)
                settings.coreApps = a;
            }
        }
    }

    /*
      FIXME: Disable drag mode when windows/page is no more active and/or user
      tap away from the items (use InverseMouseArea?) and/or the list is resetted.
    */
    ListView {
        id: view
        anchors {
            fill: parent
            //leftMargin: units.gu(2)
            //rightMargin: units.gu(2)
        }

        model: settings.coreApps

        header: Column {
            width: parent.width

            ListItems.Warning {
                id: warning
                imageUrl: Qt.resolvedUrl("graphics/apps-scope.png")
                text: i18n.tr("Set your favorite apps to be shown in the applications scope.<br>Swipe to right to delete an item. Press and hold to enable the sorting mode.")
            }

            ListItems.SectionDivider { id: section; text: i18n.tr("Favorite apps") }

            Item {
                visible: view.count == 0
                width: parent.width
                height: view.height - (warning.height + section.height)

                EmptyState {
                    title: i18n.tr("No favorite specified")
                    subTitle: i18n.tr("Default applications will be shown in the 'App' scope.\nTap the '+' in the header to add a favorite app.")
                    iconName: "ubuntu-store-symbolic"

                    width: parent.width
                    anchors.centerIn: parent
                }
            }
        }

        /*
          FIXME: For some reason, while switching to the drag mode, the footer
          is marked as draggable too, although (as expected) it's not really
          draggable.
          It seems to be an upstream bug, in UITK.
        */
        footer: ListItems.Control {
            Button {
                text: i18n.tr("Reset")
                onClicked: settings.schema.reset("coreApps")
                color: UbuntuColors.orange
            }
        }

        delegate: ListItems.AppLauncher {
            property var appEntry: appsModel.get(modelData)

            title.text: appEntry.name
            subtitle.text: appEntry.exec
            iconSource: appEntry.icon

            onPressAndHold: ListView.view.ViewItems.dragMode = !ListView.view.ViewItems.dragMode
            leadingActions: ListItemActions {
                actions: [
                    Action {
                        iconName: "delete"
                        text: i18n.tr("Delete")
                        onTriggered: {
                            var a = settings.coreApps
                            var i = a.indexOf(modelData)
                            if (i > -1) {
                                a.splice(i, 1)
                            }

                            settings.coreApps = a;
                        }
                    }
                ]
            }
        }

        ViewItems.onDragUpdated: {
            if (event.status == ListItemDrag.Started) {
                return;
            } else if (event.status == ListItemDrag.Dropped) {
                var fromData = model[event.from];
                // must use a temporary variable as list manipulation
                // is not working directly on model
                var list = model;
                list.splice(event.from, 1);
                list.splice(event.to, 0, fromData);
                settings.coreApps = list;
            } else {
                event.accept = false;
            }
        }
    }

    GSettings {
        id: settings
        schema.id: "com.canonical.Unity.ClickScope"
    }

    ApplicationsModel { id: appsModel }
}
