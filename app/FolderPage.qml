import QtQuick 2.4
import Ubuntu.Components 1.3
import Qt.labs.folderlistmodel 1.0
import Utils 1.0

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
            ListItem {
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: units.gu(3)
                    textSize: Label.Large
                    text: fileName
                }
                action: Action {
                    onTriggered: {
                        loadRomFile(filePath)
                    }
                }
                trailingActions: ListItemActions {
                    actions: Action {
                        iconName: "delete"
                        onTriggered: {
                            File.removeFile(filePath)
                        }
                    }
                }
                divider.visible: true
            }
        }
        model: FolderListModel {
            folder: appDir + "/Documents"
            showDirs: false
            sortField: FolderListModel.Name
            nameFilters: [ "*.rom", "*.ROM" ]
        }
        clip: true
    }
}
