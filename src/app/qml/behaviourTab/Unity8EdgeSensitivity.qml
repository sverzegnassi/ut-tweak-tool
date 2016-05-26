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

import "../components"
import "../components/ListItems" as ListItems

Page {
    id: rootItem
          
    header: PageHeader {
        title: i18n.tr("Edge sensitivity")
        flickable: view.flickableItem
    }

    ScrollView {
        id: view
        anchors.fill: parent

        Column {
            width: view.width

            ListItems.SectionDivider { text: i18n.tr("Edge barrier sensitivity") }

            ListItem {
                height: Math.max(implicitHeight, sensitivitylayout.height)

                ListItemLayout {
                    id: sensitivitylayout
                    anchors.centerIn: parent
                    title.text: i18n.tr("Current value: %1").arg(sensitivitySlider.value.toFixed(0))
                    subtitle.text: i18n.tr("Sensitivity of screen edge barriers for the mouse pointer.")
                    summary.text: i18n.tr("Some UI actions like revealing the launcher or the applications spread are triggered by pushing the mouse pointer against a screen edge. This key defines how much you have to push in order to trigger the associated action.")
                    summary.maximumLineCount: Number.MAX_VALUE
                }
            }

            ListItem {
                height: units.gu(12)
                Button {
                    id: sensitivityResetButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: units.gu(2)
                    color: UbuntuColors.orange

                    action: Action {
                        text: i18n.tr("Reset")
                        onTriggered: {
                            settings.schema.reset("edgeBarrierSensitivity")
                            sensitivitySlider.value = settings.edgeBarrierSensitivity
                        }
                    }
                }

                Slider {
                    id: sensitivitySlider
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: sensitivityResetButton.right
                    anchors.right: parent.right
                    anchors.margins: units.gu(2)

                    minimumValue: 1
                    maximumValue: 100

                    Component.onCompleted: {
                        value = settings.edgeBarrierSensitivity
                    }
                    onValueChanged: {
                        settings.edgeBarrierSensitivity = value.toFixed(0)
                    }
                }
            }

            ListItems.SectionDivider { text: i18n.tr("Edge barrier minimum push") }

            ListItem {
                height: Math.max(implicitHeight, minpushlayout.height)

                ListItemLayout {
                    id: minpushlayout
                    anchors.centerIn: parent
                    title.text: i18n.tr("Current value: %1").arg(minPushSlider.value.toFixed(0))
                    subtitle.text: i18n.tr("Minimum push needed to overcome edge barrier.")
                    summary.text: i18n.tr("How much you have to push (in grid units) the mouse against an edge barrier when sensibility is 100.")
                }
            }

            ListItem {
                height: units.gu(12)
                Button {
                    id: minPushResetButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: units.gu(2)
                    color: UbuntuColors.orange

                    action: Action {
                        text: i18n.tr("Reset")
                        onTriggered: {
                            settings.schema.reset("edgeBarrierMinPush")
                            minPushSlider.value = settings.edgeBarrierMinPush
                        }
                    }
                }

                Slider {
                    id: minPushSlider
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: minPushResetButton.right
                    anchors.right: parent.right
                    anchors.margins: units.gu(2)

                    minimumValue: 1
                    maximumValue: 100

                    Component.onCompleted: {
                        value = settings.edgeBarrierMinPush
                    }
                    onValueChanged: {
                        settings.edgeBarrierMinPush = value.toFixed(0)
                    }
                }
            }


            ListItems.SectionDivider { text: i18n.tr("Edge barrier maximum push") }

            ListItem {
                height: Math.max(implicitHeight, maxpushlayout.height)

                ListItemLayout {
                    id: maxpushlayout
                    anchors.centerIn: parent
                    title.text: i18n.tr("Current value: %1").arg(maxPushSlider.value.toFixed(0))
                    subtitle.text: i18n.tr("Maximum push needed to overcome edge barrier.")
                    summary.text: i18n.tr("How much you have to push (in grid units) the mouse against an edge barrier when sensibility is 1.")
                }
            }

            ListItem {
                height: units.gu(12)
                Button {
                    id: maxPushResetButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: units.gu(2)
                    color: UbuntuColors.orange

                    action: Action {
                        text: i18n.tr("Reset")
                        onTriggered: {
                            settings.schema.reset("edgeBarrierMaxPush")
                            maxPushSlider.value = settings.edgeBarrierMaxPush
                        }
                    }
                }

                Slider {
                    id: maxPushSlider
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: maxPushResetButton.right
                    anchors.right: parent.right
                    anchors.margins: units.gu(2)

                    minimumValue: 1
                    maximumValue: 100

                    Component.onCompleted: {
                        value = settings.edgeBarrierMaxPush
                    }
                    onValueChanged: {
                        settings.edgeBarrierMaxPush = value.toFixed(0)
                    }
                }
            }

            ListItems.SectionDivider { text: i18n.tr("Edge drag areas width") }

            ListItem {
                height: Math.max(implicitHeight, dragWidthlayout.height)

                ListItemLayout {
                    id: dragWidthlayout
                    anchors.centerIn: parent
                    title.text: i18n.tr("Current value: %1").arg(dragWidthSlider.value.toFixed(0))
                    subtitle.text: i18n.tr("The width of the edge drag areas")
                    summary.text: i18n.tr("How big (in grid units) the edge-drag sensitive area should be.")
                }
            }

            ListItem {
                height: units.gu(12)
                Button {
                    id: dragWidthResetButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: units.gu(2)
                    color: UbuntuColors.orange

                    action: Action {
                        text: i18n.tr("Reset")
                        onTriggered: {
                            settings.schema.reset("edgeDragWidth")
                            dragWidthSlider.value = settings.edgeDragWidth
                        }
                    }
                }

                Slider {
                    id: dragWidthSlider
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: dragWidthResetButton.right
                    anchors.right: parent.right
                    anchors.margins: units.gu(2)

                    minimumValue: 1
                    maximumValue: 6

                    Component.onCompleted: {
                        value = settings.edgeDragWidth
                    }
                    onValueChanged: {
                        settings.edgeDragWidth = value.toFixed(0)
                    }
                }
            }
        }
    }
    
    GSettings {
        id: settings
        schema.id: "com.canonical.Unity8"
    }
}
