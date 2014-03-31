import QtQuick 2.0
import Ubuntu.Components 0.1
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

    Calc {
        id: calcObj

        onModelNameChanged: {
            print("modelName: "+modelName)
            var skinFile = Qt.resolvedUrl("skins/"+modelName+".skn")
            print("skinFile: "+skinFile)
            if(Env.fileExists(skinFile)) {
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
        anchors.fill: parent
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
