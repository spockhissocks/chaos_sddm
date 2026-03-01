/***************************************************************************
* CHAOS UNDIVIDED — SDDM Theme
* "The galaxy burns. Log in or be consumed."
*
* Requires: ttf-cinzel (AUR), ttf-unifraktur-maguntia (AUR)
* Based on original work by Abdurrahman AVCI — MIT License
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    anchors.fill: parent
    color: "#03080b"

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    // ── Chaos God Rotation ──────────────────────────────────────────────────────
    // Randomly selects a Chaos God on each login screen load.
    // 0=Undivided  1=Khorne  2=Tzeentch  3=Nurgle  4=Slaanesh
    property int chaosGod: Math.floor(Math.random() * 5)

    property color godAccent: chaosGod === 1 ? "#c0392b"
                            : chaosGod === 2 ? "#2980e8"
                            : chaosGod === 3 ? "#4a7c3f"
                            : chaosGod === 4 ? "#9b59b6"
                            :                 "#c8a951"

    property color godDim:    chaosGod === 1 ? "#6b0000"
                            : chaosGod === 2 ? "#0a2d6b"
                            : chaosGod === 3 ? "#1a3d16"
                            : chaosGod === 4 ? "#3d1050"
                            :                 "#5a4200"

    property color godGlow:   chaosGod === 1 ? "#8b0000"
                            : chaosGod === 2 ? "#0040aa"
                            : chaosGod === 3 ? "#2d5a24"
                            : chaosGod === 4 ? "#6a0e9a"
                            :                 "#7a5800"

    property string godName:  chaosGod === 1 ? "BLOOD FOR THE BLOOD GOD"
                            : chaosGod === 2 ? "CHANGE IS THE ONLY CONSTANT"
                            : chaosGod === 3 ? "GRANDFATHER NURGLE WELCOMES YOU"
                            : chaosGod === 4 ? "PERFECTION IS PAIN"
                            :                 "ALL IS DUST  ·  ALL IS BLOOD  ·  ALL IS CHANGE"

    property string godTitle: chaosGod === 1 ? "KHORNE"
                            : chaosGod === 2 ? "TZEENTCH"
                            : chaosGod === 3 ? "NURGLE"
                            : chaosGod === 4 ? "SLAANESH"
                            :                 "CHAOS UNDIVIDED"

    property string godQuote: chaosGod === 1 ? "\"SKULLS FOR THE SKULL THRONE\""
                            : chaosGod === 2 ? "\"JUST AS PLANNED\""
                            : chaosGod === 3 ? "\"DEATH IS JUST THE BEGINNING\""
                            : chaosGod === 4 ? "\"PAIN AND PLEASURE ARE ONE\""
                            :                 "\"THE EMPEROR IS A ROTTING CORPSE\""

    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
            errorMessage.color = godAccent
            errorMessage.text = "THE WARP ACCEPTS YOU, MORTAL  ∴"
        }
        onLoginFailed: {
            password.text = ""
            errorMessage.color = "#cc2200"
            errorMessage.text = "✗  THE GODS REJECT YOUR OFFERING  ✗"
            bloodFlash.opacity = 0.28
            flashAnim.restart()
            glitchTimer.restart()
        }
        onInformationMessage: {
            errorMessage.color = godAccent
            errorMessage.text = message
        }
    }

    // ── Background ──────────────────────────────────────────────────────────────
    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground)
                source = config.defaultBackground
        }
    }

    // Heavy darkness overlay — the Warp consumes the light
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0;  color: "#e8000000" }
            GradientStop { position: 0.35; color: "#88000000" }
            GradientStop { position: 0.65; color: "#88000000" }
            GradientStop { position: 1.0;  color: "#e8000000" }
        }
    }

    // Scanline overlay — corrupted terminal feel
    Canvas {
        anchors.fill: parent
        opacity: 0.035
        onPaint: {
            var ctx = getContext("2d")
            ctx.fillStyle = "#000000"
            for (var y = 0; y < height; y += 3) {
                ctx.fillRect(0, y, width, 1)
            }
        }
    }

    // ── Warp ambient glow — bottom ───────────────────────────────────────────────
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -100
        width: parent.width * 1.4
        height: 300
        radius: 150
        color: godGlow
        opacity: 0.0
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.22; duration: 2600; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.08; duration: 2600; easing.type: Easing.InOutSine }
        }
    }

    // Warp glow — top
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: -60
        width: parent.width * 0.8
        height: 200
        radius: 100
        color: godDim
        opacity: 0.0
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { to: 0.16; duration: 3400; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.04; duration: 3400; easing.type: Easing.InOutSine }
        }
    }

    // ── Ember particles — rising ash motes ──────────────────────────────────────
    Repeater {
        model: 30
        Item {
            property real startX:        Math.random() * container.width
            property real floatDuration: 5000 + Math.random() * 9000
            property real startDelay:    Math.floor(Math.random() * 9000)
            property real drift:         (Math.random() - 0.5) * 140
            property real sz:            1.0 + Math.random() * 2.5

            Rectangle {
                id: mote
                x: parent.startX
                y: container.height + 10
                width: parent.sz
                height: parent.sz
                radius: parent.sz
                color: godAccent
                opacity: 0

                SequentialAnimation {
                    loops: Animation.Infinite
                    PauseAnimation { duration: parent.parent.startDelay }
                    ParallelAnimation {
                        NumberAnimation {
                            target: mote; property: "y"
                            from: container.height + 10; to: -20
                            duration: parent.parent.floatDuration
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: mote; property: "x"
                            from: parent.parent.startX
                            to:   parent.parent.startX + parent.parent.drift
                            duration: parent.parent.floatDuration
                        }
                        SequentialAnimation {
                            NumberAnimation { target: mote; property: "opacity"; to: 0.9; duration: parent.parent.floatDuration * 0.12 }
                            NumberAnimation { target: mote; property: "opacity"; to: 0.4; duration: parent.parent.floatDuration * 0.6  }
                            NumberAnimation { target: mote; property: "opacity"; to: 0.0; duration: parent.parent.floatDuration * 0.28 }
                        }
                    }
                }
            }
        }
    }

    // ── Blood flash on failed login ──────────────────────────────────────────────
    Rectangle {
        id: bloodFlash
        anchors.fill: parent
        color: "#8b0000"
        opacity: 0
        SequentialAnimation {
            id: flashAnim
            NumberAnimation { target: bloodFlash; property: "opacity"; to: 0.28; duration: 60  }
            NumberAnimation { target: bloodFlash; property: "opacity"; to: 0.0;  duration: 700; easing.type: Easing.OutQuad }
        }
    }

    // ── Glitch timer — triggers on bad login ─────────────────────────────────────
    property bool glitching: false
    Timer {
        id: glitchTimer
        interval: 80; repeat: true
        property int ticks: 0
        onTriggered: {
            ticks++
            glitching = (ticks % 2 === 0)
            if (ticks > 14) { stop(); ticks = 0; glitching = false }
        }
    }

    // ── Top status bar ────────────────────────────────────────────────────────────
    Rectangle {
        anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
        height: 52
        color: "#000000"
        opacity: 0.7

        Rectangle {
            anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
            height: 1; color: godAccent; opacity: 0.45
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left; anchors.leftMargin: 24
            text: glitching
                  ? ("✦ " + sddm.hostName.toUpperCase() + " ✦").replace(/[AEIOUAEIOU]/g, function(c) { return ["Ж","Ø","Δ","Ψ","Ω"][Math.floor(Math.random()*5)] })
                  : "✦  " + sddm.hostName.toUpperCase() + "  ✦"
            color: glitching ? "#ff3300" : godAccent
            font.family: "Cinzel"
            font.pixelSize: 13
            font.letterSpacing: 5
            font.weight: Font.Bold
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 24
            text: godTitle
            color: godAccent; font.family: "Cinzel"; font.pixelSize: 10
            font.letterSpacing: 4; opacity: 0.8
        }
    }

    // ── Clock ──────────────────────────────────────────────────────────────────
    Clock {
        id: clock
        anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
        color: godAccent
        timeFont.family: "Cinzel"
        timeFont.weight: Font.Bold
        timeFont.pixelSize: 28
    }

    // ── Login panel ────────────────────────────────────────────────────────────
    Rectangle {
        id: loginPanel
        anchors.centerIn: parent
        width: 420
        height: mainColumn.implicitHeight + 90
        color: "#080808"
        opacity: 0.97
        radius: 0  // hard corners — this is not a friendly UI

        // Breathing outer glow
        Rectangle {
            anchors.fill: parent; anchors.margins: -2
            color: "transparent"; border.color: godAccent; border.width: 1; opacity: 0
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: 0.55; duration: 1700; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0.0;  duration: 1700; easing.type: Easing.InOutSine }
            }
        }
        // Dim permanent border
        Rectangle { anchors.fill: parent; color: "transparent"; border.color: godDim; border.width: 1 }

        // Top accent stripe — rotated rectangle workaround for QtQuick 2.0
        Item {
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            height: 4; clip: true
            Rectangle {
                width: parent.height; height: parent.width
                anchors.centerIn: parent
                rotation: 90
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.3; color: godAccent }
                    GradientStop { position: 0.7; color: godAccent }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }
        // Bottom accent stripe
        Item {
            anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
            height: 4; clip: true
            Rectangle {
                width: parent.height; height: parent.width
                anchors.centerIn: parent
                rotation: 90
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.3; color: godGlow }
                    GradientStop { position: 0.7; color: godGlow }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        // Corner rune marks
        Text { anchors.top: parent.top;    anchors.left:  parent.left;  anchors.margins: 8; text: "⚔"; color: godAccent; font.pixelSize: 11; opacity: 0.55 }
        Text { anchors.top: parent.top;    anchors.right: parent.right; anchors.margins: 8; text: "⚔"; color: godAccent; font.pixelSize: 11; opacity: 0.55 }
        Text { anchors.bottom: parent.bottom; anchors.left:  parent.left;  anchors.margins: 8; text: "⚔"; color: godAccent; font.pixelSize: 11; opacity: 0.55 }
        Text { anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 8; text: "⚔"; color: godAccent; font.pixelSize: 11; opacity: 0.55 }

        Column {
            id: mainColumn
            anchors.centerIn: parent
            width: parent.width - 64
            spacing: 16

            // ── Header ──────────────────────────────────────────
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "✠"
                    color: godAccent
                    font.pixelSize: 48
                    font.family: "UnifrakturMaguntia"
                    RotationAnimation on rotation {
                        loops: Animation.Infinite; from: 0; to: 360
                        duration: 20000; direction: RotationAnimation.Clockwise
                    }
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.5; duration: 1900; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 1900; easing.type: Easing.InOutSine }
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: godTitle
                    color: godAccent; font.family: "Cinzel"; font.pixelSize: 15
                    font.letterSpacing: 6; font.weight: Font.Bold
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: godName
                    color: godAccent; font.family: "Cinzel"; font.pixelSize: 7
                    font.letterSpacing: 2; opacity: 0.5
                    wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }
            }

            // Divider with rune
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8; width: parent.width
                Rectangle { width: (parent.width - 30)/2; height: 1; color: godAccent; opacity: 0.3; anchors.verticalCenter: parent.verticalCenter }
                Text { text: "ᚱ"; color: godAccent; font.pixelSize: 12; opacity: 0.7 }
                Rectangle { width: (parent.width - 30)/2; height: 1; color: godAccent; opacity: 0.3; anchors.verticalCenter: parent.verticalCenter }
            }

            // ── Username field ───────────────────────────────────
            Column {
                width: parent.width; spacing: 5
                Row {
                    spacing: 6
                    Text { text: "//"; color: godAccent; font.pixelSize: 9; opacity: 0.45; font.family: "Monospace" }
                    Text { text: "HERETIC DESIGNATION"; color: godAccent; font.family: "Cinzel"; font.pixelSize: 9; font.letterSpacing: 3; font.weight: Font.Bold; opacity: 0.85 }
                }
                TextBox {
                    id: name
                    width: parent.width; height: 38
                    text: userModel.lastUser
                    font.pixelSize: 14; font.family: "Monospace"
                    color: godDim; borderColor: godDim; focusColor: godAccent; hoverColor: godDim; textColor: "#e8d8a0"
                    KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, sessionIndex); event.accepted = true
                        }
                    }
                }
            }

            // ── Password field ───────────────────────────────────
            Column {
                width: parent.width; spacing: 5
                Row {
                    spacing: 6
                    Text { text: "//"; color: godAccent; font.pixelSize: 9; opacity: 0.45; font.family: "Monospace" }
                    Text { text: "BLOOD OATH"; color: godAccent; font.family: "Cinzel"; font.pixelSize: 9; font.letterSpacing: 3; font.weight: Font.Bold; opacity: 0.85 }
                }
                PasswordBox {
                    id: password
                    width: parent.width; height: 38
                    font.pixelSize: 14; font.family: "Monospace"
                    color: godDim; borderColor: godDim; focusColor: godAccent; hoverColor: godDim; textColor: "#e8d8a0"
                    KeyNavigation.backtab: name; KeyNavigation.tab: session
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, sessionIndex); event.accepted = true
                        }
                    }
                }
            }

            // ── Session + Layout ─────────────────────────────────
            Row {
                spacing: 10; width: parent.width

                Column {
                    width: parent.width * 0.58; spacing: 5
                    Row {
                        spacing: 6
                        Text { text: "//"; color: godAccent; font.pixelSize: 9; opacity: 0.45; font.family: "Monospace" }
                        Text { text: "WARP RIFT"; color: godAccent; font.family: "Cinzel"; font.pixelSize: 9; font.letterSpacing: 3; font.weight: Font.Bold; opacity: 0.85 }
                    }
                    ComboBox {
                        id: session
                        width: parent.width; height: 32
                        font.pixelSize: 12; font.family: "Monospace"
                        arrowIcon: "angle-down.png"
                        model: sessionModel; index: sessionModel.lastIndex
                        color: godDim; borderColor: godDim; focusColor: godAccent; hoverColor: godDim; textColor: "#e8d8a0"
                        KeyNavigation.backtab: password; KeyNavigation.tab: layoutBox
                    }
                }

                Column {
                    width: parent.width * 0.37; spacing: 5
                    Row {
                        spacing: 6
                        Text { text: "//"; color: godAccent; font.pixelSize: 9; opacity: 0.45; font.family: "Monospace" }
                        Text { text: "TONGUE"; color: godAccent; font.family: "Cinzel"; font.pixelSize: 9; font.letterSpacing: 3; font.weight: Font.Bold; opacity: 0.85 }
                    }
                    LayoutBox {
                        id: layoutBox
                        width: parent.width; height: 32
                        font.pixelSize: 12; font.family: "Monospace"
                        arrowIcon: "angle-down.png"
                        color: godDim; borderColor: godDim; focusColor: godAccent; hoverColor: godDim; textColor: "#e8d8a0"
                        KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                    }
                }
            }

            // ── Status / error message ───────────────────────────
            Text {
                id: errorMessage
                anchors.horizontalCenter: parent.horizontalCenter
                text: "∴  SPEAK THE WORDS OF BINDING  ∴"
                color: godAccent; font.family: "Cinzel"; font.pixelSize: 9; font.letterSpacing: 2
                opacity: 0.65; wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter; width: parent.width
            }

            // Divider
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8; width: parent.width
                Rectangle { width: (parent.width - 30)/2; height: 1; color: godAccent; opacity: 0.3; anchors.verticalCenter: parent.verticalCenter }
                Text { text: "ᚱ"; color: godAccent; font.pixelSize: 12; opacity: 0.7 }
                Rectangle { width: (parent.width - 30)/2; height: 1; color: godAccent; opacity: 0.3; anchors.verticalCenter: parent.verticalCenter }
            }

            // ── Action buttons ───────────────────────────────────
            Row {
                anchors.horizontalCenter: parent.horizontalCenter; spacing: 8
                Button {
                    id: loginButton
                    text: "PLEDGE ALLEGIANCE"; width: 148
                    color: godAccent; pressedColor: godGlow; borderColor: godAccent; textColor: "#080808"
                    font.family: "Cinzel"; font.pixelSize: 10; font.letterSpacing: 1; font.weight: Font.Bold
                    onClicked: sddm.login(name.text, password.text, sessionIndex)
                    KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                }
                Button {
                    id: shutdownButton
                    text: "ANNIHILATE"; width: 110
                    color: "#110000"; pressedColor: "#440000"; borderColor: "#8b0000"; textColor: "#8b0000"
                    font.family: "Cinzel"; font.pixelSize: 10; font.letterSpacing: 1; font.weight: Font.Bold
                    onClicked: sddm.powerOff()
                    KeyNavigation.backtab: loginButton; KeyNavigation.tab: rebootButton
                }
                Button {
                    id: rebootButton
                    text: "REBIRTH"; width: 80
                    color: "#0a0a14"; pressedColor: "#0d0d2e"; borderColor: "#2a2a6a"; textColor: "#4a4a9a"
                    font.family: "Cinzel"; font.pixelSize: 10; font.letterSpacing: 1; font.weight: Font.Bold
                    onClicked: sddm.reboot()
                    KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: godQuote
                color: godAccent; font.family: "Cinzel"; font.pixelSize: 7
                font.letterSpacing: 2; font.italic: true; opacity: 0.3
            }
        }
    }

    // ── Scrolling lore ticker ──────────────────────────────────────────────────
    Rectangle {
        anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
        height: 30; color: "#000000"; opacity: 0.7; clip: true

        Rectangle {
            anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
            height: 1; color: godAccent; opacity: 0.4
        }

        Text {
            id: tickerText
            anchors.verticalCenter: parent.verticalCenter
            text: "⚔  IN THE GRIM DARKNESS OF THE FAR FUTURE, THERE IS ONLY WAR  ⚔  THE FOUR GODS WATCH  ⚔  KHORNE DEMANDS SKULLS  ⚔  TZEENTCH WEAVES HIS SCHEMES  ⚔  NURGLE EMBRACES ALL  ⚔  SLAANESH HUNGERS  ⚔  THE WARP IS REAL  ⚔  HERESY GROWS FROM IDLENESS  ⚔  SUFFER NOT THE UNCLEAN TO LIVE  ⚔  DEATH TO THE FALSE EMPEROR  ⚔  "
            color: godAccent; font.family: "Cinzel"; font.pixelSize: 9; font.letterSpacing: 2; opacity: 0.55
            x: container.width
            NumberAnimation on x {
                loops: Animation.Infinite
                from: container.width; to: -tickerText.implicitWidth
                duration: 44000; easing.type: Easing.Linear
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "") name.focus = true
        else password.focus = true
    }
}
