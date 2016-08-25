import QtQuick 2.4
import Ubuntu.Components 1.3
import TilEm 1.0
import Utils 1.0

Page {
    property string romFile: ""

    onRomFileChanged: {
        print("set romFile " + romFile)
        if(romFile == "")
            return;
        calcObj.load(romFile)
    }

    header: PageHeader {
        title: i18n.tr("Calc")
    }

    Calc {
        id: calcObj

        onModelNameChanged: {
            print("modelName: "+modelName)
            var skinFile = Qt.resolvedUrl("skins/"+modelName+".skn")
            print("skinFile: "+skinFile)
            if(File.fileExists(skinFile)) {
                print("Skin exists")
                skinId.skinFile = skinFile
            }
            else {
                print("Skin doesn't exists")
            }
        }
    }

    Skin {
        id: skinId
        skinFile: Qt.resolvedUrl("skins/ti84p.skn")
    }

    SkinImage {
        id: skinImageId
        skin: skinId
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        CalcScreen {
            calc: calcObj
            x: skinImageId.lcdX
            y: skinImageId.lcdY
            width: skinId.lcdW * skinImageId.scaleX
            height: skinId.lcdH * skinImageId.scaleY
        }
        MouseArea {
            anchors.fill: parent
            function keycode(mouse) {
                var nx = skinImageId.normalizeX(mouse.x);
                var ny = skinImageId.normalizeY(mouse.y);
                return skinImageId.skin.keyCode(nx,ny);
            }
            onPressed: {
                print("clicked")
                var keyCode = keycode(mouse)
                print("keyCode "+keyCode)
                if(keyCode>-1) {
                    calcObj.pressKey(keyCode)
                }
            }
            onReleased: {
                print("clicked")
                var keyCode = keycode(mouse)
                print("keyCode "+keyCode)
                if(keyCode>-1) {
                    calcObj.releaseKey(keyCode)
                }
            }
        }
    }
}
