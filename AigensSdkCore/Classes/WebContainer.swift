//
//  WebContainer.swift
//  AigensSdkCore
//
//  Created by 陈培爵 on 2022/6/7.
//

import UIKit

class WebContainer: UIView {
    @IBOutlet weak var activity: UIActivityIndicatorView!

    @IBOutlet weak var errorWrapper: UIView!

    @IBOutlet weak var errorTextView: UITextView!

    public weak var vc: WebContainerViewController?

    public func setTheme(_ color: String) {
        if let color = UIColor.getHex(hex: color) {
            self.backgroundColor = color
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        aigensprint("awakeFromNib")
    }

    private func hiddenSelf() {
        self.alpha = 1.0
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        })
    }

    public func showLoading(_ show: Bool) {
        if show {
            self.alpha = 1.0
            activity.isHidden = false
            activity.backgroundColor = .clear
            activity.color = .darkGray
            activity.alpha = 1.0
        }else {
            hiddenSelf()
            activity?.isHidden = true
        }
    }
    public func showError(_ show: Bool, _ error: String? = nil) {
        if let e = error {
            errorTextView?.text = e
        }
        if show {
            errorWrapper?.isHidden = false
            self.alpha = 1.0
        }else {
            errorWrapper?.isHidden = true
            self.alpha = 0
        }

    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func dismiss(_ sender: UIButton) {
        self.vc?.dismiss(animated: true);
    }

    @IBAction func reload(_ sender: UIButton) {
        self.vc?.webView?.reload()
    }
}

extension WebContainer {
    class func webContainer() -> WebContainer {
        let bundle = Bundle(for: WebContainer.self)
        return bundle.loadNibNamed("WebContainer", owner: self, options: nil)?.first as! WebContainer
    }
}
