import QtQuick 2.4
import QtGraphicalEffects 1.0


Item {
    anchors.fill: parent
    id: pageLoader

    property var toolBar
    property var navigationBar
    property var components: []
    property var initialComponents: []

    property int speed: 3
    property string currentPage
    property var currentView
    property var previousView
    property int previousIndex: -1
    property bool inFromRight: true

    Component.onCompleted: {
        for(var i=pageLoader.initialComponents.length-1; i>=0; i--) {
            loadPage(pageLoader.initialComponents[i]);
        }
        if(pageLoader.initialComponents.length)
            showPage(pageLoader.initialComponents[0], 0)
    }

    function showPage(pageName, pageIndex) {
        console.log("Load page:", pageName, pageIndex)
        if(currentPage === pageName)
            return;
        if(!components[pageName]) {
            loadPage(pageName)
        }
        showView(pageName, pageIndex)
    }

    function loadPage(pageName) {
        console.log("Loading component " + pageName)
        var component = Qt.createComponent(pageName + ".qml")
        if (component.status === Component.Ready) {
            components[pageName] = component.createObject(pageLoader, {
                                                              width: parent.width,
                                                              height: parent.height,
                                                              visible: false
//                                                              opacity: 0,
//                                                              "anchors.fill": pageLoader
                                                          })
            console.log(components[pageName])
            try {
                components[pageName].navigationBar = pageLoader.navigationBar
                components[pageName].toolBar = pageLoader.toolBar
                components[pageName].viewDidLoad()
            } catch(e) { }
        } else console.log("Component not ready: " + component.errorString())
    }

    function showView(pageName, pageIndex) {
        currentPage = pageName
        previousView = currentView
        currentView = components[pageName]
        if(previousView) {
            currentView.width = pageLoader.width
            currentView.height = pageLoader.height
            previousView.z = 1
            currentView.z = 2
            currentView.x = pageLoader.width
            inFromRight = previousIndex < pageIndex
            if(!inFromRight) {
                currentView.x = -currentView.width
            }

            try {
                previousView.viewWillDisappear()
            } catch(e) { }
            fadeOut1.target = previousView
            fadeOut2.target = previousView
            fadeOut3.target = previousView
            fadeOut.running = true
            try {
                currentView.viewWillAppear()
            } catch(e) { }
            currentView.visible = true
            fadeIn1.target = currentView
            fadeIn2.target = currentView
            fadeIn3.target = currentView
            fadeIn.running = true
        } else {
            currentView.x = 0
            currentView.visible = true
        }
        previousIndex = pageIndex
        _appMgr.lightContent = currentView.lightContent
    }

    SequentialAnimation {
        id: fadeOut
        PropertyAnimation {
            id: fadeOut1
            from: 1
            to: .8
            duration: 100 * pageLoader.speed
            property: "scale"
//            target: pageLoader.previousView
            easing.type: Easing.InQuad
        }
        PropertyAnimation {
            id: fadeOut2
            from: 0
            to: inFromRight ? -pageLoader.width : pageLoader.width
            duration: 200 * pageLoader.speed
            property: "x"
//            target: pageLoader.previousView
        }
        PropertyAnimation {
            id: fadeOut3
            from: .8
            to: 1
            duration: 100 * pageLoader.speed
            property: "scale"
//            target: pageLoader.previousView
            easing.type: Easing.OutQuad
            onStopped: {
                try { pageLoader.previousView.viewDidDisappear() } catch(e) { }
                pageLoader.previousView.visible = false
            }
        }
    }

    SequentialAnimation {
        id: fadeIn
        PropertyAnimation {
            id: fadeIn1
            from: 1
            to: .8
            duration: 100 * pageLoader.speed
            property: "scale"
            easing.type: Easing.InQuad
        }
        PropertyAnimation {
            id: fadeIn2
            from: inFromRight ? pageLoader.width : -pageLoader.width
            to: 0
            duration: 200 * pageLoader.speed
            property: "x"
        }
        PropertyAnimation {
            id: fadeIn3
            from: .8
            to: 1
            duration: 100 * pageLoader.speed
            property: "scale"
            easing.type: Easing.OutQuad
            onStopped: {
                try { pageLoader.currentView.viewDidAppear() } catch(e) { }
                pageLoader.previousView.visible = false
            }
        }
    }

    onWidthChanged: if(currentView) currentView.width = width
    onHeightChanged: if(currentView) currentView.height = height
}
