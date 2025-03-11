//
//  ViewController.swift
//  AigensSdkCore
//
//  Created by Peter Liu on 05/30/2022.
//  Copyright (c) 2022 Peter Liu. All rights reserved.
//

import UIKit
import AigensSdkCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openClicked(_ sender: Any) {
        
        var url = "https://scantest.aigens.com/scan?code=c3RvcmU9NTAwJnNwb3Q9MSZwYWdlPWJ5b2Q="
        
        url = "https://fairwood-uat-v4.order.place/order/store/600002/mode/catering?nocache=true"
        url = "https://fairwood-uat-v4.order.place/crm/brand/600001/home?nocache=true&mode=takeaway&storeId=600002"
        
        url = "https://fairwood-uat-v4.order.place/order/store/60288/mode/dinein"
        
        url = "https://test.order.place/crm/brand/500001/directory"
//        url = "https://fairwood-uat-v4.order.place/order/brand/600001/order-history"
        
//        url = "https://test-sdk-1234.firebaseapp.com/crm/brand/600001/home?nocache=true&mode=takeaway&storeId=600002&back=false&t=3"
        
        
//        url = "https://test-sdk-1234.firebaseapp.com/order/store/60288/mode/takeaway?nocache=true"
        
//        url = "https://fairwood-uat-v4.order.place/crm/brand/600001/home?nocache=true&mode=takeaway&storeId=600002&back=false"
        // url = "https://fdsfefs/fsef"
//        url = "https://fairwood-uat-v4.order.place/home/store/60288?mode=catering"
        
//        url = "https://fairwood-uat-v4.order.place/order/store/60288/mode/takeaway"
        
        
//        url = "http://localhost:4200/home/store/600002?mode=catering"
        
//        url = "http://localhost:4200/order/store/80039/mode/takeaway"
//        url = "http://localhost:4200/home/store/5669108628586496(modal:directory/popup)?mode=dinein&advertisement=true"
        
        url = "https://fairwood.order.place/order/store/600002/mode/catering"
        
        url = "https://fairwood.order.place/crm/brand/600001/directory"
        
        url = "https://test.order.place/crm/brand/220000/directory?locale=zh&nocache=true"
        url = "https://fairwood-uat-v4.order.place/order/store/600002/order/f19b7ffa-fb8d-4dcb-9546-b1b0c6e141c4";
        
        
        url = "https://fairwood-uat-v4.order.place/crm/brand/600001/directory?brandId=600001";
        
        url = "https://fairwood.order.place/crm/brand/600001/directory"
        
        // url = "http://192.168.1.108:4200/crm/brand/599961624702976/home";
        
//        url = "http://192.168.1.108:4200/crm/brand/600001/directory?brandId=600001";
//        url = "http://192.168.100.66:4200/crm/brand/600001/directory";
        
//        url = "https://fairwood-uat-v4.order.place/order/store/600002/mode/catering?brandId=600001"
        
        let bridgeVC = WebContainerViewController()
        
        var options = [String: Any]()
        options["url"] = url
        
//        yoshinoyaapp.aigens.com
        
//        {memberCode=MEM-42244-6X4H2Q, phone=92808724, universalLink=https://app2uat.club100.hk/app, name=Garyon Wong, language=zh, source=cdc, sessionId=MEM-42244-6X4H2Q, deviceId=8395bd1d63319b9f, email=garyon.wong@aigens.com, age=0, memberId=MEM-42244-6X4H2Q}
        
        let member:Dictionary<String, Any> = [
        
            "memberCode" : "MEM-42244-6X4H2Q",
            "source" : "cdc",
            "sessionId" : "MEM-42244-6X4H2Q",
            "deviceId":"peijue-test-iphone2-cdc",
            "universalLink": "https://yoshinoyaapp.aigens.com/yoshinoyaapp/wechatpay/*",
//            "universalLink":"fairwoodtestapp://test",
            "appleMerchantId": "",
            "appScheme": "fairwoodtestappprd://test"
        ]
        
        let deeplink:Dictionary<String, Any> = [
            
            "addItemId" : "<itemId>",
            "addDiscountCode" : "<discountCode>",
            "addOfferId" : "<offerId>"
            
        ]
        
        options["member"] = member
        options["deeplink"] = deeplink
        
        options["debug"] = true
        options["clearCache"] = true
        
//        options["themeColor"] = "#144372"
        
        bridgeVC.options = options;
        
        WebContainerViewController.closeCB = {
            (result: Any?) in
            print("closeCB:\(result)")
        }
        
        bridgeVC.modalPresentationStyle = .fullScreen
        self.present(bridgeVC, animated: true);
        
        
        // open second view
//        openSecondView(firstview: bridgeVC)
    }
    
    private func openSecondView(firstview: WebContainerViewController) {
        let secondView = SecondWebContainerView()
        secondView.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            
            firstview.insertView(secondView)
            let url = "https://www.google.com.hk/"
            secondView.loadUrl(urlString: url)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            secondView.removeFromSuperview()
        }
    }
    
}

extension ViewController: SecondWebContainerDelegate {
    public func secondWebContainerViewYuuLoginCallback(view: UIView, data: [String: Any]) {
        print("Jason Received credit card token:", data)
    }
}

