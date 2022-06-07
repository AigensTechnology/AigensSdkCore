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
        
        
        let bridgeVC = WebContainerViewController()
        
        var options = [String: Any]()
        options["url"] = url
        
        let member:Dictionary<String, Any> = [
        
            "memberCode" : "<crmMemberId>",
            "source" : "<merchant>",
            "sessionId" : "<sessionId>"
        ]
        
        options["member"] = member
        options["themeColor"] = "#144372"
        
        bridgeVC.options = options;
        
        bridgeVC.modalPresentationStyle = .fullScreen
        self.present(bridgeVC, animated: true);
        
    }

}

