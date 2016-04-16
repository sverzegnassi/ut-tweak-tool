import QtQuick 2.4
import Ubuntu.Components 1.3
import TweakTool 1.0
import QtQuick.Layouts 1.1
import Ubuntu.Components.Popups 1.3

import "../components/ListItems" as ListItems

Flickable {
    id: overviewTab
    anchors.fill: parent
    interactive: true

    property var pkg

    contentWidth: parent.width
    contentHeight: column.height

    ViewItems.expansionFlags: ViewItems.CollapseOnOutsidePress

    Column {
        id: column
        anchors {
            left: parent.left
            right: parent.right
            //margins: units.gu(2)
        }

        Repeater {
            model: pkg.hooksCount

            ListItem {
                id: hookItem

                property var hook: pkg.getHook(model.index)

                Column {
                    id: hookItemLayout
                    anchors { left: parent.left; right: parent.right }

                    ListItems.SectionDivider {
                        id: hookItemHeader
                        text: hookItem.hook.name
                        iconName: {
                            if (hookItem.hook.type == "Unknown")
                                return ""

                            if (hookItem.hook.type == "App")
                                return "stock_application"

                            if (hookItem.hook.type == "Scope")
                                return "search"

                            if (hookItem.hook.type == "OnlineAccount")
                                return "account"

                            if (hookItem.hook.type == "PushHelper")
                                return "notification"
                        }

                        Icon {
                            width: units.gu(2); height: width
                            anchors {
                                right: parent.right; rightMargin: units.gu(2)
                                bottom: parent.bottom
                                verticalCenter: parent.verticalCenter
                            }

                            name: "go-down"
                            visible: !hookItem.expansion.expanded
                        }
                    }

                    ListItem {
                        divider.visible: false

                        ListItemLayout {
                            title.text: i18n.tr("Template: %1").arg(hookItem.hook.apparmor.template || i18n.tr("confined hook"))
                            subtitle.text: i18n.tr("Policy version: %1").arg(hookItem.hook.apparmor.policy_version)
                        }
                    }

                    Repeater {
                        id: hooksRepeater
                        model: hookItem.hook.apparmor.policy_groups

                        ListItem {
                            height: groupLayout.height - units.gu(2)
                            divider.visible: false

                            ListItemLayout {
                                id: groupLayout

                                title.wrapMode: Text.WordWrap
                                title.elide: Text.ElideRight
                                title.maximumLineCount: 20
                                title.text: {
                                    if (modelData == "accounts")
                                        return i18n.tr("Can use Online Accounts")

                                    if (modelData == "audio")
                                        return i18n.tr("Can play audio")

                                    if (modelData == "calendar")
                                        return i18n.tr("Can access the calendar (reserved)")

                                    if (modelData == "camera")
                                        return i18n.tr("Can access the camera")

                                    if (modelData == "connectivity")
                                        return i18n.tr("Can access network connectivity informations")

                                    if (modelData == "contacts")
                                        return i18n.tr("Can access contacts")

                                    if (modelData == "content_exchange")
                                        return i18n.tr("Can request/import data from other applications")

                                    if (modelData == "content_exchange_source")
                                        return i18n.tr("Can provide/export data to other applications")

                                    if (modelData == "debug")
                                        return i18n.tr("Use special debugging tools (reserved)")

                                    if (modelData == "history")
                                        return i18n.tr("Can access the history-service (reserved)")

                                    if (modelData == "in-app-purchased")
                                        return i18n.tr("Can access pay service")

                                    if (modelData == "keep-display-on")
                                        return i18n.tr("Can request keeping the screen on")

                                    if (modelData == "location")
                                        return i18n.tr("Can determ the current position.")

                                    if (modelData == "microphone")
                                        return i18n.tr("Can access the microphone")

                                    if (modelData == "music_files")
                                        return i18n.tr("Can access (read/write) to the user's music folders (reserved)")

                                    if (modelData == "music_files_read")
                                        return i18n.tr("Can read files from the user's music folders (reserved)")

                                    if (modelData == "networking")
                                        return i18n.tr("Can access the network")

                                    if (modelData == "picture_files")
                                        return i18n.tr("Can access (read/write) to the user's pictures folders (reserved)")

                                    if (modelData == "picture_files_read")
                                        return i18n.tr("Can read files from the user's pictures folders (reserved)")

                                    if (modelData == "push-notification-client")
                                        return i18n.tr("Can use push notifications")

                                    if (modelData == "sensors")
                                        return i18n.tr("Can access the device sensors")

                                    if (modelData == "usermetrics")
                                        return i18n.tr("Can show informations on the lock screen")

                                    if (modelData == "video")
                                        return i18n.tr("Can play video")

                                    if (modelData == "video_files")
                                        return i18n.tr("Can access (read/write) to the user's video folders (reserved)")

                                    if (modelData == "video_files_read")
                                        return i18n.tr("Can read files from the user's video folders (reserved)")

                                    if (modelData == "webview")
                                        return i18n.tr("Can use the Ubuntu webview")
                                }

                                Icon {
                                    SlotsLayout.position: SlotsLayout.Leading
                                    height: units.gu(4); width: height
                                    color: UbuntuColors.blue

                                    name: {
                                        if (modelData == "accounts")
                                            return "account"

                                        if (modelData == "audio")
                                            return "audio-volume-high"

                                        if (modelData == "calendar")
                                            return "calendar"

                                        if (modelData == "camera")
                                            return "camcorder"

                                        if (modelData == "connectivity")
                                            return "gsm-3g-medium"

                                        if (modelData == "contacts")
                                            return "contact-group"

                                        if (modelData == "content_exchange")
                                            return "insert-image"

                                        if (modelData == "content_exchange_source")
                                            return "share"

                                        if (modelData == "debug")
                                            return "settings"

                                        if (modelData == "history")
                                            return "history"

                                        // FIXME
                                        if (modelData == "in-app-purchased")
                                            return ""

                                        if (modelData == "keep-display-on")
                                            return "display-brightness-symbolic"

                                        if (modelData == "location")
                                            return "location"

                                        if (modelData == "microphone")
                                            return "audio-input-microphone-symbolic"

                                        if (modelData == "music_files")
                                            return "stock_music"

                                        if (modelData == "music_files_read")
                                            return "stock_music"

                                        if (modelData == "networking")
                                            return "nm-adhoc"

                                        if (modelData == "picture_files")
                                            return "stock_image"

                                        if (modelData == "picture_files_read")
                                            return "stock_image"

                                        if (modelData == "push-notification-client")
                                            return "notification"

                                        // FIXME
                                        if (modelData == "sensors")
                                            return ""

                                        if (modelData == "usermetrics")
                                            return "info"

                                        if (modelData == "video")
                                            return "media-playback-start"

                                        if (modelData == "video_files")
                                            return "stock_video"

                                        if (modelData == "video_files_read")
                                            return "stock_video"

                                        if (modelData == "webview")
                                            return "stock_website"
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        visible: hooksRepeater.count > 0 && !readPathsItem.visible && !writePathsItem.visible
                        width: parent.width
                        height: units.gu(2)
                        /* spacer */
                    }

                    ListItem {
                        id: readPathsItem
                        divider.visible: false
                        height: visible ? readPathLayout.height : 0

                        visible: readPathLayout.subtitle.text != ""

                        ListItemLayout {
                            id: readPathLayout
                            title.text: i18n.tr("Can read the following additional paths:")
                            subtitle.text: {
                                var str = hookItem.hook.apparmor.read_path

                                if (!str)
                                    return ""

                                return hookItem.hook.apparmor.read_path.toString()
                            }
                            subtitle.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            subtitle.elide: Text.ElideRight
                            subtitle.maximumLineCount: 20
                        }
                    }

                    ListItem {
                        id: writePathsItem
                        divider.visible: false
                        height: visible ? writePathLayout.height : 0

                        visible: writePathLayout.subtitle.text != ""
                        ListItemLayout {
                            id: writePathLayout
                            title.text: i18n.tr("Can write to the following additional paths:")
                            subtitle.text: {
                                var str = hookItem.hook.apparmor.write_path

                                if (!str)
                                    return ""

                                return hookItem.hook.apparmor.read_path.toString()
                            }
                            subtitle.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            subtitle.elide: Text.ElideRight
                            subtitle.maximumLineCount: 20
                        }
                    }
                }

                height: hookItemHeader.height
                expansion.expanded: model.index == 0    // At start-up, first item is already expanded
                expansion.height: hookItemLayout.height
                onClicked: expansion.expanded = true
            }
        }
    }
}

