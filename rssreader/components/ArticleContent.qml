import QtQuick 2.0
import Ubuntu.Components 1.3

Item {
    property alias text: content.text
    property alias image : img.source

    Image {
        id: img
        anchors.centerIn: parent
        width: parent.width*.7
        height: parent.height*.7
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: content
        anchors.centerIn: parent
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        visible: false
    }

    Component.onDestruction: {
        console.log("Article content is destructed!")
    }
}
