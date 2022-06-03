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

    public var options: Dictionary<String, Any>?

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

        let containerView = WebContainerView()
        
        
        containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let webview = self.webView
        webview?.frame = containerView.webArea!.bounds
        containerView.webArea.addSubview(self.webView!)
        
        containerView.vc = self
        
        self.view = containerView
        
        
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


    }
}
