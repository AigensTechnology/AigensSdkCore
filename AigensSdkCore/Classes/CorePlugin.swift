import Foundation
import Capacitor
import UIKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CorePlugin)
public class CorePlugin: CAPPlugin {
    
    private let implementation = Core()
    public static var member: Dictionary<String, Any>?
    
    @objc func echo(_ call: CAPPluginCall) {

        print("CorePlugin echo")
        
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
        
       
    }
    
    @objc func dismiss(_ call: CAPPluginCall) {
        
        print("CorePlugin dismiss")

        DispatchQueue.main.async {
            self.bridge?.viewController?.dismiss(animated: true);
        }


        //let value = call.getString("value") ?? ""
        call.resolve([
            "success": true
            //"value": implementation.echo(value)
        ])
        
       
    }

    @objc func getMember(_ call: CAPPluginCall) {

        call.resolve([
            "member": CorePlugin.member!
        ])
    }

    @objc func finish(_ call: CAPPluginCall) {

        print("CorePlugin finish")
        
        DispatchQueue.main.async {
            self.bridge?.viewController?.dismiss(animated: true);
        }


        //let value = call.getString("value") ?? ""
        call.resolve([
            "success": true
            //"value": implementation.echo(value)
        ])
    }


    @objc func openBrowser(_ call: CAPPluginCall) {

        print("CorePlugin openBrowser")
        
        let url = call.getString("url")


        if(url == nil){
            return
        }
        
        let member = call.getObject("member")
        
        DispatchQueue.main.async {

            let bridgeVC = WebContainerViewController()

            var options = [String: AnyObject]()
            options["url"] = url as AnyObject;
            
            if(member != nil){
                options["member"] = member as AnyObject;
            }
            
            bridgeVC.options = options;

            bridgeVC.modalPresentationStyle = .fullScreen
            let currentVC = self.bridge?.viewController;
            currentVC?.present(bridgeVC, animated: true);
        }


        call.resolve([
            "success": true
            //"value": implementation.echo(value)
        ])
    }




    /*
    @objc func openAppSettings(_ call: CAPPluginCall) {
      guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
          return
      }

      DispatchQueue.main.async {
          if UIApplication.shared.canOpenURL(settingsUrl) {
              UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                  call.resolve()
              })
          }
      }
    }
    */





}
