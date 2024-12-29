package moe.saru.homebrew.console3ds.mset9_installer_android

import androidx.compose.ui.window.Window
import androidx.compose.ui.window.application

fun main() = application {
    Window(
        onCloseRequest = ::exitApplication,
        title = "MSET9 Installer",
    ) {
        App()
    }
}