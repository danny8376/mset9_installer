import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var resultCache = nil

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let ioChannel = FlutterMethodChannel(name: "moe.saru.homebrew.console3ds.mset9_installer/io",
                                              binaryMessenger: controller.binaryMessenger)
    ioChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      if resultCache {
        resultCache(FlutterError(code: "multiple_request",
                                 message: "Cancelled by another request",
                                 details: nil))
        resultCache = nil;
      }
      switch call.method {
        case "test":
          resultCache = result
          let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
          documentPicker.delegate = self
          present(documentPicker, animated: true, completion: nil)
        default:
          result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
    // Start accessing a security-scoped resource.
    guard url.startAccessingSecurityScopedResource() else {
        // Handle the failure here.
        resultCache("*** permission revoked ***")
        resultCache = nil
        return
    }

    // Make sure you release the security-scoped resource when you finish.
    defer { url.stopAccessingSecurityScopedResource() }

    // Use file coordination for reading and writing any of the URL’s content.
    var error: NSError? = nil
    var res = "";
    NSFileCoordinator().coordinate(readingItemAt: url, error: &error) { (url) in
        let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]

        // Get an enumerator for the directory's content.
        guard let fileList =
            FileManager.default.enumerator(at: url, includingPropertiesForKeys: keys) else {
            resultCache("*** Unable to access the contents of \(url.path) ***")
            resultCache = nil
            return
        }

        for case let file as URL in fileList {
            // Start accessing the content's security-scoped URL.
            guard file.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                continue
            }

            // Do something with the file here.
            res += "chosen file: \(file.lastPathComponent)\n"
                
            // Make sure you release the security-scoped resource when you finish.
            file.stopAccessingSecurityScopedResource()
        }
    }
    resultCache(res)
    resultCache = nil
  }
}
