//
//  AigensSdkExecutor.swift
//  AigensSdkCore_Example
//
//  Created by 陈培爵 on 2025/4/1.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import AigensSdkCore

//import FirebaseAnalytics

private let sharedExecutor = AigensSdkExecutor()
@objc public class AigensSdkExecutor: NSObject {

    static var shared: AigensSdkExecutor {
        return sharedExecutor
    }
    
    public required override init() {
        super.init()
    }

}

extension AigensSdkExecutor: AnalyticsDelegate {
    
    public func logEvent(_ name: String, parameters: Dictionary<String, Any>?) {
        //Analytics.logEvent(name, parameters: parameters)
    }
    

}



