import QtQuick 2.4
import Ubuntu.Components 1.3
import "components"

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "rssreader.liu-xiao-guo"

    width: units.gu(60)
    height: units.gu(85)

    AdaptivePageLayout {
        id: layout
        anchors.fill: parent
        primaryPage: listPage

        layouts: PageColumnsLayout {
            when: width > units.gu(80)
            // column #0
            PageColumn {
                minimumWidth: units.gu(30)
                maximumWidth: units.gu(60)
                preferredWidth: units.gu(40)
            }
            // column #1
            PageColumn {
                fillWidth: true
            }
        }

        Page {
            id: listPage
            visible: false
            header: PageHeader {
                title: "POCO 摄影"
                trailingActionBar.actions: [
                    Action {
                        iconName: "reload"
                        text: "Reload"
                        onTriggered: articleList.reload()
                    }
                ]

                // flickable: articleList.listview
            }

            ArticleListView {
                id: articleList
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    top: listPage.header.bottom
                }
                clip: true

                onClicked: {
                    articleContent.text = instance.content
                    articleContent.image = instance.image
                    layout.addPageToNextColumn(listPage, contentPage)
                }
            }
        }

        Page {
            id: contentPage
            header: PageHeader {
                title: "Content"
            }

            visible: false

            ArticleContent {
                id: articleContent
                objectName: "articleContent"
                anchors.fill: parent
            }
        }

        onColumnsChanged: {
            console.log("columns: " + columns );

            if ( columns == 2 ) {
                console.log("currentIndex: " + articleList.currentIndex )
                if ( articleList.currentIndex != undefined &&
                        articleList.currentIndex >= 0 ) {
                    var model = articleList.model
                    var index = articleList.currentIndex

                    //                    console.log("count: " + model.count)
                    //                    console.log("content: " +  model.get(index).content)
                    articleContent.text = model.get(index).content
                    layout.addPageToNextColumn(listPage, contentPage)
                }

            }
        }
    }

    Action {
        id: reloadAction
        text: "Reload"
        iconName: "reload"
        onTriggered: articleList.reload()
    }
}

