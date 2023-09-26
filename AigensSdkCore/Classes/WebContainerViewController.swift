//
//  WebContainerViewController.swift
//  AigensAigensSdkCore
//
//  Created by Peter Liu on 5/3/2022.
//
import UIKit;
import Foundation
import Capacitor


@objc open class WebContainerViewController: CAPBridgeViewController {

    public static var closeCB: ((Any?) -> Void)? = nil;
    // {themeColor: "#xxxxxx"}
    public var options: Dictionary<String, Any>?
    private var isFirstError = true
    private var redirectLink = ""
    private var universalLink = ""
    var externalProtocols: [String] = [
        "octopus://", "alipay://", "alipays://", "alipayhk://", "https://play.google.com", "https://itunes.apple.com", "tel:", "mailto:", "itms-apps://itunes.apple.com", "https://apps.apple.com", "payme://", "weixin://", "hsbcpaymepay://", "mpay://"
    ]
    var addPaddingProtocols: [String] = [
        "https://ap-gateway.mastercard.com",
        "https://mapi-hk.alipay.com/",
        "https://mclient.alipay.com/",
        "https://tscenter.alipay.com/",
        "https://test.paydollar.com/",
        "https://paydollar.com/",
        "https://www.paydollar.com/",
        "https://web-test.online.octopus.com.hk",
        "https://web.online.octopus.com.hk",
        "https://web-prd.online.octopus.com.hk",
        "http://vmp.eftpay.com.cn",
        "https://wx.tenpay.com",
        "https://uatopenapi.macaupay.com.mo",
        "https://uatpay.macaupass.com",
        "https://prdpay.macaupass.com",
        "https://pay.macaupass.com",
    ]

    let containerView = WebContainer.webContainer()
    var webContainerView: WebContainer {
            return containerView
    }
    override open func viewDidLoad() {

        aigensprint("WebContainerViewController viewDidLoad")

        self.becomeFirstResponder()

        addChannel()
        loadWebViewCustom()
        initView()

        handleOpenUrl()

//        if let splashScreenPlugin = bridge?.plugin(withName: "SplashScreen") {
//            let selector = NSSelectorFromString("hide:")
//            if splashScreenPlugin.responds(to: selector) {
//                let pluginCall = CAPPluginCall(callbackId: "hideSplashScreen", options: [:]) { (callResult, call) in
//                    aigensprint("callResult:\(callResult)")
//                } error: { error in
//                    aigensprint("error:\(error)")
//                }
//                splashScreenPlugin.perform(selector, with: pluginCall)
//            }
//        }

    }

