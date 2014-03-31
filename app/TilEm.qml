import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Qt.labs.folderlistmodel 1.0
import Utils 1.0

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.labsin.TilEm"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: 400
    height: 900
    Tabs {
        id: tabs
        Tab {
            title: "TilEm"
            page: Page {
                ListView {
                    anchors.fill: parent
                    model: folderModel
                    delegate: ListItem.Standard {
                        text: fileName
                        onClicked: {
                            if(fileIsDir) {
                                folderModel.folder = folderModel.folder + "/" + fileName
                            }
                            else {
                                calcPage.romFile = filePath
                                tabs.selectedTabIndex = 1
                            }
                        }
                    }
                }
                FolderListModel {
                    id: folderModel
                    showDirs: true
                    showDirsFirst: true
                    showDotAndDotDot: true
                    nameFilters: [ "*.rom", "*.ROM" ]
                }
            }
        }
        Tab {
            title: "Calc"
            page: CalcPage {
                id: calcPage
            }
        }
    }
    Component.onCompleted: {
        var homeDir = Env.readXdg("HOME")
        print("home: " + homeDir)
        if(homeDir && homeDir !== "") {
            folderModel.folder = homeDir
            return
        }
        var appData = Env.readEnvVar("XDG_DATA_HOME")
        var appPkgName = Env.readEnvVar("APP_ID").split('_')[0]
        var appPkgData = appData + "/" + appPkgName
        print("appPkgData: " + appPkgData)
        if(appPkgData) {
            Env.mkdir(appPkgData)
            folderModel.folder = appPkgData
        }
    }
}
