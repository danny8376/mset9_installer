package moe.saru.homebrew.console3ds.mset9_installer_android

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform