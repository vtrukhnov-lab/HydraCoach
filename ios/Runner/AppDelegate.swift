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
    let analyticsChannel = FlutterMethodChannel(
      name: "devtodev_analytics",
      binaryMessenger: controller.binaryMessenger
    )

    let devToDevHandler = DevToDevMethodCallHandler()
    analyticsChannel.setMethodCallHandler { call, result in
      devToDevHandler.handle(call: call, result: result)
    }

    let purchaseConnectorChannel = FlutterMethodChannel(
      name: "hydracoach.purchase_connector",
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

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private final class DevToDevMethodCallHandler {
  private enum DevToDevError: Error {
    case sdkUnavailable
    case methodUnavailable(String)
    case invalidArguments(String)
  }

  private let devToDevClassName = "DevToDev"

  func handle(call: FlutterMethodCall, result: FlutterResult) {
    do {
      switch call.method {
      case "initialize":
        let arguments = try requireArguments(call.arguments)
        try initialize(
          appId: try requireString(arguments["appId"], name: "appId"),
          secretKey: try requireString(arguments["secretKey"], name: "secretKey"),
          apiKey: try requireString(arguments["apiKey"], name: "apiKey")
        )
        result(nil)

      case "setUserId":
        let arguments = dictionary(from: call.arguments)
        try setUserId(arguments?["userId"] as? String)
        result(nil)

      case "clearUserId":
        try clearUserId()
        result(nil)

      case "setUserProperty":
        let arguments = try requireArguments(call.arguments)
        try setUserProperty(
          name: try requireString(arguments["name"], name: "name"),
          value: try requireString(arguments["value"], name: "value")
        )
        result(nil)

      case "setTrackingEnabled":
        let arguments = try requireArguments(call.arguments)
        guard let enabled = arguments["enabled"] as? Bool else {
          throw DevToDevError.invalidArguments("setTrackingEnabled requires a boolean enabled flag")
        }
        try setTrackingEnabled(enabled)
        result(nil)

      case "logScreenView":
        let arguments = try requireArguments(call.arguments)
        let screenName = try requireString(arguments["screenName"], name: "screenName")
        let screenClass = arguments["screenClass"] as? String
        try logScreenView(name: screenName, screenClass: screenClass)
        result(nil)

      case "logEvent":
        let arguments = try requireArguments(call.arguments)
        let name = try requireString(arguments["name"], name: "name")
        let parameters = arguments["parameters"] as? [String: Any]
        try logEvent(name: name, parameters: parameters)
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    } catch DevToDevError.invalidArguments(let message) {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: message, details: nil))
    } catch DevToDevError.sdkUnavailable {
      result(FlutterError(code: "DEVTODEV_UNAVAILABLE", message: "DevToDev SDK not found", details: nil))
    } catch DevToDevError.methodUnavailable(let name) {
      result(FlutterError(code: "DEVTODEV_METHOD_MISSING", message: "DevToDev method \(name) not found", details: nil))
    } catch {
      result(FlutterError(code: "DEVTODEV_ERROR", message: error.localizedDescription, details: nil))
    }
  }

  private func initialize(appId: String, secretKey: String, apiKey: String) throws {
    let clazz = try devToDevClass()
    let selectors = [
      "initializeWithAppId:secretKey:apiKey:",
      "initializeWithAppID:secretKey:apiKey:",
      "initWithAppId:secretKey:apiKey:"
    ]

    for name in selectors {
      let selector = NSSelectorFromString(name)
      if let method = class_getClassMethod(clazz, selector) {
        typealias Function = @convention(c) (AnyClass, Selector, NSString, NSString, NSString) -> Void
        let function = unsafeBitCast(method_getImplementation(method), to: Function.self)
        function(clazz, selector, appId as NSString, secretKey as NSString, apiKey as NSString)
        return
      }
    }

    throw DevToDevError.methodUnavailable("initialize")
  }

  private func setUserId(_ userId: String?) throws {
    let clazz = try devToDevClass()
    let selectors = ["setUserId:", "setUserID:"]

    for name in selectors {
      let selector = NSSelectorFromString(name)
      if let method = class_getClassMethod(clazz, selector) {
        typealias Function = @convention(c) (AnyClass, Selector, NSString?) -> Void
        let function = unsafeBitCast(method_getImplementation(method), to: Function.self)
        function(clazz, selector, userId as NSString?)
        return
      }
    }

    throw DevToDevError.methodUnavailable("setUserId")
  }

  private func clearUserId() throws {
    let clazz = try devToDevClass()
    let selectors = ["clearUserId", "clearUserID", "resetUserId"]

    for name in selectors {
      let selector = NSSelectorFromString(name)
      if let method = class_getClassMethod(clazz, selector) {
        typealias Function = @convention(c) (AnyClass, Selector) -> Void
        let function = unsafeBitCast(method_getImplementation(method), to: Function.self)
        function(clazz, selector)
        return
      }
    }

    try setUserId(nil)
  }

  private func setUserProperty(name: String, value: String) throws {
    let clazz = try devToDevClass()
    let selectors = [
      "setUserProperty:value:",
      "setUserProperty:forKey:",
      "setUserPropertyWithName:value:",
      "setUserProperty:value:forApp:"
    ]

    for selectorName in selectors {
      let selector = NSSelectorFromString(selectorName)
      if let method = class_getClassMethod(clazz, selector) {
        typealias Function = @convention(c) (AnyClass, Selector, NSString, NSString) -> Void
        let function = unsafeBitCast(method_getImplementation(method), to: Function.self)
        function(clazz, selector, name as NSString, value as NSString)
        return
      }
    }

    throw DevToDevError.methodUnavailable("setUserProperty")
  }

  private func setTrackingEnabled(_ enabled: Bool) throws {
    let clazz = try devToDevClass()
    let selectors = ["setTrackingEnabled:", "setTrackingAvailability:"]

    for name in selectors {
      let selector = NSSelectorFromString(name)
      if let method = class_getClassMethod(clazz, selector) {
        typealias Function = @convention(c) (AnyClass, Selector, Bool) -> Void
        let function = unsafeBitCast(method_getImplementation(method), to: Function.self)
        function(clazz, selector, enabled)
        return
      }
    }

    throw DevToDevError.methodUnavailable("setTrackingEnabled")
  }

  private func logScreenView(name: String, screenClass: String?) throws {
    let clazz = try devToDevClass()

    if let screenClass, !screenClass.isEmpty {
      let selectors = [
        "logScreen:screenClass:",
        "logScreenView:screenClass:",
        "logScreen:name:"
      ]

      for selectorName in selectors {
        let selector = NSSelectorFromString(selectorName)
        if let method = class_getClassMethod(clazz, selector) {
          typealias Function = @convention(c) (AnyClass, Selector, NSString, NSString) -> Void
          let function = unsafeBitCast(method_getImplementation(method), to: Function.self)
          function(clazz, selector, name as NSString, screenClass as NSString)
          return
        }
      }
    }

    let selectors = [
      "logScreen:",
      "logScreenView:",
      "logScreenWithName:",
      "logScreenName:"
    ]

    for selectorName in selectors {
      let selector = NSSelectorFromString(selectorName)
      if let method = class_getClassMethod(clazz, selector) {
        typealias Function = @convention(c) (AnyClass, Selector, NSString) -> Void
        let function = unsafeBitCast(method_getImplementation(method), to: Function.self)
        function(clazz, selector, name as NSString)
        return
      }
    }

    throw DevToDevError.methodUnavailable("logScreenView")
  }

  private func logEvent(name: String, parameters: [String: Any]?) throws {
    let clazz = try devToDevClass()

    if let parameters, !parameters.isEmpty {
      let dictionary = sanitize(parameters: parameters)
      let selectors = [
        "logEvent:parameters:",
        "logEventWithName:parameters:",
        "logEvent:params:",
        "logEventWithName:params:"
      ]

      for selectorName in selectors {
        let selector = NSSelectorFromString(selectorName)
        if let method = class_getClassMethod(clazz, selector) {
          typealias Function = @convention(c) (AnyClass, Selector, NSString, NSDictionary) -> Void
          let function = unsafeBitCast(method_getImplementation(method), to: Function.self)
          function(clazz, selector, name as NSString, dictionary)
          return
        }
      }
    }

    let selectors = ["logEvent:", "logEventWithName:"]

    for selectorName in selectors {
      let selector = NSSelectorFromString(selectorName)
      if let method = class_getClassMethod(clazz, selector) {
        typealias Function = @convention(c) (AnyClass, Selector, NSString) -> Void
        let function = unsafeBitCast(method_getImplementation(method), to: Function.self)
        function(clazz, selector, name as NSString)
        return
      }
    }

    throw DevToDevError.methodUnavailable("logEvent")
  }

  private func devToDevClass() throws -> AnyClass {
    guard let clazz = NSClassFromString(devToDevClassName) else {
      throw DevToDevError.sdkUnavailable
    }
    return clazz
  }

  private func requireArguments(_ arguments: Any?) throws -> [String: Any] {
    guard let dictionary = arguments as? [String: Any] else {
      throw DevToDevError.invalidArguments("Expected arguments dictionary")
    }
    return dictionary
  }

  private func dictionary(from arguments: Any?) -> [String: Any]? {
    return arguments as? [String: Any]
  }

  private func requireString(_ value: Any?, name: String) throws -> String {
    guard let string = value as? String, !string.isEmpty else {
      throw DevToDevError.invalidArguments("Argument \(name) must be a non-empty string")
    }
    return string
  }

  private func sanitize(parameters: [String: Any]) -> NSDictionary {
    var result: [String: Any] = [:]
    for (key, value) in parameters {
      let stringKey = key

      switch value {
      case let string as String:
        result[stringKey] = string
      case let intValue as Int:
        result[stringKey] = intValue
      case let doubleValue as Double:
        result[stringKey] = doubleValue
      case let boolValue as Bool:
        result[stringKey] = boolValue
      case let floatValue as Float:
        result[stringKey] = floatValue
      case let number as NSNumber:
        result[stringKey] = number
      case let array as [Any]:
        result[stringKey] = array.map { String(describing: $0) }
      case let nested as [String: Any]:
        result[stringKey] = sanitize(parameters: nested)
      default:
        result[stringKey] = String(describing: value)
      }
    }

    return result as NSDictionary
  }
}
