import QtQuick 2.4
import QtQuick.Window 2.2


Window {
    visible: true
    width: 640
    height: 900
    flags: Qt.WindowTitleHint | Qt.WindowMaximizeButtonHint | (Qt.platform.os === "ios" ? Qt.MaximizeUsingFullscreenGeometryHint : 0)

    Timer {
        onTriggered: body.showPage(body.pages[0], 0)
        interval: 100
        running: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#ddd"

        PageManager {
            id: body
            anchors.fill: parent
//            initialComponents: [ pages[0] ]

            property var pages: ["ListPage", "MapPage", "clocks"]
        }

        Rectangle {
            id: toolBar
            height: 44
            color: "#cceeeeee"
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            SegmentedButton {
                buttons: ["List", "Map", "Clocks"]
                anchors.centerIn: parent
                width: 300
                onActiveButtonChanged: body.showPage(body.pages[activeButton], activeButton)
            }
        }
    }

}