    private func isPaddingUrl(_ url: URL) -> Bool {
        var result = false
        addPaddingProtocols.forEach { (url_) in
            if (url.absoluteString.starts(with: url_)) {
                result = true
            }
        }
        return result
    }
    private func addChannel() {
        if let urlString = self.options?["url"] as? String {

            if !urlString.contains("&channel=app") && !urlString.contains("?channel=app") {
                let sign = urlString.contains("?") ? "&" : "?"
                self.options?["url"] = urlString + sign + "channel=app"
            }
        }
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


    private func handleOpenUrl() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUniversalLink(notification:)), name: Notification.Name.capacitorOpenUniversalLink, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleUrlOpened(notification:)), name: Notification.Name.capacitorOpenURL, object: nil)
    }

    @objc func handleUrlOpened(notification: NSNotification) {
        guard let object = notification.object as? [String: Any?] else {
            return
        }

        aigensprint("handleUrlOpened url:\(object)")
        guard var url = object["url"] as? URL else {
            return
        }

        url = decodeURIComponent(url);

        if universalLink.isEmpty || (!url.absoluteString.starts(with: universalLink) && !universalLink.contains("aigens=true") && !universalLink.contains("aigens/true")) {
            return;
        }

        let rUrl = URLRequest(url: url)

        let newUrl = url;
        if newUrl.absoluteString.range(of: "redirect=") != nil, let redirect = newUrl.absoluteString.components(separatedBy:"redirect=").last, !redirect.isEmpty {
            aigensprint("handleUniversalLink has -- redirect:\(redirect)")
            webContainerView.showLoading(true)
            webContainerView.showError(false)
        }else if newUrl.absoluteString.range(of: "aigensRedirect/") != nil, let redirect = newUrl.absoluteString.components(separatedBy:"aigensRedirect/").last, !redirect.isEmpty {
            aigensprint("handleUniversalLink has -- aigensRedirect:\(redirect)")
            webContainerView.showLoading(true)
            webContainerView.showError(false)
        }

        webView?.load(rUrl)
    }

    @objc func handleUniversalLink(notification: NSNotification) {
        guard let object = notification.object as? [String: Any?] else {
            return
        }

        aigensprint("handleUniversalLink url:\(object)")
        guard var url = object["url"] as? URL else {
            return
        }

        url = decodeURIComponent(url);


        if universalLink.isEmpty || (!url.absoluteString.starts(with: universalLink) && !universalLink.contains("aigens=true") && !universalLink.contains("aigens/true")) {
            return;
        }


        let rUrl = URLRequest(url: url)

        let newUrl = url;
        if newUrl.absoluteString.range(of: "redirect=") != nil, let redirect = newUrl.absoluteString.components(separatedBy:"redirect=").last, !redirect.isEmpty {
            aigensprint("handleUniversalLink has -- redirect:\(redirect)")
            webContainerView.showLoading(true)
            webContainerView.showError(false)
        }else if newUrl.absoluteString.range(of: "aigensRedirect/") != nil, let redirect = newUrl.absoluteString.components(separatedBy:"aigensRedirect/").last, !redirect.isEmpty {
            aigensprint("handleUniversalLink has -- aigensRedirect:\(redirect)")
            webContainerView.showLoading(true)
            webContainerView.showError(false)
        }


        webView?.load(rUrl)

    }
    private func initView(){

        aigensprint("VC initView")

        //let bundle = Bundle(for: WebContainerViewController.self)
        //let containerView = WebContainerView()
        //let containerView = bundle.loadNibNamed("WebContainerView", owner: self, options: nil)?.first as! UIView

        self.view.addSubview(webContainerView)
        webContainerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        setupOptions(webContainerView)
        containerView.vc = self

//
//


//        let containerView = WebContainerView()
//        self.view = containerView
//
//        //containerView.frame = self.view!.bounds
//        containerView.backgroundColor = UIColor.red
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        let webview = self.webView
//        webview?.frame = containerView.webArea!.bounds
//        webview?.frame.size = containerView.webArea.frame.size
//        containerView.webArea.addSubview(self.webView!)
//


    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webContainerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }

    private func setupOptions(_ view: WebContainer) {
        if let theme = self.options?["themeColor"] as? String, let color = UIColor.getHex(hex: theme) {
            self.view.backgroundColor = color
            self.webView?.backgroundColor = color
            self.webView?.scrollView.backgroundColor = color
            view.setTheme(theme)
        }
        if let externalProtocols = options?["externalProtocols"] as? [String] {
            self.externalProtocols.append(contentsOf: externalProtocols)
        }

        if let addPaddingProtocols = options?["addPaddingProtocols"] as? [String] {
            self.addPaddingProtocols.append(contentsOf: addPaddingProtocols)
        }

    }

    private func decodeURIComponent(_ url: URL) -> URL {
        let str = url.absoluteString
        let urlStr = str.removingPercentEncoding ?? str
        return URL(string: urlStr) ?? url
    }

    private func decodeURIComponent(_ str: String) -> String {
        return str.removingPercentEncoding ?? str
    }

    public final func loadWebViewCustom() {

        //let bridge = self.bridge
        //let plugins = self.bridge["plugins"]


        let urlString = self.options?["url"] as? String;
//        urlString = "https://payment2.pizzahut.com.hk/v3/Payment/Completed?TransId=N224A2306130302&Code=4F19FC65-E099-4339-ADF4-3986EF539233"
//        urlString = "https://payment2.pizzahut.com.hk/v3/Payment/UserCancel?TransId=N224A2306130301&Code=44D4B103-4962-432E-A323-086D46F8BB6F"
//        urlString = "https://payment2.pizzahut.com.hk/v3/Payment/Completed?TransId=A224A2306131102&Code=104A53FB-053E-4FC1-870E-29D7B39AE2C5"

//        urlString = "https%3a%2f%2fpayment2.pizzahut.com.hk%2fv3%2fPayment%2fCompleted%3fTransId%3dA224A2306131102%26Code%3d104A53FB-053E-4FC1-870E-29D7B39AE2C5";
//
//        urlString = decodeURIComponent(urlString!)

        if(urlString == nil){
            return;
        }

        let url = URL(string: urlString!)

        let member = self.options?["member"] as? Dictionary<String, Any>
        self.universalLink = member?["universalLink"] as? String ?? ""

        CorePlugin.member = member
        let deeplink = self.options?["deeplink"] as? Dictionary<String, Any>
        CorePlugin.deeplink = deeplink

        if let debug = self.options?["debug"] as? Bool, debug == true {
            aigensDebug = debug
        }

        if let clearCache = self.options?["clearCache"] as? Bool, clearCache == true {
            self.clearCache()
        }

        //bridge.webViewDelegationHandler.willLoadWebview(webView)
        _ = webView?.load(URLRequest(url: url!))
        webView?.navigationDelegate = self

    }

    //this method overwrite parent to return a desc with custom config.json
    override open func instanceDescriptor() -> InstanceDescriptor {

        //print("WebContainerViewController custom instanceDescriptor")

        //let configLoc = Bundle.main.url(forResource: "capacitor.config", withExtension: "json")

        //default config paths
        var wwwLoc = Bundle.main.url(forResource: "public", withExtension: nil)
        var configLoc = Bundle.main.url(forResource: "capacitor.config", withExtension: "json")

        //if config is missing, it's a dynamic page, load config from sdk core
        if(configLoc == nil){
            configLoc = Bundle(for: WebContainerViewController.self).url(forResource: "capacitor.config", withExtension: "json")

            //www folder will be dynamic, set to anything is ok
            //wwwLoc = configLoc
            wwwLoc = FileManager.default.temporaryDirectory
        }


        let descriptor = InstanceDescriptor.init(at: wwwLoc!, configuration: configLoc, cordovaConfiguration: nil)

        descriptor.appendedUserAgentString = "AigensSDK"

        if var splashScreenPlugin = descriptor.pluginConfigurations["SplashScreen"] as? [String: Any] {
            splashScreenPlugin["launchShowDuration"] = 3
            splashScreenPlugin["launchAutoHide"] = true
            descriptor.pluginConfigurations["SplashScreen"] = splashScreenPlugin
        }

        return descriptor
    }

    deinit {
        aigensprint("WebContainerViewController deinit")
        NotificationCenter.default.removeObserver(self)
    }


}

