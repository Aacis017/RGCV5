/****************************************************************************
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * DJI-Style UI Modifications - Qt6 Compatible
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

/// Standard push button control - DJI Style
Button {
    id:             control
    hoverEnabled:   !ScreenTools.isMobile
    topPadding:     _verticalPadding
    bottomPadding:  _verticalPadding
    leftPadding:    _horizontalPadding
    rightPadding:   _horizontalPadding
    focusPolicy:    Qt.ClickFocus
    font.family:    ScreenTools.normalFontFamily
    text:           ""

    property bool   primary:        false
    property bool   showBorder:     qgcPal.globalTheme === QGCPalette.Light
    property real   backRadius:     4  // DJI: Fixed 4px radius
    property real   heightFactor:   0.5
    property string iconSource:     ""
    property real   fontWeight:     Font.Medium  // DJI: Medium weight
    property real   pointSize:      ScreenTools.defaultFontPointSize
    property alias  wrapMode:            text.wrapMode
    property alias  horizontalAlignment: text.horizontalAlignment
    property alias  backgroundColor:     backRect.color
    property alias  textColor:           text.color

    property bool   _showHighlight:     enabled && (pressed | checked)
    property int    _horizontalPadding: ScreenTools.defaultFontPixelWidth * 2
    property int    _verticalPadding:   Math.round(ScreenTools.defaultFontPixelHeight * heightFactor)

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

    background: Rectangle {
        id:             backRect
        radius:         backRadius
        implicitWidth:  ScreenTools.implicitButtonWidth
        implicitHeight: ScreenTools.implicitButtonHeight

        // DJI: Modern button colors
        border.width:   primary ? 0 : (showBorder ? 1 : 0)
        border.color:   control.hovered ? "#4a4a4a" : "#3a3a3a"

        color: {
            if (!control.enabled) return "#2a2a2a"
            if (primary) {
                return _showHighlight ? "#00a3cc" : (control.hovered ? "#00e4ff" : "#00d4ff")
            }
            return _showHighlight ? "#3a3a3a" : (control.hovered ? "#2f2f2f" : "#2a2a2a")
        }

        // DJI: Smooth color transitions
        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }

        // DJI: Subtle scale feedback on press
        scale: _showHighlight ? 0.98 : 1.0

        Behavior on scale {
            NumberAnimation { duration: 100 }
        }
    }

    contentItem: RowLayout {
        spacing: ScreenTools.defaultFontPixelWidth

        QGCColoredImage {
            id:                     icon
            Layout.alignment:       Qt.AlignHCenter
            source:                 control.iconSource
            height:                 text.height
            width:                  height
            color:                  text.color
            fillMode:               Image.PreserveAspectFit
            sourceSize.height:      height
            visible:                control.iconSource !== ""
        }

        QGCLabel {
            id:                     text
            Layout.alignment:       Qt.AlignHCenter
            text:                   control.text
            font.pointSize:         control.pointSize
            font.family:            control.font.family
            font.weight:            fontWeight

            // DJI: Clean text colors
            color: {
                if (!control.enabled) return "#666666"
                if (primary) return "#0a0a0a"  // Dark text on cyan
                return "#ffffff"  // White text on dark
            }

            visible:                control.text !== ""
        }
    }

    // DJI: Cursor feedback
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: control.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        propagateComposedEvents: true
    }
}
