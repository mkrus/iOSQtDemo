import QtQuick 2.4

Item {
    id: root
    property var buttons
    property var buttonsEnabled
    property int activeButton: 0
    property alias fontFamily: defaultLabel.font.family
    property int fontPixelSize: 18
    property int orientation: Qt.Horizontal

    // Disabling exclusive mode makes the Segmented button behave as a list of independent buttons.
    property bool exclusiveMode: true
    property bool nonExclusiveActive: true

    property var activeButtonColor: "blue"
    property var inactiveButtonColor: "white"
    property int buttonHeight: 36

    height: orientation == ListView.Horizontal ? root.buttonHeight : root.buttonHeight * listModel.count

    signal clicked (int buttonIndex)

    function setLabel(buttonIndex, newLabel)
    {
        listModel.setProperty(buttonIndex, "name", newLabel)
    }

    function setButtonEnabled(buttonIndex, isEnabled)
    {
        listModel.setProperty(buttonIndex, "buttonEnabled", isEnabled)
    }

    ListModel {
        id: listModel
        property bool hasIcons: false
    }
    Text {
        id: defaultLabel
        visible: false
    }

    Component.onCompleted: {
        listModel.hasIcons = false
        for(var i in buttons) {
            var name = buttons[i]
            var icon = ""
            if(name.substring(0, 3) == "qrc") {
                icon = name
                name = ""
                listModel.hasIcons = true
            }

            listModel.append({"name": name, "icon": icon, "buttonEnabled": true})
        }
        for(var i in buttonsEnabled) {
            setButtonEnabled(i, buttonsEnabled[i])
        }

        listView.currentIndex = activeButton
    }
    onActiveButtonChanged: {
        if(listView.currentIndex != activeButton)
            listView.currentIndex = activeButton
    }

    ListView {
        id: listView
        anchors.fill: parent
        orientation: root.orientation == Qt.Horizontal ? ListView.Horizontal : ListView.Vertical
        model: listModel
        interactive: false
        delegate: Rectangle {
            id: oneButton
            property int buttonIndex: index
            property bool active: (exclusiveMode && buttonIndex == listView.currentIndex) || (!exclusiveMode && nonExclusiveActive)
            color: {
                var color = active ? root.activeButtonColor : root.inactiveButtonColor;
                return mouseArea.pressed ? "lightblue" : color
            }
            height: root.orientation == Qt.Horizontal ? parent.height : root.buttonHeight
            width: root.orientation == Qt.Horizontal && listView.model ? root.width / listView.model.count : root.width
            radius: 5

            Item {
                visible: root.orientation == Qt.Horizontal
                anchors.fill: parent
                Rectangle {
                    color: oneButton.color
                    width: oneButton.radius
                    x: 0
                    height: parent.height
                    visible: index > 0
                }
                Rectangle {
                    color: oneButton.color
                    width: oneButton.radius
                    x: parent.width - width
                    height: parent.height
                    visible: index < (listView.count - 1)
                }
                Rectangle {
                    color: "blue"
                    width: 1
                    x: -1
                    height: parent.height
                    visible: index > 0
                }
            }
            Item {
                visible: root.orientation == Qt.Vertical
                anchors.fill: parent
                Rectangle {
                    color: oneButton.color
                    height: oneButton.radius
                    y: 0
                    width: parent.width
                    visible: index > 0
                }
                Rectangle {
                    color: oneButton.color
                    height: oneButton.radius
                    y: parent.height - height
                    width: parent.width
                    visible: index < (listView.count - 1)
                }
                Rectangle {
                    color: "blue"
                    height: 1
                    y: -1
                    width: root.width
                    visible: index > 0
                }
            }

            Text {
                anchors.fill: parent
                text: name
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
                font.family: root.fontFamily
                font.pixelSize: fontPixelSize
                color: active ? "white" : "blue"
                visible: name.length
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                enabled: buttonEnabled

                onClicked: {
                    root.activeButton = listView.currentIndex = index
                    root.forceActiveFocus()
                    root.clicked(index)
                }
            }
        }
    }

    Rectangle {
        color: "transparent"
        anchors.fill: parent

        border.width: 1
        border.color: root.activeButtonColor
        radius: 5
    }

}
