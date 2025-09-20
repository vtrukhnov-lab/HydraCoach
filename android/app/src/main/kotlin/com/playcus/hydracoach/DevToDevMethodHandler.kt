package com.playcus.hydracoach

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class DevToDevMethodHandler(private val context: Context) {
    private val TAG = "DevToDevMethodHandler"
    private var isInitialized = false

    // Possible class names for different SDK versions
    private val possibleClassNames = listOf(
        "com.devtodev.analytics.external.analytics.DTDAnalytics",
        "com.devtodev.analytics.DTDAnalytics",
        "com.devtodev.DTDAnalytics",
        "com.devtodev.DTDGoogle",
        "com.devtodev.analytics.Analytics",
        "com.devtodev.DevToDev",
        "com.devtodev.analytics.DevToDev"
    )

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "initialize" -> initializeDevToDev(call, result)
                "logEvent" -> logEvent(call, result)
                "setUserId" -> setUserId(call, result)
                "clearUserId" -> clearUserId(result)
                "setUserProperty" -> setUserProperty(call, result)
                "setTrackingEnabled" -> setTrackingEnabled(call, result)
                "logScreenView" -> logScreenView(call, result)
                else -> {
                    Log.w(TAG, "Unknown method: ${call.method}")
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling method ${call.method}: ${e.message}", e)
            result.error("DEVTODEV_ERROR", "Error: ${e.message}", null)
        }
    }

    private fun initializeDevToDev(call: MethodCall, result: MethodChannel.Result) {
        val appId = call.argument<String>("appId") ?: ""
        val secretKey = call.argument<String>("secretKey") ?: ""
        val apiKey = call.argument<String>("apiKey") ?: ""

        Log.d(TAG, "Initializing DevToDev with appId: $appId")

        // Try different initialization methods
        val initMethods = listOf(
            { clazz: Class<*> ->
                // DTDAnalytics v2 with INSTANCE
                val instance = clazz.getDeclaredField("INSTANCE").get(null)
                val configClass = Class.forName("com.devtodev.analytics.external.analytics.DTDAnalyticsConfiguration")
                val config = configClass.getDeclaredConstructor().newInstance()
                val method = clazz.getDeclaredMethod("initialize", String::class.java, configClass, Context::class.java)
                method.invoke(instance, appId, config, context)
            },
            { clazz: Class<*> ->
                // DTDAnalytics v2 static method
                val configClass = Class.forName("com.devtodev.analytics.external.analytics.DTDAnalyticsConfiguration")
                val config = configClass.getDeclaredConstructor().newInstance()
                val method = clazz.getDeclaredMethod("initialize", String::class.java, configClass, Context::class.java)
                method.invoke(null, appId, config, context)
            },
            { clazz: Class<*> ->
                val method = clazz.getDeclaredMethod("initialize", String::class.java, Context::class.java)
                method.invoke(null, appId, context)
            },
            { clazz: Class<*> ->
                val instance = clazz.getDeclaredField("INSTANCE").get(null)
                val method = clazz.getDeclaredMethod("initialize", String::class.java, Context::class.java)
                method.invoke(instance, appId, context)
            }
        )

        var initSuccess = false

        for (className in possibleClassNames) {
            try {
                val dtdClass = Class.forName(className)
                Log.d(TAG, "Found DevToDev class: $className")

                for (initMethod in initMethods) {
                    try {
                        initMethod(dtdClass)
                        isInitialized = true
                        initSuccess = true
                        Log.d(TAG, "DevToDev initialized successfully with class: $className")
                        break
                    } catch (e: Exception) {
                        Log.v(TAG, "Init method failed for $className: ${e.message}")
                    }
                }

                if (initSuccess) break

            } catch (e: ClassNotFoundException) {
                Log.v(TAG, "DevToDev class not found: $className")
            }
        }

        if (!initSuccess) {
            Log.w(TAG, "Failed to initialize DevToDev with any method")
        }

        // Always return success to avoid blocking Flutter
        result.success(null)
    }

    private fun logEvent(call: MethodCall, result: MethodChannel.Result) {
        val eventName = call.argument<String>("name") ?: ""
        val parameters = call.argument<Map<String, Any>>("parameters") ?: emptyMap()

        Log.d(TAG, "Logging event: $eventName with params: $parameters")

        // Use the correct class directly
        try {
            val clazz = Class.forName("com.devtodev.analytics.external.analytics.DTDAnalytics")
            val instance = clazz.getDeclaredField("INSTANCE").get(null)

            if (parameters.isEmpty()) {
                val method = clazz.getDeclaredMethod("customEvent", String::class.java)
                method.invoke(instance, eventName)
                Log.d(TAG, "DevToDev event logged successfully: $eventName")
            } else {
                // Create DTDCustomEventParameters
                val paramClass = Class.forName("com.devtodev.analytics.external.DTDCustomEventParameters")
                val paramInstance = paramClass.getDeclaredConstructor().newInstance()

                // Add parameters
                for ((key, value) in parameters) {
                    when (value) {
                        is String -> {
                            val method = paramClass.getDeclaredMethod("add", String::class.java, String::class.java)
                            method.invoke(paramInstance, key, value)
                        }
                        is Number -> {
                            val method = paramClass.getDeclaredMethod("add", String::class.java, Long::class.java)
                            method.invoke(paramInstance, key, value.toLong())
                        }
                        is Boolean -> {
                            val method = paramClass.getDeclaredMethod("add", String::class.java, Boolean::class.java)
                            method.invoke(paramInstance, key, value)
                        }
                    }
                }

                val method = clazz.getDeclaredMethod("customEvent", String::class.java, paramClass)
                method.invoke(instance, eventName, paramInstance)
                Log.d(TAG, "DevToDev event with params logged successfully: $eventName")
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to log DevToDev event: ${e.message}")
        }

        result.success(null)
    }

    private fun setUserId(call: MethodCall, result: MethodChannel.Result) {
        val userId = call.argument<String>("userId") ?: ""
        Log.d(TAG, "Setting user ID: $userId")

        // Use the correct class directly for setUserId
        try {
            val clazz = Class.forName("com.devtodev.analytics.external.analytics.DTDAnalytics")
            val instance = clazz.getDeclaredField("INSTANCE").get(null)
            val method = clazz.getDeclaredMethod("setUserId", String::class.java)
            method.invoke(instance, userId)
            Log.d(TAG, "DevToDev user ID set successfully: $userId")
        } catch (e: Exception) {
            Log.w(TAG, "Failed to set DevToDev user ID: ${e.message}")
        }

        result.success(null)
    }

    private fun clearUserId(result: MethodChannel.Result) {
        Log.d(TAG, "Clearing user ID")

        tryInvokeMethod("clearUserId") { clazz ->
            try {
                clazz.getDeclaredMethod("clearUserId").invoke(null)
                true
            } catch (e: Exception) {
                try {
                    clazz.getDeclaredMethod("setUserId", String::class.java).invoke(null, null as String?)
                    true
                } catch (e2: Exception) {
                    false
                }
            }
        }

        result.success(null)
    }

    private fun setUserProperty(call: MethodCall, result: MethodChannel.Result) {
        val name = call.argument<String>("name") ?: ""
        val value = call.argument<String>("value") ?: ""
        Log.d(TAG, "Setting user property: $name = $value")

        tryInvokeMethod("setUserProperty") { clazz ->
            try {
                clazz.getDeclaredMethod("setUserProperty", String::class.java, String::class.java).invoke(null, name, value)
                true
            } catch (e: Exception) {
                false
            }
        }

        result.success(null)
    }

    private fun setTrackingEnabled(call: MethodCall, result: MethodChannel.Result) {
        val enabled = call.argument<Boolean>("enabled") ?: true
        Log.d(TAG, "Setting tracking enabled: $enabled")

        tryInvokeMethod("setTrackingEnabled") { clazz ->
            try {
                clazz.getDeclaredMethod("setTrackingEnabled", Boolean::class.java).invoke(null, enabled)
                true
            } catch (e: Exception) {
                false
            }
        }

        result.success(null)
    }

    private fun logScreenView(call: MethodCall, result: MethodChannel.Result) {
        val screenName = call.argument<String>("screenName") ?: ""
        val screenClass = call.argument<String>("screenClass")
        Log.d(TAG, "Logging screen view: $screenName")

        // Use the correct class directly for screen view
        try {
            val clazz = Class.forName("com.devtodev.analytics.external.analytics.DTDAnalytics")
            val instance = clazz.getDeclaredField("INSTANCE").get(null)

            // DevToDev v2 doesn't have currentScreen, try customEvent instead
            val method = clazz.getDeclaredMethod("customEvent", String::class.java)
            method.invoke(instance, "screen_view_$screenName")
            Log.d(TAG, "DevToDev screen view logged successfully: $screenName")
        } catch (e: Exception) {
            Log.w(TAG, "Failed to log DevToDev screen view: ${e.message}")
        }

        result.success(null)
    }

    private fun tryInvokeMethod(methodName: String, invoke: (Class<*>) -> Boolean) {
        for (className in possibleClassNames) {
            try {
                val clazz = Class.forName(className)
                Log.d(TAG, "Found class: $className")

                // Debug available methods
                val methods = clazz.declaredMethods
                Log.d(TAG, "Available methods in $className:")
                methods.forEach { method ->
                    Log.d(TAG, "  - ${method.name}(${method.parameterTypes.joinToString { it.simpleName }})")
                }

                if (invoke(clazz)) {
                    Log.d(TAG, "$methodName succeeded with class: $className")
                    return
                }
            } catch (e: ClassNotFoundException) {
                Log.d(TAG, "Class not found: $className")
                continue
            }
        }
        Log.d(TAG, "DevToDev not available, skipping $methodName")
    }
}