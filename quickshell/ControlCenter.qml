import "./config"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PopupWindow {
    id: window

    property alias focusGrab: grab.active

    visible: false
    color: "transparent"
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight
    Component.onCompleted: Context.controlCenter = window
    onVisibleChanged: {
        if (!visible && !Context.statusBar.beingHovered && !Context.shutdownMenu.visible)
            Context.statusBar.visible = Context.statusBar.shouldBeVisible;

    }

    HyprlandFocusGrab {
        id: grab

        windows: [window]
        active: true
        onActiveChanged: {
            if (!active)
                window.visible = false;

        }
    }

    Rectangle {
        id: content

        anchors.centerIn: parent
        implicitWidth: layout.implicitWidth + 30
        implicitHeight: layout.implicitHeight + 30
        radius: 10
        color: Theme.background

        ColumnLayout {
            id: layout

            anchors.centerIn: parent
            spacing: 12

            WorkspaceWidget {
                implicitWidth: parent.width
            }

            RowLayout {
                spacing: parent.spacing

                NetworkWidget {
                    id: networkWidget

                    widgetFocus: true
                    Layout.alignment: Qt.AlignTop
                    Keys.onPressed: (event) => {
                        switch (event.key) {
                        case Navigation.right:
                            audioWidget.widgetFocus = true;
                            break;
                        case Navigation.down:
                            bluetoothWidget.widgetFocus = true;
                            break;
                        case Navigation.parent:
                            if (networkWidget.moreActive) {
                                networkWidget.onMore();
                                break;
                            }
                            window.focusGrab = false;
                            window.visible = false;
                            break;
                        default:
                            return ;
                        }
                        event.accepted = true;
                    }

                    Connections {
                        function onVisibleChanged() {
                            if (!window.visible) {
                                if (networkWidget.more.focus)
                                    networkWidget.widgetFocus = true;

                                networkWidget.more.visible = false;
                            }
                        }

                        target: window
                    }

                }

                AudioWidget {
                    id: audioWidget

                    Layout.alignment: Qt.AlignTop
                    Keys.onPressed: (event) => {
                        switch (event.key) {
                        case Navigation.left:
                            networkWidget.widgetFocus = true;
                            break;
                        case Navigation.down:
                            notifiactionDisabledWidget.widgetFocus = true;
                            break;
                        case Navigation.parent:
                            if (audioWidget.moreActive) {
                                audioWidget.onMore();
                                break;
                            }
                            window.focusGrab = false;
                            window.visible = false;
                            break;
                        default:
                            return ;
                        }
                        event.accepted = true;
                    }

                    Connections {
                        function onVisibleChanged() {
                            if (!window.visible) {
                                if (audioWidget.more.focus)
                                    audioWidget.widgetFocus = true;

                                audioWidget.more.visible = false;
                            }
                        }

                        target: window
                    }

                }

            }

            RowLayout {
                spacing: parent.spacing

                BluetoothWidget {
                    id: bluetoothWidget

                    Layout.alignment: Qt.AlignTop
                    Keys.onPressed: (event) => {
                        switch (event.key) {
                        case Navigation.up:
                            networkWidget.widgetFocus = true;
                            if (networkWidget.moreActive)
                                networkWidget.more.focus = true;

                            break;
                        case Navigation.down:
                            displayWidget.widgetFocus = true;
                            break;
                        case Navigation.right:
                            notifiactionDisabledWidget.widgetFocus = true;
                            break;
                        case Navigation.parent:
                            if (bluetoothWidget.moreActive) {
                                bluetoothWidget.onMore();
                                break;
                            }
                            window.focusGrab = false;
                            window.visible = false;
                            break;
                        default:
                            return ;
                        }
                        event.accepted = true;
                    }

                    Connections {
                        function onVisibleChanged() {
                            if (!window.visible) {
                                if (bluetoothWidget.more.focus)
                                    bluetoothWidget.widgetFocus = true;

                                bluetoothWidget.more.visible = false;
                            }
                        }

                        target: window
                    }

                }

                NotificationDisabledWidget {
                    id: notifiactionDisabledWidget

                    Layout.alignment: Qt.AlignTop
                    Keys.onPressed: (event) => {
                        switch (event.key) {
                        case Navigation.left:
                            bluetoothWidget.widgetFocus = true;
                            break;
                        case Navigation.down:
                            shutdownWidget.focus = true;
                            break;
                        case Navigation.up:
                            audioWidget.widgetFocus = true;
                            if (audioWidget.moreActive)
                                audioWidget.more.focus = true;

                            break;
                        case Navigation.parent:
                            window.focusGrab = false;
                            window.visible = false;
                            break;
                        default:
                            return ;
                        }
                        event.accepted = true;
                    }
                }

            }

            RowLayout {
                spacing: parent.spacing
                Layout.alignment: Qt.AlignLeft

                DisplayWidget {
                    id: displayWidget

                    Layout.alignment: Qt.AlignTop
                    onMore: function() {
                        dispPosWidget.visible = !dispPosWidget.visible;
                    }
                    Keys.onPressed: (event) => {
                        switch (event.key) {
                        case Navigation.up:
                            bluetoothWidget.widgetFocus = true;
                            if (bluetoothWidget.moreActive)
                                bluetoothWidget.more.focus = true;

                            break;
                        case Navigation.down:
                            volumeSlider.sliderFocus = true;
                            break;
                        case Navigation.right:
                            searchWidget.focus = true;
                            break;
                        case Navigation.child:
                            dispPosWidget.visible = true;
                            break;
                        case Navigation.parent:
                            if (dispPosWidget.moreActive) {
                                dispPosWidget.onMore();
                                break;
                            }
                            if (!dispPosWidget.visible) {
                                window.focusGrab = false;
                                window.visible = false;
                            }
                            dispPosWidget.visible = false;
                            break;
                        default:
                            return ;
                        }
                        event.accepted = true;
                    }

                    Connections {
                        function onVisibleChanged() {
                            if (!window.visible) {
                                if (displayWidget.more.focus)
                                    displayWidget.widgetFocus = true;

                                dispPosWidget.visible = false;
                            }
                        }

                        target: window
                    }

                }

                SearchWidget {
                    id: searchWidget

                    Layout.alignment: Qt.AlignVCenter
                    Keys.onPressed: (event) => {
                        switch (event.key) {
                        case Navigation.up:
                            notifiactionDisabledWidget.widgetFocus = true;
                            break;
                        case Navigation.down:
                            volumeSlider.sliderFocus = true;
                            break;
                        case Navigation.left:
                            displayWidget.widgetFocus = true;
                            break;
                        case Navigation.right:
                            shutdownWidget.focus = true;
                            break;
                        case Navigation.parent:
                            window.focusGrab = false;
                            window.visible = false;
                            break;
                        default:
                            return ;
                        }
                        event.accepted = true;
                    }
                }

                ShutdownWidget {
                    id: shutdownWidget

                    Layout.alignment: Qt.AlignVCenter
                    Keys.onPressed: (event) => {
                        switch (event.key) {
                        case Navigation.up:
                            notifiactionDisabledWidget.widgetFocus = true;
                            break;
                        case Navigation.down:
                            volumeSlider.sliderFocus = true;
                            break;
                        case Navigation.left:
                            searchWidget.focus = true;
                            break;
                        case Navigation.parent:
                            window.focusGrab = false;
                            window.visible = false;
                            break;
                        default:
                            return ;
                        }
                        event.accepted = true;
                    }
                }

            }

            DisplayPositionWidget {
                id: dispPosWidget

                visible: false
                onFocusChanged: {
                    if (focus)
                        displayWidget.focus = true;

                }
            }

            VolumeSlider {
                id: volumeSlider

                implicitWidth: parent.width
                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Navigation.up:
                        displayWidget.widgetFocus = true;
                        break;
                    case Navigation.down:
                        brightnessSlider.sliderFocus = true;
                        break;
                    case Navigation.parent:
                        window.focusGrab = false;
                        window.visible = false;
                        break;
                    default:
                        return ;
                    }
                    event.accepted = true;
                }
            }

            BrightnessSlider {
                id: brightnessSlider

                implicitWidth: parent.width
                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Navigation.up:
                        volumeSlider.sliderFocus = true;
                        break;
                    case Navigation.down:
                        if (spotifyWidget.visible)
                            spotifyWidget.focus = true;
                        else if (notificationsWidget.visible)
                            notificationsWidget.notificationList.focus = true;
                        else
                            return ;
                        break;
                    case Navigation.parent:
                        window.focusGrab = false;
                        window.visible = false;
                        break;
                    default:
                        return ;
                    }
                    event.accepted = true;
                }
            }

            SpotifyWidget {
                id: spotifyWidget

                implicitWidth: parent.width
                implicitHeight: 150
                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Navigation.up:
                        brightnessSlider.sliderFocus = true;
                        break;
                    case Navigation.down:
                        if (!notificationsWidget.visible)
                            return ;

                        notificationsWidget.notificationList.focus = true;
                        break;
                    case Navigation.parent:
                        window.focusGrab = false;
                        window.visible = false;
                        break;
                    default:
                        return ;
                    }
                    event.accepted = true;
                }
            }

            Spacer {
            }

            NotificationsWidget {
                id: notificationsWidget

                Keys.onPressed: (event) => {
                    switch (event.key) {
                    case Navigation.parent:
                        if (spotifyWidget.visible) {
                            spotifyWidget.focus = true;
                        } else {
                            window.focusGrab = false;
                            window.visible = false;
                        }
                        break;
                    case Navigation.up:
                        if (spotifyWidget.visible)
                            spotifyWidget.focus = true;
                        else
                            brightnessSlider.sliderFocus = true;
                        break;
                    default:
                        return ;
                    }
                    event.accepted = true;
                }
            }

        }

    }

}
