import Foundation

@objc public class WechatHK: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
