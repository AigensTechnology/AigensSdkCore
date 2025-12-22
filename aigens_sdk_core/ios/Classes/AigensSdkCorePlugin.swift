import Flutter
import UIKit

// Note: This requires importing AigensSdkCore in the Flutter app's iOS project
// Add to Podfile: pod 'AigensSdkCore', '0.1.3'

@objc public class AigensSdkCorePlugin: NSObject, FlutterPlugin {
  private var pendingResult: FlutterResult?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "aigens_sdk_core", binaryMessenger: registrar.messenger())
    let instance = AigensSdkCorePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "openUrl":
      handleOpenUrl(call: call, result: result)
    case "dismiss":
      handleDismiss(call: call, result: result)
    case "isInstalledApp":
      handleIsInstalledApp(call: call, result: result)
    case "openExternalUrl":
      handleOpenExternalUrl(call: call, result: result)
    case "getIsProductionEnvironment":
      handleGetIsProductionEnvironment(call: call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleOpenUrl(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let url = args["url"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENT", message: "URL is required", details: nil))
      return
    }

    guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
      result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "Could not find root view controller", details: nil))
      return
    }

    // Store result for callback
    pendingResult = result

    // Dynamically load WebContainerViewController class
    // This requires the app to have AigensSdkCore as a dependency
    guard let webContainerClass = NSClassFromString("WebContainerViewController") as? UIViewController.Type else {
      result(FlutterError(
        code: "SDK_NOT_AVAILABLE",
        message: "AigensSdkCore not found. Please add 'pod AigensSdkCore' to your iOS Podfile",
        details: nil
      ))
      pendingResult = nil
      return
    }

    let bridgeVC = webContainerClass.init()

    // Build options dictionary
    var options: [String: Any] = [:]
    options["url"] = url

    if let member = args["member"] as? [String: Any] {
      options["member"] = member
    }

    if let deeplink = args["deeplink"] as? [String: Any] {
      options["deeplink"] = deeplink
    }

    if let debug = args["debug"] as? Bool {
      options["debug"] = debug
    }

    if let clearCache = args["clearCache"] as? Bool {
      options["clearCache"] = clearCache
    }

    if let externalProtocols = args["externalProtocols"] as? [String] {
      options["externalProtocols"] = externalProtocols
    }

    if let addPaddingProtocols = args["addPaddingProtocols"] as? [String] {
      options["addPaddingProtocols"] = addPaddingProtocols
    }

    if let excludedUniversalLinks = args["excludedUniversalLinks"] as? [String] {
      options["excludedUniversalLinks"] = excludedUniversalLinks
    }

    if let exitUniversalLinks = args["exitUniversalLinks"] as? [String] {
      options["exitUniversalLinks"] = exitUniversalLinks
    }

    // Set options using KVC
    bridgeVC.setValue(options, forKey: "options")

    // Set close callback using static property
    // WebContainerViewController has a static closeCB property: public static var closeCB: ((Any?) -> Void)?
    let closeCallback: (Any?) -> Void = { [weak self] (resultData: Any?) in
      guard let self = self else { return }
      var resultMap: [String: Any] = [:]
      if let r = resultData as? [String: Any] {
        resultMap = r
      } else {
        resultMap = ["closedData": [:]]
      }
      self.pendingResult?(resultMap)
      self.pendingResult = nil
    }

    // Set static closeCB property using runtime
    // Note: This requires the actual WebContainerViewController class to be available
    // We'll use objc_setAssociatedObject or KVC to set the static property
    let webContainerClass = type(of: bridgeVC)
    webContainerClass.setValue(closeCallback, forKey: "closeCB")

    bridgeVC.modalPresentationStyle = .fullScreen
    viewController.present(bridgeVC, animated: true, completion: nil)
  }

  private func handleDismiss(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
      result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "Could not find root view controller", details: nil))
      return
    }

    if let presentedVC = viewController.presentedViewController {
      presentedVC.dismiss(animated: true) {
        result(true)
      }
    } else {
      result(false)
    }
  }

  private func handleIsInstalledApp(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let urlString = args["key"] as? String,
          let url = URL(string: urlString) else {
      result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid URL scheme", details: nil))
      return
    }

    let canOpen = UIApplication.shared.canOpenURL(url)
    result(canOpen)
  }

  private func handleOpenExternalUrl(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let urlString = args["url"] as? String,
          let url = URL(string: urlString) else {
      result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid URL", details: nil))
      return
    }

    if !UIApplication.shared.canOpenURL(url) {
      result(FlutterError(code: "CANNOT_OPEN", message: "Cannot open URL: \(urlString)", details: nil))
      return
    }

    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, options: [:]) { success in
        result(success)
      }
    } else {
      let success = UIApplication.shared.openURL(url)
      result(success)
    }
  }

  private func handleGetIsProductionEnvironment(call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(true)
  }
}

