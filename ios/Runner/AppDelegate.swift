import Flutter
import UIKit

// DevToDev Bridge for robust SDK integration
class DevToDevBridge {
    private let possibleClassNames = [
        "DevToDev",
        "DevToDevSDK.DevToDev",
        "DevToDevAnalytics",
        "DTDAnalytics"
    ]

    private var devToDevClass: AnyClass?
    private var isInitialized = false

    init() {
        findDevToDevClass()
    }

    private func findDevToDevClass() {
        for className in possibleClassNames {
            if let clazz = NSClassFromString(className) {
                devToDevClass = clazz
                print("DevToDev iOS: Found SDK class: \(className)")
                break
            }
        }

        if devToDevClass == nil {
            print("DevToDev iOS: No SDK class found among: \(possibleClassNames)")
        }
    }

    private func isDevToDevAvailable() -> Bool {
        return devToDevClass != nil
    }

    func initialize(appId: String, secretKey: String? = nil, apiKey: String? = nil) -> Bool {
        guard let clazz = devToDevClass else {
            print("DevToDev iOS: SDK not available for initialization")
            return false
        }

        // Try different initialization methods
        let initMethods: [(Selector, [Any])] = [
            (NSSelectorFromString("initializeWithAppId:"), [appId]),
            (NSSelectorFromString("initialize:"), [appId]),
            (NSSelectorFromString("initializeWithAppId:secretKey:"), secretKey != nil ? [appId, secretKey!] : []),
            (NSSelectorFromString("startWithAppId:"), [appId])
        ]

        for (selector, args) in initMethods {
            if args.isEmpty && secretKey != nil { continue }

            if clazz.responds(to: selector) {
                switch args.count {
                case 1:
                    _ = clazz.perform(selector, with: args[0])
                case 2:
                    _ = clazz.perform(selector, with: args[0], with: args[1])
                default:
                    _ = clazz.perform(selector)
                }

                isInitialized = true
                print("DevToDev iOS: Initialized successfully with selector: \(selector)")
                return true
            }
        }

        print("DevToDev iOS: Failed to initialize - no suitable method found")
        return false
    }

    func logEvent(name: String, parameters: [String: Any]? = nil) -> Bool {
        guard let clazz = devToDevClass else { return false }

        let eventMethods: [(Selector, [Any])] = [
            (NSSelectorFromString("customEvent:parameters:"), parameters != nil ? [name, parameters!] : []),
            (NSSelectorFromString("customEvent:"), [name]),
            (NSSelectorFromString("logEvent:parameters:"), parameters != nil ? [name, parameters!] : []),
            (NSSelectorFromString("logEvent:"), [name])
        ]

        for (selector, args) in eventMethods {
            if args.isEmpty && parameters != nil { continue }

            if clazz.responds(to: selector) {
                switch args.count {
                case 1:
                    _ = clazz.perform(selector, with: args[0])
                case 2:
                    _ = clazz.perform(selector, with: args[0], with: args[1])
                default:
                    continue
                }

                print("DevToDev iOS: Event logged successfully with selector: \(selector)")
                return true
            }
        }

        print("DevToDev iOS: Failed to log event - no suitable method found")
        return false
    }

    func setUserId(_ userId: String) -> Bool {
        guard let clazz = devToDevClass else { return false }

        let selector = NSSelectorFromString("setUserId:")
        if clazz.responds(to: selector) {
            _ = clazz.perform(selector, with: userId)
            print("DevToDev iOS: UserId set successfully")
            return true
        }

        print("DevToDev iOS: Failed to set userId - method not found")
        return false
    }

    func clearUserId() -> Bool {
        guard let clazz = devToDevClass else { return false }

        // Try clearUserId first, then setUserId with nil
        let selectors = [
            NSSelectorFromString("clearUserId"),
            NSSelectorFromString("setUserId:")
        ]

        for selector in selectors {
            if clazz.responds(to: selector) {
                if selector == NSSelectorFromString("clearUserId") {
                    _ = clazz.perform(selector)
                } else {
                    _ = clazz.perform(selector, with: nil)
                }
                print("DevToDev iOS: UserId cleared successfully")
                return true
            }
        }

        print("DevToDev iOS: Failed to clear userId - no suitable method found")
        return false
    }

