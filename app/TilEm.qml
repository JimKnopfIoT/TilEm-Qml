import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Qt.labs.folderlistmodel 1.0
import U1db 1.0 as U1db
import Ubuntu.Components.Popups 0.1
import Utils 1.0

MainView {
    property bool init: false
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.labsin.tilem"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Arguments during startup
    Arguments {
        id: args
        //defaultArgument.help: "Expects URI of the track to play." // should be used when bug is resolved
        //defaultArgument.valueNames: ["URI"] // should be used when bug is resolved
        // grab a file
        Argument {
            name: "file"
            help: "URI for rom to use"
            required: false
            valueNames: ["rom"]
        }
    }

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
                    property string rootFolder: "/"
                    property bool empty: showDotAndDotDot2?folderModel.count <= 2:folderModel.count == 0
                    property bool showDotAndDotDot2: false
                    property bool inRoot: folder == rootFolder
                    showDirs: true
                    showDirsFirst: true
                    showDotAndDotDot: showDotAndDotDot2
                    onFolderChanged: {
// Doesn't work
//                        if(inRoot) {
//                            showDotAndDotDot = false
//                        }
//                        else {
//                            showDotAndDotDot = true
//                        }
//                        print("showDotAndDotDot: "+showDotAndDotDot)
                    }
                    function setRootFolder(nextRootFolder) {
                        folder = nextRootFolder;
                        rootFolder = folder;
                        folderChanged();
                    }
                    showOnlyReadable: true
                    nameFilters: [ "*.rom", "*.ROM" ]
                    onInRootChanged: {
                        if(inRoot && init && empty) {
                            var dialog = PopupUtils.open(noRomDialog)
                            dialog.noRomFiles = true
                        }
                    }
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
        var folder
        var homeDir = Env.readXdg("HOME")
        print("home: " + homeDir)
        if(homeDir && homeDir !== "") {
            folderModel.showDotAndDotDot2 = true
            folder = homeDir
        }
        var appData = Env.readEnvVar("XDG_DATA_HOME")
        var appPkgName = Env.readEnvVar("APP_ID").split('_')[0]
        var appPkgData = appData + "/" + appPkgName
        print("appPkgData: " + appPkgData)
        if(appPkgData && !folder) {
            Env.mkdir(appPkgData)
            folderModel.showDotAndDotDot2 = false
            folderModel.showDirs = false
            folder = appPkgData
        }

        if (args.values.file) {
            var argFile = args.values.file
            if (argFile.indexOf("file://") != -1) {
                argFile = argFile.substring(7);
                debug(argFile);
            }
        }

        folderModel.setRootFolder(folder)

        var firstTime = firstTimeQuery.results[0]["firstTime"]
        print("first time: " + firstTime)
        if(firstTime) {
            var dialog = PopupUtils.open(noRomDialog)
            dialog.noRomFiles = Qt.binding(function(){return folderModel.empty})
            dialog.returnFunction = function() {var contents = settings.contents; contents["firstTime"] = false; settings.contents = contents; print("contents: "+JSON.stringify(settings.contents))}
        }
        init = true;
    }

    Component {
             id: noRomDialog
             DefaultSheet {
                 property bool noRomFiles: true
                 property var returnFunction
                 id: sheet
                 title: noRomFiles?"No ROM files found!":"Rom Files"
                 doneButton: false
                 Label {
                     anchors.fill: parent
                     textFormat: Text.StyledText
                     text: "This emulator comes with no rom file. You need to supply this file from you own calculator.<br>
                            You can find how to extract this rom <a href=\"http://www.ticalc.org/programming/emulators/romdump.html\">here</a>.<br>
                            After this, you can push this rom to the apps private folder with 'adb push FILE.rom /home/phablet/.local/share/com.ubuntu.developer.labsin.tilem<br>'
                            Then you need to change the permission of this file with 'adb shell chown phablet /home/phablet/.local/share/com.ubuntu.developer.labsin.tilem/FILE.rom'"
                     wrapMode: Text.WordWrap
                 }
                 onCloseClicked: {
                    if(noRomFiles) {
                        Qt.quit()
                    } else {
                        PopupUtils.close(sheet)
                    }
                    if(returnFunction) {
                        returnFunction()
                    }
                }
            }
        }

    U1db.Database {
        id: db
        path: "tilem"
    }

    U1db.Document {
        id: settings
        database: db
        docId: 'settings'
        create: true
        defaults:{"firstTime": true }
    }

    U1db.Index {
        database: db
        id: firstTimeIndex
        expression: "firstTime"
    }

    U1db.Query {
        id: firstTimeQuery
        index: firstTimeIndex
    }
}
