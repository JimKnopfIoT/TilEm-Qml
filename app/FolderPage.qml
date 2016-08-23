import QtQuick 2.4
import Ubuntu.Components 1.3
import Qt.labs.folderlistmodel 1.0
import Ubuntu.Components.ListItems 1.3 as ListItem

Page {
    signal request
    signal loadRomFile(string romFile)

    header: PageHeader {
        title: i18n.tr("ROM's")
        trailingActionBar.actions: [
            Action {
                iconName: "add"
                text: i18n.tr("Open")
                onTriggered: request()
            }
        ]
        flickable: list
    }

    ListView {
        id: list
        anchors.fill: parent
        delegate: Component {
            ListItem.Standard {
                text: fileName
                progression: true
                onClicked: {
                    loadRomFile(filePath)
                }
            }
        }
        model: FolderListModel {
            folder: appDir + "/Documents"
            showDirs: false
            sortField: FolderListModel.Name
            nameFilters: [ "*.rom", "*.ROM" ]
        }
    }
}
