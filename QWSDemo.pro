TEMPLATE = app

QT += qml quick network location positioning

SOURCES += main.cpp

RESOURCES += qml.qrc clocks.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

OTHER_FILES += *.qml

ios {
    QT += gui-private
    QMAKE_IOS_DEPLOYMENT_TARGET = 8.4
    QMAKE_IOS_TARGETED_DEVICE_FAMILY = 1

#    QMAKE_INFO_PLIST = Info.plist

#    splash.files = "LaunchScreen.storyboard"
#    icons.files = Images.xcassets
#    QMAKE_BUNDLE_DATA += splash icons

    HEADERS += \
        appmanager.h \
        mytextview.h

    OBJECTIVE_SOURCES += \
        mytextview.mm \
        appmanager.mm
}
