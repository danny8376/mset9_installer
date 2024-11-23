package moe.saru.homebrew.console3ds.mset9_installer

import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper
import androidx.documentfile.provider.DocumentFile
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    companion object {
        private const val CHANNEL = "moe.saru.homebrew.console3ds.mset9_installer/watcher"
    }

    private val watchers = mutableMapOf<String, ContentObserver>()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Companion.CHANNEL)
        channel.setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "watch" -> {
                        val uriString: String? = call.argument("uri")
                        if (uriString == null) {
                            result.error("ArgumentError", "missing argument uri", "")
                        }
                        val monitoringUri = Uri.parse(uriString)
                        val observer = object : ContentObserver(Handler(Looper.getMainLooper())) {
                            override fun onChange(selfChange: Boolean, uri: Uri?) {
                                super.onChange(selfChange, uri)
                                fun invokeMethod(method: String, args: Any?) {
                                    channel.invokeMethod(method, args)
                                }
                                Log.d("Watcher", "event on: ${uri.toString()}");
                                val monitoringDoc =
                                    DocumentFile.fromTreeUri(context, monitoringUri) ?: return
                                @Suppress("NAME_SHADOWING")
                                // specifically shadowing this variable for safer comparison
                                val monitoringUri = monitoringDoc.uri
                                if (selfChange) {
                                    invokeMethod("watcher", mapOf(
                                        "of" to uriString,
                                        //"updates" to if (monitoringDoc.isDirectory) arrayOf<String>() else null,
                                        "updates" to null,
                                    ))
                                    return
                                }
                                if (uri == null) {
                                    return
                                }
                                val doc: DocumentFile?
                                try {
                                    doc = DocumentFile.fromTreeUri(context, uri)
                                        ?: DocumentFile.fromSingleUri(context, uri)
                                } catch (_: IllegalArgumentException) {
                                    // it seems when umount, it can throw invalid uri to us?
                                    // and selfChange won't necessarily be set...
                                    invokeMethod("watcher", mapOf(
                                        "of" to uriString,
                                        "updates" to null,
                                    ))
                                    return
                                }
                                var update = ""
                                if (doc != null) {
                                    val stringBuilder = StringBuilder()
                                    stringBuilder.append(doc.name)
                                    var parentDoc: DocumentFile? = null
                                    while (true) {
                                        parentDoc = (parentDoc ?: doc).parentFile
                                        if (parentDoc == null)
                                            break
                                        if (monitoringUri == parentDoc.uri)
                                            break
                                        stringBuilder.insert(0, File.separator)
                                        stringBuilder.insert(0, parentDoc.name)
                                    }
                                    update = stringBuilder.toString()
                                }
                                invokeMethod("watcher", mapOf(
                                    "of" to uriString,
                                    "updates" to arrayOf(update),
                                    "originalUri" to arrayOf(uri.toString()),
                                ))
                            }
                        }
                        contentResolver.registerContentObserver(monitoringUri, true, observer)
                        uriString?.let { watchers[uriString] = observer }
                        result.success(null)
                    }
                    "unwatch" -> {
                        val uriString: String? = call.argument("uri")
                        if (uriString == null) {
                            result.error("ArgumentError", "missing argument uri", "")
                        }
                        watchers[uriString]?.let { observer ->
                            contentResolver.unregisterContentObserver(observer)
                            watchers.remove(uriString)
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                Log.d("Watcher", "Exception: $e")
                val name = e.javaClass.getCanonicalName() ?: "Unknown"
                result.error(name, e.message, e.stackTraceToString())
            }
        }
    }
}
