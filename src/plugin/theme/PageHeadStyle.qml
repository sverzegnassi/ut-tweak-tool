import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes.Ambiance 1.3 as Ambiance

Ambiance.PageHeadStyle {
    buttonColor: "white"
    titleColor: "white"

    Rectangle {
        //anchors.fill: parent
        width: parent.width
        height: units.gu(6)

        color: UbuntuColors.orange
        z: -100
    }
}
