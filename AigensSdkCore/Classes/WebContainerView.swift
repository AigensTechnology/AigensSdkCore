//
//  WebContainerView.swift
//  AigensSdkCore
//
//  Created by Peter Liu on 3/6/2022.
//

import UIKit

class WebContainerView: UIView {


    
    override init(frame: CGRect){
        super.init(frame: frame)
        initRaw()
    }
    
    required init?(coder decoder: NSCoder){
        super.init(coder: decoder)
        //initRaw()
    }
    
    private func initRaw(){
        print("WebContainerView init")
        
        let bundle = Bundle(for: WebContainerView.self)
        let view = bundle.loadNibNamed("WebContainerView", owner: self, options: nil)?.first as? UIView
        
        view?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view?.frame = bounds
        addSubview(view!)
        
        
    }

    @IBAction func reloadClicked(_ sender: Any) {
        print("reloadClicked")
    }
    
    
    @IBAction func dismissClicked(_ sender: Any) {
        print("dismissClicked")
    }
}
