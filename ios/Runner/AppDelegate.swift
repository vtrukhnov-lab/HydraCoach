import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    let purchaseConnectorChannel = FlutterMethodChannel(
      name: "hydracoach.purchase_connector",
      binaryMessenger: controller.binaryMessenger
    )

    let devToDevChannel = FlutterMethodChannel(
      name: "devtodev_analytics",
      binaryMessenger: controller.binaryMessenger
    )

    purchaseConnectorChannel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "initializePurchaseConnector":
        // TODO: Integrate Purchase Connector after resolving dependencies
        result("Purchase Connector mock initialized (pending native integration)")

      case "startPurchaseConnector":
        // TODO: Start Purchase Connector after resolving dependencies
        result("Purchase Connector mock started (pending native integration)")

      case "stopPurchaseConnector":
        // TODO: Stop Purchase Connector after resolving dependencies
        result("Purchase Connector mock stopped (pending native integration)")

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    devToDevChannel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "initialize":
        // DevToDev iOS integration - TODO: Add native DevToDev iOS SDK
        if let args = call.arguments as? [String: Any],
           let appId = args["appId"] as? String {
          print("DevToDev iOS: Initialize called with appId: \(appId)")
          // TODO: Call DevToDev iOS SDK initialization
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing appId", details: nil))
        }

      case "logEvent":
        if let args = call.arguments as? [String: Any],
           let eventName = args["name"] as? String {
          let parameters = args["parameters"] as? [String: Any] ?? [:]
          print("DevToDev iOS: Event \(eventName) with params: \(parameters)")
          // TODO: Call DevToDev iOS SDK logEvent
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing event name", details: nil))
        }

      case "setUserId":
        if let args = call.arguments as? [String: Any],
           let userId = args["userId"] as? String {
          print("DevToDev iOS: Setting userId: \(userId)")
          // TODO: Call DevToDev iOS SDK setUserId
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing userId", details: nil))
        }

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
