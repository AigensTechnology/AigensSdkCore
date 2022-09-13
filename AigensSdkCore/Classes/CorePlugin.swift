import Foundation
import Capacitor
import UIKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CorePlugin)
public class CorePlugin: CAPPlugin {

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
    
    @objc func echo(_ call: CAPPluginCall) {

        print("CorePlugin echo")

        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])


    }

    @objc func dismiss(_ call: CAPPluginCall) {

        print("CorePlugin dismiss")

        DispatchQueue.main.async {
            self.bridge?.viewController?.dismiss(animated: true);
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

        print("CorePlugin finish")

        DispatchQueue.main.async {
            self.bridge?.viewController?.dismiss(animated: true);
        }


        //let value = call.getString("value") ?? ""
        call.resolve([
            "success": true
            //"value": implementation.echo(value)
        ])
    }


    @objc func openBrowser(_ call: CAPPluginCall) {

        print("CorePlugin openBrowser")

        let url = call.getString("url")


        if(url == nil){
            return
        }

        let member = call.getObject("member")
        let deeplink = call.getObject("deeplink")
        let externalProtocols = call.getArray("externalProtocols")

        DispatchQueue.main.async {

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

        }else {
            call.reject("url is missing or is invaild url")
            return
        }
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
