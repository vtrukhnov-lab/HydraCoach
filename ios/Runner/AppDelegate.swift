import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController

    // Purchase Connector Channel
    let purchaseConnectorChannel = FlutterMethodChannel(
      name: "hydracoach.purchase_connector",
      binaryMessenger: controller.binaryMessenger
    )

    // DevToDev Channel
    let devToDevChannel = FlutterMethodChannel(
      name: "devtodev_analytics",
      binaryMessenger: controller.binaryMessenger
    )

    // Purchase Connector Handler
    purchaseConnectorChannel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "initializePurchaseConnector":
        // Purchase Connector integration
        result("Purchase Connector initialized")

      case "startPurchaseConnector":
        result("Purchase Connector started")

      case "stopPurchaseConnector":
        result("Purchase Connector stopped")

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    // DevToDev Handler
    devToDevChannel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "initialize":
        if let args = call.arguments as? [String: Any],
           let appId = args["appId"] as? String {
          print("DevToDev iOS: Initialize called with appId: \(appId)")
          // DevToDev SDK initialization would go here
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing appId", details: nil))
        }

      case "logEvent":
        if let args = call.arguments as? [String: Any],
           let eventName = args["name"] as? String {
          let parameters = args["parameters"] as? [String: Any]
          print("DevToDev iOS: Event \(eventName) with params: \(parameters ?? [:])")
          // DevToDev event logging would go here
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing event name", details: nil))
        }

      case "setUserId":
        if let args = call.arguments as? [String: Any],
           let userId = args["userId"] as? String {
          print("DevToDev iOS: Setting userId: \(userId)")
          // DevToDev user ID setting would go here
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing userId", details: nil))
        }

      case "clearUserId":
        print("DevToDev iOS: Clearing userId")
        // DevToDev clear user ID would go here
        result(nil)

      case "setUserProperty":
        if let args = call.arguments as? [String: Any],
           let name = args["name"] as? String,
           let value = args["value"] as? String {
          print("DevToDev iOS: Setting user property: \(name) = \(value)")
          // DevToDev user property setting would go here
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing name or value", details: nil))
        }

      case "setTrackingEnabled":
        if let args = call.arguments as? [String: Any],
           let enabled = args["enabled"] as? Bool {
          print("DevToDev iOS: Setting tracking enabled: \(enabled)")
          // DevToDev tracking enable/disable would go here
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing enabled flag", details: nil))
        }

      case "logScreenView":
        if let args = call.arguments as? [String: Any],
           let screenName = args["screenName"] as? String {
          let screenClass = args["screenClass"] as? String
          print("DevToDev iOS: Logging screen view: \(screenName)")
          // DevToDev screen view logging would go here
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing screenName", details: nil))
        }

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}