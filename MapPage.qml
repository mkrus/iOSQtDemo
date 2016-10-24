import QtQuick 2.4
import QtQuick.Window 2.2
import QtPositioning 5.3
import QtLocation 5.3

BasePage {
    lightContent: false

    PositionSource {
        id: positionSource
    }
    Plugin {
        id: mapPlugin
        name: "osm"
        PluginParameter { name:"mapbox.access_token"; value:"pk.eyJ1IjoibXdrcnVzIiwiYSI6ImNpZmF5dWJnMzAwNWN0Y2x4OGNxaTZ6ejMifQ.ZZLkh-xvoHK7cGwAb0fNfw" }
        PluginParameter { name:"mapbox.map_id"; value:"mwkrus.njpl1d1a" }
    }

    Map {
        id: map
        property int lastX : -1
        property int lastY : -1
        property int pressX : -1
        property int pressY : -1

        plugin: mapPlugin
        anchors.fill: parent
        anchors.bottomMargin: .5
        gesture.enabled: true
//        gesture.pinchEnabled: true

        property MapCircle circle

        Component.onCompleted: {
            circle = Qt.createQmlObject('import QtLocation 5.3; MapCircle {}', body)
            circle.center = positionSource.position.coordinate
            circle.radius = 5000.0
            circle.color = 'green'
            circle.border.width = 3
            map.addMapItem(circle)
            map.fitViewportToMapItems()
        }

        MouseArea {
            id: mouseArea
            property variant lastCoordinate
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onPressed : {
                map.lastX = mouse.x
                map.lastY = mouse.y
                map.pressX = mouse.x
                map.pressY = mouse.y
                lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
            }

            onPositionChanged: {
                if (mouse.button == Qt.LeftButton) {
                    map.lastX = mouse.x
                    map.lastY = mouse.y
                }
            }

            onDoubleClicked: {
                map.center = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                if (mouse.button === Qt.LeftButton) {
                    map.zoomLevel++
                } else if (mouse.button === Qt.RightButton) {
                    map.zoomLevel--
                }
                map.lastX = -1
                map.lastY = -1
            }

            onPressAndHold:{
                if (Math.abs(map.pressX - mouse.x ) < map.jitterThreshold
                        && Math.abs(map.pressY - mouse.y ) < map.jitterThreshold) {
                    showMainMenu(lastCoordinate);
                }
            }
        }
    }
}
