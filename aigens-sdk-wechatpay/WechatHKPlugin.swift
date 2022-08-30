import Foundation
import Capacitor

@objc public protocol WeChatPayDelegate: AnyObject {
    func wechatPayOrder(options: NSDictionary, call: CAPPluginCall)
    func handleOpenUrl(url: URL)
}

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(WechatHKPlugin)
public class WechatHKPlugin: CAPPlugin {
    private let implementation = WechatHK()
    
    static public var weChatPayDelegate: WeChatPayDelegate?
    public override func load() {
        super.load()
        print("WechatHKPlugin load")
        
        handleOpenUrl()
    }
    
    private func handleOpenUrl() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUniversalLink(notification:)), name: Notification.Name.capacitorOpenUniversalLink, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUrlOpened(notification:)), name: Notification.Name.capacitorOpenURL, object: nil)
    }
    @objc func handleUrlOpened(notification: NSNotification) {
        guard let object = notification.object as? [String: Any?] else {
            return
        }
        
        print("handleUrlOpened url:\(object)")
        guard let url = object["url"] as? URL else {
            return
        }
        
        WechatHKPlugin.weChatPayDelegate?.handleOpenUrl(url: url)
    }
    
    @objc func handleUniversalLink(notification: NSNotification) {
        guard let object = notification.object as? [String: Any?] else {
            return
        }
        
        print("handleUniversalLink url:\(object)")
        guard let url = object["url"] as? URL else {
            return
        }
        
        WechatHKPlugin.weChatPayDelegate?.handleOpenUrl(url: url)
        
    }
    
    
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    
    @objc func makePaymentRequest(_ call: CAPPluginCall) {
        guard let options = call.getObject("options") else {
            call.reject("missing options")
            return;
        }
        
        WechatHKPlugin.weChatPayDelegate?.wechatPayOrder(options: options as NSDictionary, call: call)
        
    }
    
}
