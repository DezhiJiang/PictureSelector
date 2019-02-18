import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import "./QML/"

Window {
    objectName: "root"
    id: rootui
    width: parameter.starting_width
    height: parameter.starting_height
    title: qsTr("FILTER TOOL")
    visible: true

    Parameter{
        id: parameter
    }

    Starting{
        id: starting_ui
        visible: true
    }

    Function1{
        id: function1_ui
        visible: false
    }

    Function2{
        id: function2_ui
        visible: false
    }

    Function3{
        id: function3_ui
        visible: false
    }
    CombineUI{
        id: combine_ui
        visible: false
    }

}
