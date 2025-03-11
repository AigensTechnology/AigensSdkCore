//
//  SecondWebContainerView.swift
//  AigensSdkCore
//
//  Created by 陈培爵 on 2025/3/10.
//

import WebKit

@objc public protocol SecondWebContainerDelegate: AnyObject {
    func secondWebContainerViewYuuLoginCallback(view: UIView, data: [String: Any])
}

@objc open class SecondWebContainerView: UIView {
    // 暴露给外部使用的 WebView
    public let webView: WKWebView
    
    private let messageHandlerName = "YuuLoginHandler"
    private let messageHandlerName2 = "yuuLoginHandler"
    private var messageHandler: SecondWebViewMessageHandler?

    public weak var delegate: SecondWebContainerDelegate?
    
    private var currentUrl: String?
    public var serviceName: String?
    override init(frame: CGRect) {
        // 创建 WebView 配置
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height), configuration: webConfiguration)

        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // 添加 WebView 并设置约束
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 设置默认属性
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0

        // 禁用双击缩放
        let disableDoubleTapScript = """
        var script = document.createElement('script');
        script.textContent = 'document.documentElement.style.webkitTouchCallout = "none";';
        document.documentElement.appendChild(script);
        """
        let userScript = WKUserScript(source: disableDoubleTapScript,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)

    }

    deinit {

        print("SecondWebContainerView deinit")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: messageHandlerName)
    }
    
    public func loadUrl(urlString: String) {
        guard let url = URL(string: urlString) else {
            aigensprint("secondview Invalid URL: \(urlString)")
            return
        }
        
        messageHandler = SecondWebViewMessageHandler(serviceName: self.serviceName, callback: { [weak self] message in
            guard let s = self else { return }
            self?.delegate?.secondWebContainerViewYuuLoginCallback(view: s, data: message)
        })
        
        webView.configuration.userContentController.add(messageHandler!, name: messageHandlerName)
        webView.configuration.userContentController.add(messageHandler!, name: messageHandlerName2)
        if let name = serviceName {
            webView.configuration.userContentController.add(messageHandler!, name: name)
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    
    public func setCustomFrame(_ frame: CGRect) {
        self.frame = frame
        layoutIfNeeded()
    }
}

private class SecondWebViewMessageHandler: NSObject, WKScriptMessageHandler {
    private let callback: ([String: Any]) -> Void
    
    private let messageHandlerName = "YuuLoginHandler"
    private let messageHandlerName2 = "yuuLoginHandler"
    private var serviceName: String?
    init(serviceName: String?, callback: @escaping ([String: Any]) -> Void) {
        self.callback = callback
        self.serviceName = serviceName
    }

    func userContentController(_ userContentController: WKUserContentController, 
                              didReceive message: WKScriptMessage) {
//        print("jason message:\(message.name)")
        
        guard (message.name == messageHandlerName || message.name == messageHandlerName2 || message.name == serviceName ?? ""),
              let messageBody = message.body as? [String: Any] else {
            return
        }
        
        aigensprint("Received credit card token: \(messageBody)")
        callback(messageBody)
    }
}

// MARK: - WKNavigationDelegate 实现
extension SecondWebContainerView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let navURL = navigationAction.request.url {
            currentUrl = navURL.absoluteString
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let url = self.currentUrl, url == "about:blank" {
                    self.delegate?.secondWebContainerViewYuuLoginCallback(view: self, data: ["cancel": true])
                }
            }
            
        }
        
        
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("jason secondnavURL didFinish")
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        print("jason secondnavURL didFail")
        self.removeFromSuperview()
    }
}


