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
import Ubuntu.Components.ListItems 1.3 as UbuntuListItems
import TweakTool 1.0

import "../components"

Item {
    id: rootItem
    anchors.fill: parent

    PackagesModel { id: clickModel }

    UbuntuListItems.ItemSelector {
        id: filterSelector
        model: [ i18n.tr("Show all"), i18n.tr("Contains an app"), i18n.tr("Contains a scope") ]
        onSelectedIndexChanged: clickModel.showFilter = selectedIndex
    }

    EmptyState {
        iconName: "ubuntu-store-symbolic"
        title: i18n.tr("No installed package")

        anchors.centerIn: parent
        width: parent.width
        visible: clickModel.count == 0 && clickModel.ready
    }

    ActivityIndicator {
        id: activityIndicator
        anchors.centerIn: parent
        visible: running
        running: true

        // Show this indicator only on first initialization
        Connections {
            target: clickModel
            onReadyChanged: if (clickModel.ready) { activityIndicator.running = false }
        }
    }

    ScrollView {
        anchors {
            top: filterSelector.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        ListView {
            id: view
            anchors.fill: parent

            model: SortFilterModel {
                model: clickModel

                sort.property: "title"
                sort.order: Qt.AscendingOrder
                sortCaseSensitivity: Qt.CaseInsensitive
            }

            delegate: ListItem {
                onClicked: pageStack.push(applicationPage, { pkg: clickModel.get(model.appId) } )

                ListItemLayout {
                    anchors.fill: parent

                    title.text: model.title
                    subtitle {
                        text: model.description
                        wrapMode: Text.WrapAnywhere
                        elide: Text.ElideRight
                    }

                    UbuntuShape {
                        SlotsLayout.position: SlotsLayout.Leading
                        height: units.gu(5); width: height
                        aspect: UbuntuShape.DropShadow

                        image: Image {
                            id: thumb
                            source: model.iconPath
                            asynchronous: true
                            sourceSize { width: thumb.width; height: thumb.height }
                        }
                    }

                    Icon {
                        SlotsLayout.position: SlotsLayout.Last
                        width: units.gu(2); height: width
                        name: "go-next"
                    }
                }
            }

            Component.onCompleted: {
                // FIXME: workaround for qtubuntu not returning values depending on the grid unit definition
                // for Flickable.maximumFlickVelocity and Flickable.flickDeceleration
                var scaleFactor = units.gridUnit / 8;
                maximumFlickVelocity = maximumFlickVelocity * scaleFactor;
                flickDeceleration = flickDeceleration * scaleFactor;
            }

            PullToRefresh {
                enabled: true
                refreshing: !clickModel.ready
                onRefresh: clickModel.refresh()
            }
        }
    }

    Component {
        id: applicationPage
        ApplicationPage {
            id: appPage
            onUninstallRequested: {
                clickModel.uninstallPackage(appPage.pkg)
                ScopeHelper.invalidateScope("clickscope")
            }
        }
    }
}
