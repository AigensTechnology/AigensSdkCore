import Foundation
import Capacitor
import UIKit

#if DISABLE_ADD_CALENDER
#else
import EventKitUI
#endif


@objc public protocol CoreDelegate: AnyObject {
    func isInterceptedUrl(url: URL, webview: WKWebView) -> Bool
}

var aigensDebug = false;
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CorePlugin)
public class CorePlugin: CAPPlugin {

    static public var coreDelegate: CoreDelegate?

    public static let shared = CorePlugin()
    private let implementation = Core()
    public static var member: Dictionary<String, Any>?
    public static var deeplink: Dictionary<String, Any>?

    @objc public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .capacitorOpenURL, object: [
            "url": url,
            "options": options
        ])
        NotificationCenter.default.post(name: NSNotification.Name.CDVPluginHandleOpenURL, object: url)
        return true
    }

    @objc public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // TODO: Support other types, emit to rest of plugins
        if userActivity.activityType != NSUserActivityTypeBrowsingWeb || userActivity.webpageURL == nil {
            return false
        }
        let url = userActivity.webpageURL
        NotificationCenter.default.post(name: .capacitorOpenUniversalLink, object: [
            "url": url
        ])
        return true
    }

    private func clearCache() {
        if #available(iOS 9.0, *) {
            /*
             在磁盘缓存上。
             WKWebsiteDataTypeDiskCache,
             html离线Web应用程序缓存。
             WKWebsiteDataTypeOfflineWebApplicationCache,
             内存缓存。
             WKWebsiteDataTypeMemoryCache,
             本地存储。
             WKWebsiteDataTypeLocalStorage,
             Cookies
             WKWebsiteDataTypeCookies,
             会话存储
             WKWebsiteDataTypeSessionStorage,
             IndexedDB数据库。
             WKWebsiteDataTypeIndexedDBDatabases,
             查询数据库。
             WKWebsiteDataTypeWebSQLDatabases
             */
            let types = [WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache]
            let websiteDataTypes = Set<AnyHashable>(types)
            let dateFrom = Date(timeIntervalSince1970: 0)
            if let websiteDataTypes = websiteDataTypes as? Set<String> {
                WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom, completionHandler: {
                    aigensprint("removeData completionHandler");
                })
            }
        } else {
            //            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
            //            let cookiesFolderPath = libraryPath + ("/Cookies")
            //            JJPrint("\(cookiesFolderPath)")
            //            try? FileManager.default.removeItem(atPath: cookiesFolderPath)
        }
    }

    @objc func echo(_ call: CAPPluginCall) {

        aigensprint("CorePlugin echo")

        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])


    }

    @objc func dismiss(_ call: CAPPluginCall) {

        aigensprint("CorePlugin dismiss")

        DispatchQueue.main.async {
            self.bridge?.viewController?.dismiss(animated: true);
        }


        if let data = call.getObject("closedData") {
            let r = ["closedData": data]
            WebContainerViewController.closeCB?(r)
            CorePlugin.dismissCall?.resolve(r)
        }

        //let value = call.getString("value") ?? ""
        call.resolve([
            "success": true
            //"value": implementation.echo(value)
        ])


    }

    @objc func getMember(_ call: CAPPluginCall) {

        call.resolve([
            "member": CorePlugin.member ?? nil
        ])
    }
    @objc func getDeeplink(_ call: CAPPluginCall) {

        call.resolve([
            "deeplink": CorePlugin.deeplink ?? nil
        ])
    }

    @objc func finish(_ call: CAPPluginCall) {

        aigensprint("CorePlugin finish")

        DispatchQueue.main.async {
            self.bridge?.viewController?.dismiss(animated: true);
        }

        if let data = call.getObject("closedData") {
            let r = ["closedData": data]
            WebContainerViewController.closeCB?(r)
            CorePlugin.dismissCall?.resolve(r)
        }

        //let value = call.getString("value") ?? ""
        call.resolve([
            "success": true
            //"value": implementation.echo(value)
        ])
    }

    private static var dismissCall: CAPPluginCall?
    @objc func getFinishData(_ call: CAPPluginCall) {
        call.keepAlive = true
        CorePlugin.dismissCall = call
    }


    @objc func openBrowser(_ call: CAPPluginCall) {

        aigensprint("CorePlugin openBrowser")

        let url = call.getString("url")


        if(url == nil){
            return
        }

        let member = call.getObject("member")
        let deeplink = call.getObject("deeplink")
        let externalProtocols = call.getArray("externalProtocols")
        let addPaddingProtocols = call.getArray("addPaddingProtocols")

        let clearCache = call.getBool("clearCache") ?? false
        aigensDebug = call.getBool("debug") ?? false

        DispatchQueue.main.async {

            if clearCache {
                self.clearCache()
            }
            let bridgeVC = WebContainerViewController()

            var options = [String: AnyObject]()
            options["url"] = url as AnyObject;

            if(member != nil){
                options["member"] = member as AnyObject;
            }
            if(deeplink != nil){
                options["deeplink"] = deeplink as AnyObject;
            }
            if (externalProtocols != nil) {
                options["externalProtocols"] = externalProtocols as AnyObject
            }
            if (addPaddingProtocols != nil) {
                options["addPaddingProtocols"] = addPaddingProtocols as AnyObject
            }

            bridgeVC.options = options;

            bridgeVC.modalPresentationStyle = .fullScreen
            let currentVC = self.bridge?.viewController;
            currentVC?.present(bridgeVC, animated: true);
        }


        call.resolve([
            "success": true
            //"value": implementation.echo(value)
        ])
    }

    @objc func isInstalledApp(_ call: CAPPluginCall) {
        if let url = call.getString("key"), let URL_ = URL(string: url) {
            DispatchQueue.main.async {
                let can = UIApplication.shared.canOpenURL(URL_)
                call.resolve([
                    "install": can
                ])
            }
        }else {
            call.reject("key is missing or is invaild key")
            return
        }
    }
    @objc func getIsProductionEnvironment(_ call: CAPPluginCall) {
        call.resolve([
            "isPrd": true
        ])
    }

    @objc func openExternalUrl(_ call: CAPPluginCall) {
        if let url = call.getString("url"), let URL_ = URL(string: url) {
            DispatchQueue.main.async {
                let can = UIApplication.shared.canOpenURL(URL_)
                if !can {
                    call.reject("cannot open the url:\(url)")
                    return;
                }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL_, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(URL_)
                }
                call.resolve([
                    "open": true
                ])

            }

        }else {
            call.reject("url is missing or is invaild url")
            return
        }
    }
    @objc func checkNotificationPermissions(_ call: CAPPluginCall) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            let status = settings.authorizationStatus
            let permission: String
            switch status {
            case .authorized, .ephemeral, .provisional:
                permission = "granted"
            case .denied:
                permission = "denied"
            case .notDetermined:
                permission = "prompt"
            @unknown default:
                permission = "prompt"
            }
            call.resolve(["display": permission])
        }
    }

    private func showNewEvent(_ askPermission: Bool, _ call: CAPPluginCall) {
        
        
#if DISABLE_ADD_CALENDER
        call.reject("Please remove (-D DISABLE_ADD_CALENDER from (AigensSdkCore) Build Settings -> Other Swift Flags) first")
#else
        let store = EKEventStore()
        if askPermission {
            store.requestAccess(to: .event) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        self.showNewEvent(false, call)
                    }
                }else {
                    call.resolve(["notPermission": true])
                }
            }
            return
        }

        let event = EKEvent(eventStore: store)
        let title = call.getString("title", "")
        if title == "" {
            call.reject("missing title")
            return;
        }
        event.title = title
        if let notes = call.getString("notes") {
            event.notes = notes;
        }
        if let location = call.getString("location") {
            event.location = location
        }
        let isAllDay = call.getBool("isAllDay", false)
        event.isAllDay = isAllDay
        //        event.availability = .busy
        //        event.structuredLocation = ...
        if let beginTime = call.getDouble("beginTime") {
            event.startDate = Date(timeIntervalSince1970: beginTime / 1000)
        }
        
        if let endTime = call.getDouble("endTime") {
            event.endDate = Date(timeIntervalSince1970: endTime / 1000)
        }
        
        
        let vc = EKEventEditViewController()
        vc.event = event
        vc.eventStore = store // <-- this needs to be the same event store you used for EKEvent
        vc.editViewDelegate = self
        self.bridge?.viewController?.present(vc, animated: true, completion: nil)
        
        call.resolve(["notPermission": false, "resultCode": 0])
