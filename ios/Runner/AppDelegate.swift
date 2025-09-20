import Flutter
import ObjectiveC.runtime
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

    let devToDevBridge = DevToDevBridge()

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
        guard
          let args = call.arguments as? [String: Any],
          let appId = args["appId"] as? String,
          let secretKey = args["secretKey"] as? String,
          let apiKey = args["apiKey"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing DevToDev credentials", details: nil))
          return
        }

        switch devToDevBridge.initialize(appId: appId, secretKey: secretKey, apiKey: apiKey) {
        case .success:
          result(nil)
        case .failure(let error):
          result(error)
        }

      case "logEvent":
        guard
          let args = call.arguments as? [String: Any],
          let eventName = args["name"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing event name", details: nil))
          return
        }

        let parameters = args["parameters"] as? [String: Any] ?? [:]
        switch devToDevBridge.logEvent(name: eventName, parameters: parameters) {
        case .success:
          result(nil)
        case .failure(let error):
          result(error)
        }

      case "setUserId":
        guard
          let args = call.arguments as? [String: Any],
          let userId = args["userId"] as? String
        else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing userId", details: nil))
          return
        }

        switch devToDevBridge.setUserId(userId) {
        case .success:
          result(nil)
        case .failure(let error):
          result(error)
        }

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private final class DevToDevBridge {
  fileprivate enum BridgeResult {
    case success
    case failure(FlutterError)
  }

  private let classCandidates = [
    "DevToDev",
    "DevToDevSDK.DevToDev"
  ]

  private var sdkClass: AnyClass?
  private var sdkInstance: AnyObject?
  private var isInitialized = false

  init() {
    sdkClass = Self.resolveDevToDevClass(from: classCandidates)
  }

  func initialize(appId: String, secretKey: String, apiKey: String) -> BridgeResult {
    guard let sdkClass else {
      return .failure(FlutterError(code: "DEVTODEV_UNAVAILABLE", message: "DevToDev SDK not linked", details: nil))
    }

    if isInitialized {
      return .success
    }

    let metaClass = object_getClass(sdkClass)
    let credentials = (appId as NSString, secretKey as NSString, apiKey as NSString)

    let classInitializationSelectors: [(String, (IMP, Selector) -> Void)] = [
      ("activateWithAppID:secretKey:apiKey:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSString, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(sdkClass, selector, credentials.0, credentials.1, credentials.2)
      }),
      ("activateWithAppId:secretKey:apiKey:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSString, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(sdkClass, selector, credentials.0, credentials.1, credentials.2)
      }),
      ("activateWithAppID:secretKey:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(sdkClass, selector, credentials.0, credentials.1)
      }),
      ("initializeWithAppId:secretKey:apiKey:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSString, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(sdkClass, selector, credentials.0, credentials.1, credentials.2)
      }),
      ("initializeWithAppId:secretKey:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(sdkClass, selector, credentials.0, credentials.1)
      })
    ]

    if Self.invokeClassMethod(metaClass, target: sdkClass, candidates: classInitializationSelectors) {
      isInitialized = true
      return .success
    }

    guard let instance = resolveInstance(from: sdkClass) else {
      return .failure(FlutterError(code: "DEVTODEV_UNAVAILABLE", message: "Unable to initialize DevToDev", details: nil))
    }

    let instanceSelectors: [(String, (IMP, Selector) -> Void)] = [
      ("activateWithAppID:secretKey:apiKey:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSString, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(instance, selector, credentials.0, credentials.1, credentials.2)
      }),
      ("activateWithAppID:secretKey:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(instance, selector, credentials.0, credentials.1)
      }),
      ("initializeWithAppId:secretKey:apiKey:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSString, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(instance, selector, credentials.0, credentials.1, credentials.2)
      }),
      ("initializeWithAppId:secretKey:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(instance, selector, credentials.0, credentials.1)
      })
    ]

    if Self.invokeInstanceMethod(instance, candidates: instanceSelectors) {
      sdkInstance = instance
      isInitialized = true
      return .success
    }

    return .failure(FlutterError(code: "DEVTODEV_UNAVAILABLE", message: "Unable to initialize DevToDev", details: nil))
  }

  func logEvent(name: String, parameters: [String: Any]) -> BridgeResult {
    guard let target = resolvedTarget() else {
      return .failure(FlutterError(code: "DEVTODEV_UNAVAILABLE", message: "DevToDev is not initialized", details: nil))
    }

    let eventName = name as NSString
    let params = parameters as NSDictionary

    let selectors: [(String, (IMP, Selector) -> Void)] = [
      ("customEventWithName:params:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSDictionary) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(target, selector, eventName, params)
      }),
      ("customEvent:params:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSDictionary) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(target, selector, eventName, params)
      }),
      ("customEvent:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(target, selector, eventName)
      }),
      ("logEventWithName:parameters:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString, NSDictionary) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(target, selector, eventName, params)
      })
    ]

    if Self.invoke(target: target, candidates: selectors) {
      return .success
    }

    return .failure(FlutterError(code: "DEVTODEV_UNAVAILABLE", message: "Unable to log DevToDev event", details: nil))
  }

  func setUserId(_ userId: String) -> BridgeResult {
    guard let target = resolvedTarget() else {
      return .failure(FlutterError(code: "DEVTODEV_UNAVAILABLE", message: "DevToDev is not initialized", details: nil))
    }

    let selectors: [(String, (IMP, Selector) -> Void)] = [
      ("setUserId:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(target, selector, userId as NSString)
      }),
      ("setUserID:", { imp, selector in
        typealias Function = @convention(c) (AnyObject, Selector, NSString) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        function(target, selector, userId as NSString)
      })
    ]

    if Self.invoke(target: target, candidates: selectors) {
      return .success
    }

    return .failure(FlutterError(code: "DEVTODEV_UNAVAILABLE", message: "Unable to set DevToDev userId", details: nil))
  }

  private func resolvedTarget() -> AnyObject? {
    if let sdkInstance {
      return sdkInstance
    }

    guard let sdkClass else {
      return nil
    }

    if let instance = resolveInstance(from: sdkClass) {
      sdkInstance = instance
      return instance
    }

    return sdkClass
  }

  private func resolveInstance(from clazz: AnyClass) -> AnyObject? {
    let metaClass = object_getClass(clazz)
    let selectors = ["shared", "sharedInstance", "instance", "sharedManager"]
    for name in selectors {
      let selector = NSSelectorFromString(name)
      guard let metaClass, class_respondsToSelector(metaClass, selector) else { continue }
      guard let method = class_getMethodImplementation(metaClass, selector) else { continue }
      typealias Function = @convention(c) (AnyObject, Selector) -> AnyObject
      let function = unsafeBitCast(method, to: Function.self)
      return function(clazz, selector)
    }
    return nil
  }

  private static func resolveDevToDevClass(from candidates: [String]) -> AnyClass? {
    for name in candidates {
      if let clazz = NSClassFromString(name) {
        return clazz
      }
    }
    return nil
  }

  private static func invokeClassMethod(
    _ metaClass: AnyClass?,
    target: AnyObject,
    candidates: [(String, (IMP, Selector) -> Void)]
  ) -> Bool {
    guard let metaClass else { return false }
    for candidate in candidates {
      let selector = NSSelectorFromString(candidate.0)
      guard class_respondsToSelector(metaClass, selector) else { continue }
      guard let method = class_getMethodImplementation(metaClass, selector) else { continue }
      candidate.1(method, selector)
      return true
    }
    return false
  }

  private static func invoke(target: AnyObject, candidates: [(String, (IMP, Selector) -> Void)]) -> Bool {
    for candidate in candidates {
      let selector = NSSelectorFromString(candidate.0)
      guard target.responds(to: selector) else { continue }
      let method = target.method(for: selector)
      candidate.1(method, selector)
      return true
    }
    return false
  }

  private static func invokeInstanceMethod(
    _ instance: AnyObject,
    candidates: [(String, (IMP, Selector) -> Void)]
  ) -> Bool {
    return invoke(target: instance, candidates: candidates)
  }
}
