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

import "../../components/Models" as TweakToolModels
import "../../components/ListItems" as ListItem
import "../../components/Upstream" as Upstream

Item {
    anchors.fill: parent

    TweakToolModels.ApplicationsModel {
        id: appsModel

        Component.onCompleted: {
            var entries =
                    [
                        {
                            appId: "com.ubuntu.terminal",
                            pageUrl: Qt.resolvedUrl("applicationsTab/TerminalApp.qml")
                        }
                    ]

            appsModel.append(entries);
            init();
        }
    }

    Loader {
        anchors.fill: parent
        sourceComponent: (appsModel.availableApps.count) > 0 ? appsView : emptyState
    }

    Component {
        id: appsView

        ListView {
            anchors.fill: parent

            model: SortFilterModel {
                model: appsModel.availableApps
                sort.property: "title"
                sort.order: Qt.AscendingOrder
            }

            delegate: ListItem.Application {
                appEntry: model.appEntry
                pageUrl: model.pageUrl
            }
        }
    }

    Component {
        id: emptyState

        Item {
            anchors {
                fill: parent
                margins: units.gu(2)
            }

            Upstream.EmptyState {
                iconName: "ubuntu-store-symbolic"
                title: i18n.tr("No supported application")
                subTitle: i18n.tr("All the applications supported by this tool will be listed here.")

                anchors.centerIn: parent
                width: parent.width
            }
        }
    }
}
