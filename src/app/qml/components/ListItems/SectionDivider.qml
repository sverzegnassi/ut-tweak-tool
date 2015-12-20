import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems

Rectangle {
    property alias text: sectionLabel.text
    property alias showDivider: divider.visible
    property alias iconName: icon.name

    anchors {
        left: parent.left
        right: parent.right
    }

    height: sectionLabel.height + units.gu(2)
    color: Theme.palette.normal.background

    Row {
        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            right: parent.right
            rightMargin: units.gu(2)
            bottom: divider.top
        }
        height: units.gu(4)
        spacing: units.gu(1)

        Icon {
            id: icon
            height: units.gu(2)
            width: name ? units.gu(2) : 0
            anchors.verticalCenter: parent.verticalCenter
            color: UbuntuColors.orange
        }

        Label {
            id: sectionLabel
            height: parent.height
            fontSize: "medium"
            //font.weight: Font.DemiBold
            verticalAlignment: Text.AlignVCenter
            color: UbuntuColors.orange
        }
    }

    ListItems.ThinDivider {
        id: divider
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
