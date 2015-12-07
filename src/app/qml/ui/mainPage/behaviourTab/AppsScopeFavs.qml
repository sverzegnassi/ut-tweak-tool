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
import GSettings 1.0
import TweakTool 1.0
import TweakTool.Click 1.0
import QtQuick.Layouts 1.1

import "../../../components"
import "../../../components/ListItems" as ListItem
import "../../../components/Upstream"

Page {
    id: rootItem
       
    head.actions: Action {
        iconName: "add"
        text: i18n.tr("Add new favorite")
        onTriggered: {
            var page = pageStack.push(addPage)
            page.itemToBeAdded.connect(function(appId) {
                var a = settings.coreApps
                a.push(appId)
                settings.coreApps = a;
            })
        }
    }

    // WORKAROUND: Fix anchoring for the ListView. This is necessary because of
    // some issue with the custom header.
    Component.onCompleted: {
        view.anchors.fill = null
        view.anchors.fill = view.parent
    }

    /*
      FIXME: Disable drag mode when windows/page is no more active and/or user
      tap away from the items (use InverseMouseArea?) and/or the list is resetted.
    */
    ListView {
        id: view
        anchors.fill: parent

        model: settings.coreApps

        header: Column {
            width: parent.width

            ListItem.Warning {
                id: warning
                imageUrl: Qt.resolvedUrl("../../../../../../graphics/apps-scope.png")
                text: i18n.tr("Set your favorite apps to be shown in the applications scope.<br><br>Swipe to right to delete an item.<br>Press and hold to enable the sorting mode.")
            }

            ListItem.SectionDivider { id: section; text: i18n.tr("Favorite apps") }

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
        footer: ListItem.Button {
            button {
                text: i18n.tr("Reset")
                onClicked: settings.schema.reset("coreApps")
            }
        }

        delegate: ListItem.AppLauncher {
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

    Component {
        id: addPage

        Page {
            id: addPageItem
            title: i18n.tr("Add new favorite")

            signal itemToBeAdded(string appId)

            ListView {
                anchors.fill: parent

                model: SortFilterModel {
                    model: appsModel

                    sort.property: "name"
                    sort.order: Qt.AscendingOrder
                }

                header: Column {
                    width: parent.width

                    ListItem.Page {
                        text: i18n.tr("Add more used applications")
                        pageComponent: Component {
                            Page {
                                id: rootItem

                                head.backAction: Action {
                                    iconName: "close"
                                    text: i18n.tr("Back")
                                    onTriggered: pageStack.pop()
                                }

                                head.actions: Action {
                                    iconName: "ok"
                                    text: i18n.tr("Add favorites to the list")
                                    onTriggered: {
                                        var apps = [];
                                        for (var i=0; i<moreUsedAppsView.numberOfTopAppsToPick; i++) {
                                            apps.push(appStatsModel.get(i).appId);
                                        }

                                        settings.coreApps = apps;
                                        pageStack.pop();
                                     }
                                }

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

                                ListView {
                                    id: moreUsedAppsView
                                    anchors.fill: parent

                                    property int numberOfTopAppsToPick: 0

                                    header: Column {
                                        width: parent.width

                                        ListItem.Base {
                                            height: topSliderLayout.height + units.gu(6)
                                            Column {
                                                id: topSliderLayout
                                                anchors {
                                                    verticalCenter: parent.verticalCenter
                                                    left: parent.left
                                                    right: parent.right
                                                    margins: units.gu(2)
                                                }

                                                spacing: units.gu(0.5)

                                                Label { text: i18n.tr("Number of top apps to select:") }

                                                Slider {
                                                    id: topSlider

                                                    value: 3
                                                    onValueChanged: moreUsedAppsView.numberOfTopAppsToPick = value.toFixed(0)

                                                    minimumValue: 3
                                                    maximumValue: 9

                                                    function formatValue(v) { return v.toFixed(0) }
                                                }

                                                RowLayout {
                                                    width: parent.width
                                                    Label { text: topSlider.minimumValue; Layout.fillWidth: true }
                                                    Label { text: topSlider.maximumValue }
                                                }
                                            }
                                        }

                                        ListItem.SectionDivider { text: i18n.tr("Most used apps") }
                                    }

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
                        }
                    }

                    ListItem.SectionDivider { text: i18n.tr("Available apps") }
                }

                delegate: ListItem.AppLauncher {
                    title.text: model.name
                    subtitle.text: model.exec
                    iconSource: model.icon

                    enabled: settings.coreApps.indexOf(model.exec) == -1

                    onClicked: {
                        addPageItem.itemToBeAdded(model.exec)

                        // Close most-used app page
                        pageStack.pop()

                        // Close add fav app page
                        pageStack.pop()
                    }
                }
            }
        }
    }
}
