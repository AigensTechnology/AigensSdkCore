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
//        url = "https://fairwood-uat-v4.order.place/order/brand/600001/order-history"
        
//        url = "https://test-sdk-1234.firebaseapp.com/crm/brand/600001/home?nocache=true&mode=takeaway&storeId=600002&back=false&t=3"
        
        
//        url = "https://test-sdk-1234.firebaseapp.com/order/store/60288/mode/takeaway?nocache=true"
        
//        url = "https://fairwood-uat-v4.order.place/crm/brand/600001/home?nocache=true&mode=takeaway&storeId=600002&back=false"
        // url = "https://fdsfefs/fsef"
        
        let bridgeVC = WebContainerViewController()
        
        var options = [String: Any]()
        options["url"] = url
        
        let member:Dictionary<String, Any> = [
        
            "memberCode" : "<crmMemberId>",
            "source" : "<merchant>",
            "sessionId" : "sessionId",
            "deviceId":"peijue-test-iphone",
            "universalLink": "https://yoshinoyaapp.aigens.com/yoshinoyaapp/wechatpay/*",
            "appleMerchantId": ""
        ]
        
        let deeplink:Dictionary<String, Any> = [
            
            "addItemId" : "<itemId>",
            "addDiscountCode" : "<discountCode>",
            "addOfferId" : "<offerId>"
            
        ]
        
        options["member"] = member
        options["deeplink"] = deeplink
//        options["themeColor"] = "#144372"
        
        bridgeVC.options = options;
        
        bridgeVC.modalPresentationStyle = .fullScreen
        self.present(bridgeVC, animated: true);
        
    }

}