extension WebContainerViewController: WKNavigationDelegate {
    // The force unwrap is part of the protocol declaration, so we should keep it.
    // swiftlint:disable:next implicitly_unwrapped_optional
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Reset the bridge on each navigation
//        self.bridge?.reset()
        webContainerView.showError(false)
        webContainerView.showLoading(true)
    }

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webContainerView.showError(false)
        webContainerView.showLoading(true)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // post a notification for any listeners
        NotificationCenter.default.post(name: .capacitorDecidePolicyForNavigationAction, object: navigationAction)

        // sanity check, these shouldn't ever be nil in practice
        guard let bridge = bridge, let navURL = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        aigensprint("navURL--:\(navURL)")
        if !universalLink.isEmpty && (navURL.absoluteString.starts(with: universalLink) || universalLink.contains("aigens=true") || universalLink.contains("aigens/true")) {

            if navURL.absoluteString.range(of: "redirect=") != nil, var redirect = navURL.absoluteString.components(separatedBy:"redirect=").last{
                if !redirect.starts(with: "http://") && !redirect.starts(with: "https://") {
                    redirect = "https://" + redirect
                }
                if let redirectUrl = URL(string: redirect) {
                    self.redirectLink = redirect
                    aigensprint("navURL-- redirect:\(redirect)")
                    webContainerView.showLoading(true)
                    webContainerView.showError(false)
                    let rUrl = URLRequest(url: redirectUrl)
                    webView.load(rUrl)
                    decisionHandler(.cancel)
                    return;
                }
            }
            
            if navURL.absoluteString.range(of: "aigensRedirect/") != nil, var redirect = navURL.absoluteString.components(separatedBy:"aigensRedirect/").last, !redirect.isEmpty{
                if !redirect.starts(with: "http://") && !redirect.starts(with: "https://") {
                    redirect = "https://" + redirect
                }
                if let redirectUrl = URL(string: redirect) {
                    self.redirectLink = redirect
                    aigensprint("navURL-- aigensRedirect:\(redirect)")
                    webContainerView.showLoading(true)
                    webContainerView.showError(false)
                    let rUrl = URLRequest(url: redirectUrl)
                    webView.load(rUrl)
                    decisionHandler(.cancel)
                    return;
                }
            }

        }

        var isCanOpen = false
        if externalProtocols.count > 0 {
            externalProtocols.forEach { (url) in
                if (navURL.absoluteString.starts(with: url)) {
                    isCanOpen = UIApplication.shared.canOpenURL(navURL) ;
                    return;
                }
            }
        }

        if isCanOpen {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(navURL, options: [:], completionHandler: nil);
            } else {
                UIApplication.shared.openURL(navURL)
            }
            decisionHandler(.cancel)
            return;
        }


        // first, give plugins the chance to handle the decision
