package moe.saru.homebrew.console3ds.mset9_installer_android

class Greeting {
    private val platform = getPlatform()

    fun greet(): String {
        return "Hello, ${platform.name}!"
    }
}