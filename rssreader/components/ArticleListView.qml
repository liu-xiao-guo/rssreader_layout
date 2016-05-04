import QtQuick 2.4
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 1.3

Item {
    id: root
    signal clicked(var instance)
    signal updated()
    property alias currentIndex : listView.currentIndex
    property alias model: listView.model
    property alias listview: listView

    function reload() {
        console.log('reloading')
        model.clear();
        picoRssModel.reload()
    }

    ListModel {
        id: model
    }

    XmlListModel {
        id: picoRssModel
        source: "http://www.8kmm.com/rss/rss.aspx"
        query: "/rss/channel/item"

        onStatusChanged: {
            if (status === XmlListModel.Ready) {
                for (var i = 0; i < count; i++) {
                    // Let's extract the image
                    var m,
                            urls = [],
                            str = get(i).content,
                            rex = /<img[^>]+src\s*=\s*['"]([^'"]+)['"][^>]*>/g;

                    while ( m = rex.exec( str ) ) {
                        urls.push( m[1] );
                    }

                    var image = urls[0];

                    var title = get(i).title.toLowerCase();
                    var published = get(i).published.toLowerCase();
                    var content = get(i).content.toLowerCase();

                    model.append({"title": get(i).title,
                                     "published": get(i).published,
                                     "content": get(i).content,
                                     "image": image
                                 })
                }

                listView.currentIndex = 0
                updated()
            }
        }

        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "published"; query: "pubDate/string()" }
        XmlRole { name: "content"; query: "description/string()" }
    }

    UbuntuListView {
        id: listView
        anchors.fill: parent
        clip: true
        visible: true

        model: model

        delegate: ListDelegate {}

        // Define a highlight with customized movement between items.
        Component {
            id: highlightBar
            Rectangle {
                width: 200; height: 50
                color: "#FFFF88"
                y: listView.currentItem.y;
                Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
            }
        }

        highlightFollowsCurrentItem: true

        focus: true
        // highlight: highlightBar

        Scrollbar {
            flickableItem: listView
        }

        PullToRefresh {
            onRefresh: {
                reload()
            }
        }
    }
}