//        for pluginObject in bridge.plugins {
//            let plugin = pluginObject.value
//            let selector = NSSelectorFromString("shouldOverrideLoad:")
//            if plugin.responds(to: selector) {
//                let shouldOverrideLoad = plugin.shouldOverrideLoad(navigationAction)
//                if shouldOverrideLoad != nil {
//                    if shouldOverrideLoad == true {
//                        decisionHandler(.cancel)
//                        return
//                    } else if shouldOverrideLoad == false {
//                        decisionHandler(.allow)
//                        return
//                    }
//                }
//            }
//        }

        // next, check if this is covered by the allowedNavigation configuration
        if let host = navURL.host, bridge.config.shouldAllowNavigation(to: host) {
            decisionHandler(.allow)
            return
        }

        // otherwise, is this a new window or a main frame navigation but to an outside source
//        let toplevelNavigation = (navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == true)
//        if navURL.absoluteString.contains(bridge.config.serverURL.absoluteString) == false, toplevelNavigation {
//            // disallow and let the system handle it
//            if UIApplication.shared.applicationState == .active {
//                UIApplication.shared.open(navURL, options: [:], completionHandler: nil)
//            }
//            decisionHandler(.cancel)
//            return
//        }

        // fallthrough to allowing it
        decisionHandler(.allow)
    }


    // The force unwrap is part of the protocol declaration, so we should keep it.
    // swiftlint:disable:next implicitly_unwrapped_optional
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        if case .initialLoad(let isOpaque) = webViewLoadingState {
//            webView.isOpaque = isOpaque
//            webViewLoadingState = .subsequentLoad
//        }

        if let navURL = webView.url, isPaddingUrl(navURL) {
            webView.evaluateJavaScript("""
            let bg = document.getElementsByTagName('body');
            if (bg && bg[0]) {
                bg[0].style.paddingTop = "\(UIDevice.xp_statusBarHeight())px";
            }

            let app = document.querySelector('body>#app');
            if (app && window) {
               if (window.getComputedStyle(app).position == 'absolute') {
                    app.style.top = "\(UIDevice.xp_statusBarHeight())px";
                }
            }

            """)
        }

        webContainerView.showLoading(false)
        webContainerView.showError(false)
        CAPLog.print("⚡️  WebView loaded:\(webView.url)")
    }

    // The force unwrap is part of the protocol declaration, so we should keep it.
    // swiftlint:disable:next implicitly_unwrapped_optional
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CAPLog.print("⚡️  WebView failed to load")
        CAPLog.print("⚡️  Error: " + error.localizedDescription)
        webContainerView.showLoading(false)

        if isFirstError {
            CAPLog.print("⚡️  WebView failed didFail reload")
            isFirstError = false
            // reload
            webView.reload()
            return;
        }

        let e = error as NSError
        if (e.code == NSURLErrorCancelled || e.code == -999) {
        }else {
            webContainerView.showError(true, error.localizedDescription)
        }

    }

//    // The force unwrap is part of the protocol declaration, so we should keep it.
//    // swiftlint:disable:next implicitly_unwrapped_optional
//    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        CAPLog.print("⚡️  WebView failed provisional navigation")
//        CAPLog.print("⚡️  Error: " + error.localizedDescription)
//
//        webContainerView.showLoading(false)
//
//        if isFirstError {
//            CAPLog.print("⚡️  WebView failed provisional reload")
//            isFirstError = false
//            // reload
//            webView.reload()
//            return;
//        }
//
//        let e = error as NSError
//        if (e.code == NSURLErrorCancelled || e.code == -999) {
//        }else {
//            webContainerView.showError(true, error.localizedDescription)
//        }
//
//    }

    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}

extension UIColor {
    static func getHex(hex: String, _ alpha: CGFloat = 1.0) -> UIColor? {
        guard !hex.isEmpty && hex.hasPrefix("#") else { return nil }
        var rgbValue: UInt32 = 0
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        guard scanner.scanHexInt32(&rgbValue) else { return nil }
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
            blue: CGFloat((rgbValue & 0xFF)) / 255.0,
            alpha: alpha);
    }
}


extension UIDevice {

    /// 顶部安全区高度
    static func xp_safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0;
    }

    /// 底部安全区高度
    static func xp_safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }

    /// 顶部状态栏高度（包括安全区）
    static func xp_statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        CAPLog.print("navURL-- height:\(statusBarHeight)")
        return statusBarHeight
    }

    /// 导航栏高度
    static func xp_navigationBarHeight() -> CGFloat {
        return 44.0
    }

    /// 状态栏+导航栏的高度
    static func xp_navigationFullHeight() -> CGFloat {
        return UIDevice.xp_statusBarHeight() + UIDevice.xp_navigationBarHeight()
    }

    /// 底部导航栏高度
    static func xp_tabBarHeight() -> CGFloat {
        return 49.0
    }

    /// 底部导航栏高度（包括安全区）
    static func xp_tabBarFullHeight() -> CGFloat {
        return UIDevice.xp_tabBarHeight() + UIDevice.xp_safeDistanceBottom()
    }
}