    func setUserProperty(name: String, value: String) -> Bool {
        guard let clazz = devToDevClass else { return false }

        let selector = NSSelectorFromString("setUserProperty:value:")
        if clazz.responds(to: selector) {
            _ = clazz.perform(selector, with: name, with: value)
            print("DevToDev iOS: User property set successfully")
            return true
        }

        print("DevToDev iOS: Failed to set user property - method not found")
        return false
    }

    func setTrackingEnabled(_ enabled: Bool) -> Bool {
        guard let clazz = devToDevClass else { return false }

        let selector = NSSelectorFromString("setTrackingEnabled:")
        if clazz.responds(to: selector) {
            _ = clazz.perform(selector, with: enabled)
            print("DevToDev iOS: Tracking enabled set successfully")
            return true
        }

        print("DevToDev iOS: Failed to set tracking enabled - method not found")
        return false
    }

    func logScreenView(screenName: String, screenClass: String? = nil) -> Bool {
        guard let clazz = devToDevClass else { return false }

        let selectors: [(Selector, [Any])] = [
            (NSSelectorFromString("logScreenView:screenClass:"), screenClass != nil ? [screenName, screenClass!] : []),
            (NSSelectorFromString("logScreenView:"), [screenName])
        ]

        for (selector, args) in selectors {
            if args.isEmpty && screenClass != nil { continue }

            if clazz.responds(to: selector) {
                switch args.count {
                case 1:
                    _ = clazz.perform(selector, with: args[0])
                case 2:
                    _ = clazz.perform(selector, with: args[0], with: args[1])
                default:
                    continue
                }

                print("DevToDev iOS: Screen view logged successfully")
                return true
            }
        }

        print("DevToDev iOS: Failed to log screen view - no suitable method found")
        return false
    }
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let devToDevBridge = DevToDevBridge()

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
      guard let self = self else {
        result(FlutterError(code: "INTERNAL_ERROR", message: "Self is nil", details: nil))
        return
      }

      switch call.method {
      case "initialize":
        if let args = call.arguments as? [String: Any],
           let appId = args["appId"] as? String {
          let secretKey = args["secretKey"] as? String
          let apiKey = args["apiKey"] as? String

          print("DevToDev iOS: Initialize called with appId: \(appId)")
          _ = self.devToDevBridge.initialize(appId: appId, secretKey: secretKey, apiKey: apiKey)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing appId", details: nil))
        }

      case "logEvent":
        if let args = call.arguments as? [String: Any],
           let eventName = args["name"] as? String {
          let parameters = args["parameters"] as? [String: Any]
          print("DevToDev iOS: Event \(eventName) with params: \(parameters ?? [:])")
          _ = self.devToDevBridge.logEvent(name: eventName, parameters: parameters)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing event name", details: nil))
        }

      case "setUserId":
        if let args = call.arguments as? [String: Any],
           let userId = args["userId"] as? String {
          print("DevToDev iOS: Setting userId: \(userId)")
          _ = self.devToDevBridge.setUserId(userId)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing userId", details: nil))
        }

      case "clearUserId":
        print("DevToDev iOS: Clearing userId")
        _ = self.devToDevBridge.clearUserId()
        result(nil)

      case "setUserProperty":
        if let args = call.arguments as? [String: Any],
           let name = args["name"] as? String,
           let value = args["value"] as? String {
          print("DevToDev iOS: Setting user property: \(name) = \(value)")
          _ = self.devToDevBridge.setUserProperty(name: name, value: value)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing name or value", details: nil))
        }

      case "setTrackingEnabled":
        if let args = call.arguments as? [String: Any],
           let enabled = args["enabled"] as? Bool {
          print("DevToDev iOS: Setting tracking enabled: \(enabled)")
          _ = self.devToDevBridge.setTrackingEnabled(enabled)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing enabled flag", details: nil))
        }

      case "logScreenView":
        if let args = call.arguments as? [String: Any],
           let screenName = args["screenName"] as? String {
          let screenClass = args["screenClass"] as? String
          print("DevToDev iOS: Logging screen view: \(screenName)")
          _ = self.devToDevBridge.logScreenView(screenName: screenName, screenClass: screenClass)
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
