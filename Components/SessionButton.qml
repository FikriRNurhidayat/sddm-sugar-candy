//
// This file is part of SDDM Sugar Candy.
// A theme for the Simple Display Desktop Manager.
//
// Copyright (C) 2018–2020 Marian Arlt
//
// SDDM Sugar Candy is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or any later version.
//
// You are required to preserve this and any additional legal notices, either
// contained in this file or in other files that you received along with
// SDDM Sugar Candy that refer to the author(s) in accordance with
// sections §4, §5 and specifically §7b of the GNU General Public License.
//
// SDDM Sugar Candy is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with SDDM Sugar Candy. If not, see <https://www.gnu.org/licenses/>
//

import QtQuick 2.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Item {
    id: sessionButton
    height: root.font.pointSize
    width: parent.width / 2
    anchors.horizontalCenter: parent.horizontalCenter

    property var selectedSession: selectSession.currentIndex
    property string textConstantSession
    property int loginButtonWidth
    property Control exposeSession: selectSession

    ComboBox {
        id: selectSession
        
        hoverEnabled: true
        anchors.centerIn: parent.centerIn
        width: parent.width
        padding: 16
        
        Keys.onPressed: {
            if (event.key == Qt.Key_Up && loginButton.state != "enabled" && !popup.opened)
                revealSecret.focus = true,
                revealSecret.state = "focused",
                currentIndex = currentIndex + 1;
            if (event.key == Qt.Key_Up && loginButton.state == "enabled" && !popup.opened)
                loginButton.focus = true,
                loginButton.state = "focused",
                currentIndex = currentIndex + 1;
            if (event.key == Qt.Key_Down && !popup.opened)
                systemButtons.children[0].focus = true,
                systemButtons.children[0].state = "focused",
                currentIndex = currentIndex - 1;
            if ((event.key == Qt.Key_Left || event.key == Qt.Key_Right) && !popup.opened)
                popup.open();
        }

        model: sessionModel
        currentIndex: model.lastIndex
        textRole: "name"

        delegate: ItemDelegate {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text {
                text: model.name
                font.pointSize: root.font.pointSize * 0.69
                font.family: root.font.family
                color: selectSession.highlightedIndex === index ? root.palette.window : root.palette.text
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            highlighted: parent.highlightedIndex === index
            background: Rectangle {
                color: selectSession.highlightedIndex === index ? root.palette.text : "transparent"
            }
        }

        indicator {
            visible: false
        }

        contentItem: Text {
            id: displayedItem
            text: selectSession.currentText
            font.family: root.font.family
            color: root.palette.text
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: root.font.pointSize * 0.69
            Keys.onReleased: parent.popup.open()
        }

        background: Rectangle {
            color: "transparent"
            border.width: parent.visualFocus ? 1 : 0
            border.color: "transparent"
            height: parent.visualFocus ? 2 : 0
            width: displayedItem.implicitWidth
        }

        popup: Popup {
            id: popupHandler
            y: parent.height - 8
            x: config.ForceRightToLeft == "true" ? -loginButtonWidth + displayedItem.width : 0
            width: sessionButton.width
            implicitHeight: contentItem.implicitHeight

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight + 20
                model: selectSession.popup.visible ? selectSession.delegateModel : null
                currentIndex: selectSession.highlightedIndex
                ScrollIndicator.vertical: ScrollIndicator { }
            }

            background: Rectangle {
                radius: config.RoundCorners / 2
                color: root.palette.text
                opacity: 0.2
                layer.enabled: true
            }

            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1 }
            }
        }

        transitions: [
            Transition {
                PropertyAnimation {
                    properties: "color, border.color"
                    duration: 150
                }
            }
        ]

    }

}
