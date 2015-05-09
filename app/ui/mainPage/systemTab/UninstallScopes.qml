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
import QtQuick.Layouts 1.1
import TweakTool 1.0
import TweakTool.Click 1.0

import "../../../components/ListItems" as ListItem
import "../../../components/Upstream" as Upstream

Page {
    id: rootItem

    SortFilterModel {
        id: scopesModel
        model: clickModel

        sort.property: "title"
        sort.order: Qt.AscendingOrder

        filter.pattern: /true/
        filter.property: "isScope"
    }

    Loader {
        anchors.fill: parent
        sourceComponent: (scopesModel.count) > 0 ? scopesView : emptyState
    }

    Component {
        id: scopesView

        ListView {
            anchors.fill: parent

            header: ListItem.SectionDivider { text: i18n.tr("Installed scopes") }

            model: scopesModel

            delegate: ListItem.Base {
                id: delegate

                height: units.gu(9)

                // TODO: Find out a way to automatically open the "preview" page (or uninstall scope through pkcon)
                onClicked: Qt.openUrlExternally("scope://com.canonical.scopes.clickstore?q=" + model.name)

                RowLayout {
                    anchors.fill: parent
                    spacing: units.gu(2)

                    UbuntuShape {
                        implicitHeight: units.gu(7); implicitWidth: implicitHeight
                        image: Image { source:  "file://" + model.directory + "/" + model.icon }
                    }

                    Captions {
                        id: captions

                        title.text: model.title
                        subtitle.text: model.name

                        Layout.fillWidth: true
                    }

                    Icon {
                        width: units.gu(2); height: width
                        name: "go-next"
                    }
                }
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
                iconName: "search"
                title: i18n.tr("No installed scope")
                subTitle: i18n.tr("All the scopes installed from a click package will be listed here.")

                anchors.centerIn: parent
                width: parent.width
            }
        }
    }
}