#endif
        

    }

    @objc func addCalendar(_ call: CAPPluginCall) {
        showNewEvent(true, call)
    }

    @objc func setTextZoom(_ call: CAPPluginCall) {
        call.unimplemented("ios does not implement.")
    }

    private func getStringFromQr(_ image: UIImage) -> String? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        // 2.从选中的图片中读取二维码数据
        // 2.1创建一个探测器
        // CIDetectorTypeFace -- 探测器还可以搞人脸识别
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        // 2.2利用探测器探测数据
        let results = detector?.features(in: ciImage) ?? []
        // 2.3取出探测到的数据
        var str: String? = nil;
        if results.count > 0 {
            str = (results[0] as? CIQRCodeFeature)?.messageString
        }
        return str;
    }

    @objc func readClipboard(_ call: CAPPluginCall) {
        if UIPasteboard.general.hasImages, let image = UIPasteboard.general.image, let str = getStringFromQr(image) {
            call.resolve(["value": str, "type": "text/plain"])
            return
        }
        call.resolve(["value": "", "type": ""])
    }


    /*
    @objc func openAppSettings(_ call: CAPPluginCall) {
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
          return
      }

      DispatchQueue.main.async {
          if UIApplication.shared.canOpenURL(settingsUrl) {
              UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                  call.resolve()
              })
          }
      }
    }
    */





}


///全局函数
func aigensprint<T>(_ message:T,file:String = #file,_ funcName:String = #function,_ lineNum:Int = #line){

    if aigensDebug {
        let file = (file as NSString).lastPathComponent;
        print("\(file):(\(lineNum))--:\(message)");
    }

}

#if DISABLE_ADD_CALENDER
#else
extension CorePlugin: EKEventEditViewDelegate {
    public func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true)
    }
}
#endif


