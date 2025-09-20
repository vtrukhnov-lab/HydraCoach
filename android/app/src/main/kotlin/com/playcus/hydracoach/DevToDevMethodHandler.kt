package com.playcus.hydracoach

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class DevToDevMethodHandler(private val context: Context) {
    private val TAG = "DevToDevMethodHandler"
    private var isInitialized = false

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "initialize" -> {
                    val appId = call.argument<String>("appId") ?: ""
                    val secretKey = call.argument<String>("secretKey") ?: ""
                    val apiKey = call.argument<String>("apiKey") ?: ""

                    Log.d(TAG, "Initializing DevToDev with appId: $appId")

                    // Use reflection to call DevToDev.initialize
                    try {
                        val dtdClass = Class.forName("com.devtodev.analytics.DTDAnalytics")
                        val initMethod = dtdClass.getDeclaredMethod("initialize", String::class.java, Context::class.java)
                        initMethod.invoke(null, appId, context)

                        isInitialized = true
                        Log.d(TAG, "DevToDev initialized successfully via reflection")
                        result.success(null)
                    } catch (e: Exception) {
                        Log.w(TAG, "Failed to initialize via first method, trying alternative: ${e.message}")

                        // Try alternative initialization method
                        try {
                            val dtdClass = Class.forName("com.devtodev.analytics.DTDAnalytics")
                            val instanceField = dtdClass.getDeclaredField("INSTANCE")
                            val instance = instanceField.get(null)

                            val initMethod = dtdClass.getDeclaredMethod("initialize", String::class.java, Context::class.java)
                            initMethod.invoke(instance, appId, context)

                            isInitialized = true
                            Log.d(TAG, "DevToDev initialized successfully via INSTANCE")
                            result.success(null)
                        } catch (e2: Exception) {
                            Log.e(TAG, "Failed to initialize DevToDev via reflection: ${e2.message}")
                            // Still return success to avoid blocking Flutter
                            result.success(null)
                        }
                    }
                }

                "logEvent" -> {
                    val eventName = call.argument<String>("name") ?: ""
                    val parameters = call.argument<Map<String, Any>>("parameters") ?: emptyMap()

                    Log.d(TAG, "Logging event: $eventName with params: $parameters")

                    try {
                        val dtdClass = Class.forName("com.devtodev.analytics.DTDAnalytics")

                        if (parameters.isEmpty()) {
                            val customEventMethod = dtdClass.getDeclaredMethod("customEvent", String::class.java)
                            customEventMethod.invoke(null, eventName)
                        } else {
                            val jsonParams = JSONObject(parameters)
                            val customEventMethod = dtdClass.getDeclaredMethod("customEvent", String::class.java, JSONObject::class.java)
                            customEventMethod.invoke(null, eventName, jsonParams)
                        }

                        Log.d(TAG, "Event logged successfully")
                        result.success(null)
                    } catch (e: Exception) {
                        Log.w(TAG, "Failed to log event via reflection: ${e.message}")
                        // Still return success to avoid blocking Flutter
                        result.success(null)
                    }
                }

                "setUserId" -> {
                    val userId = call.argument<String>("userId") ?: ""
                    Log.d(TAG, "Setting user ID: $userId")

                    try {
                        val dtdClass = Class.forName("com.devtodev.analytics.DTDAnalytics")
                        val setUserIdMethod = dtdClass.getDeclaredMethod("setUserId", String::class.java)
                        setUserIdMethod.invoke(null, userId)

                        Log.d(TAG, "User ID set successfully")
                        result.success(null)
                    } catch (e: Exception) {
                        Log.w(TAG, "Failed to set user ID via reflection: ${e.message}")
                        // Still return success to avoid blocking Flutter
                        result.success(null)
                    }
                }

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
}