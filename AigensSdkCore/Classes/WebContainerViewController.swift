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

    // {themeColor: "#xxxxxx"}
    public var options: Dictionary<String, Any>?
    
    var externalProtocols: [String] = [
        "octopus://", "alipay://", "alipays://", "alipayhk://", "https://itunes.apple.com", "tel:", "mailto:", "itms-apps://itunes.apple.com", "https://apps.apple.com", "payme://"
    ]
    let containerView = WebContainer.webContainer()
    var webContainerView: WebContainer {
            return containerView
    }
    override open func viewDidLoad() {

        print("WebContainerViewController viewDidLoad")

        self.becomeFirstResponder()
        loadWebViewCustom()
        initView()
        
    }
    
    private func initView(){
        
        print("VC initView")
        
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
        
    }
    
    public final func loadWebViewCustom() {

        //let bridge = self.bridge
        //let plugins = self.bridge["plugins"]


        let urlString = self.options?["url"] as? String;

        if(urlString == nil){
            return;
        }

        let url = URL(string: urlString!)
        
        let member = self.options?["member"] as? Dictionary<String, Any>
        
        CorePlugin.member = member
        
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


        return descriptor
    }
    
    deinit {
        print("WebContainerViewController deinit")
    }

    
}

extension WebContainerViewController: WKNavigationDelegate {
    // The force unwrap is part of the protocol declaration, so we should keep it.
    // swiftlint:disable:next implicitly_unwrapped_optional
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Reset the bridge on each navigation
//        self.bridge?.reset()
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
        let toplevelNavigation = (navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == true)
        if navURL.absoluteString.contains(bridge.config.serverURL.absoluteString) == false, toplevelNavigation {
            // disallow and let the system handle it
            if UIApplication.shared.applicationState == .active {
                UIApplication.shared.open(navURL, options: [:], completionHandler: nil)
            }
            decisionHandler(.cancel)
            return
        }

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
        webContainerView.showLoading(false)
        webContainerView.showError(false)
        CAPLog.print("⚡️  WebView loaded")
    }
    
    // The force unwrap is part of the protocol declaration, so we should keep it.
    // swiftlint:disable:next implicitly_unwrapped_optional
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        if case .initialLoad(let isOpaque) = webViewLoadingState {
//            webView.isOpaque = isOpaque
//            webViewLoadingState = .subsequentLoad
//        }
        webContainerView.showLoading(false)
        
        webContainerView.showError(true, error.localizedDescription)
        CAPLog.print("⚡️  WebView failed to load")
        CAPLog.print("⚡️  Error: " + error.localizedDescription)
    }
    
    // The force unwrap is part of the protocol declaration, so we should keep it.
    // swiftlint:disable:next implicitly_unwrapped_optional
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webContainerView.showLoading(false)
        // cancel
        let e = error as NSError
        if (e.code == NSURLErrorCancelled || e.code == -999) {
            webContainerView.showError(false)
        }
        CAPLog.print("⚡️  WebView failed provisional navigation")
        CAPLog.print("⚡️  Error: " + error.localizedDescription)
        webContainerView.showError(true, error.localizedDescription)
    }
    
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
