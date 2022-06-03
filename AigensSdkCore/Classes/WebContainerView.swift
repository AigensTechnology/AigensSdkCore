//
//  WebContainerView.swift
//  AigensSdkCore
//
//  Created by Peter Liu on 3/6/2022.
//

import UIKit

class WebContainerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initRaw()
    }
    
    required init?(coder decoder: NSCoder){
        super.init(coder: decoder)
        initRaw()
    }
    
    private func initRaw(){
        print("WebContainerView init")
    }

}
