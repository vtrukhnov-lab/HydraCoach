package com.playcus.hydracoach

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Modifier
import org.json.JSONObject

class DevToDevMethodHandler(private val context: Context) {
    private val TAG = "DevToDevMethodHandler"
    private var isInitialized = false

    private val classCandidates = listOf(
        "com.devtodev.analytics.DevToDev",
        "com.devtodev.analytics.Analytics",
        "com.devtodev.analytics.analytics.DevToDev",
        "com.devtodev.analytics.analytics.Analytics",
        "com.devtodev.analytics.DTDAnalytics"
    )

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "initialize" -> handleInitialize(call, result)
                "logEvent" -> handleLogEvent(call, result)
                "setUserId" -> handleSetUserId(call, result)
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

    private fun handleInitialize(call: MethodCall, result: MethodChannel.Result) {
        val appId = call.argument<String>("appId") ?: ""
        val secretKey = call.argument<String>("secretKey") ?: ""
        val apiKey = call.argument<String>("apiKey") ?: ""

        Log.d(TAG, "Initializing DevToDev with appId: $appId")

        val clazz = resolveDevToDevClass()
        if (clazz == null) {
            Log.e(TAG, "DevToDev class not found in runtime classpath")
            result.error("DEVTODEV_UNAVAILABLE", "DevToDev SDK is not linked", null)
            return
        }

        val initializationSucceeded = tryInitialize(clazz, appId, secretKey, apiKey)
        if (initializationSucceeded) {
            isInitialized = true
            Log.d(TAG, "DevToDev initialized successfully")
            result.success(null)
        } else {
            Log.e(TAG, "DevToDev initialization failed for all known signatures")
            result.error("DEVTODEV_UNAVAILABLE", "Failed to initialize DevToDev", null)
        }
    }

    private fun handleLogEvent(call: MethodCall, result: MethodChannel.Result) {
        val eventName = call.argument<String>("name") ?: ""
        val parameters = call.argument<Map<String, Any>>("parameters") ?: emptyMap()

        if (!isInitialized) {
            Log.w(TAG, "DevToDev is not initialized. Skipping event: $eventName")
            result.error("DEVTODEV_UNAVAILABLE", "DevToDev is not initialized", null)
            return
        }

        val clazz = resolveDevToDevClass()
        if (clazz == null) {
            Log.e(TAG, "DevToDev class not found when logging event")
            result.error("DEVTODEV_UNAVAILABLE", "DevToDev SDK is not linked", null)
            return
        }

        val success = tryLogEvent(clazz, eventName, parameters)
        if (success) {
            Log.d(TAG, "Event $eventName logged successfully")
            result.success(null)
        } else {
            Log.e(TAG, "Failed to log event $eventName")
            result.error("DEVTODEV_UNAVAILABLE", "Failed to log event", null)
        }
    }

    private fun handleSetUserId(call: MethodCall, result: MethodChannel.Result) {
        val userId = call.argument<String>("userId") ?: ""

        if (!isInitialized) {
            Log.w(TAG, "DevToDev is not initialized. Skipping user id update")
            result.error("DEVTODEV_UNAVAILABLE", "DevToDev is not initialized", null)
            return
        }

        val clazz = resolveDevToDevClass()
        if (clazz == null) {
            Log.e(TAG, "DevToDev class not found when setting user id")
            result.error("DEVTODEV_UNAVAILABLE", "DevToDev SDK is not linked", null)
            return
        }

        val success = trySetUserId(clazz, userId)
        if (success) {
            Log.d(TAG, "User ID set successfully")
            result.success(null)
        } else {
            Log.e(TAG, "Failed to set user id")
            result.error("DEVTODEV_UNAVAILABLE", "Failed to set user id", null)
        }
    }

    private fun resolveDevToDevClass(): Class<*>? {
        classCandidates.forEach { candidate ->
            try {
                return Class.forName(candidate)
            } catch (_: ClassNotFoundException) {
                // Try next candidate.
            }
        }
        return null
    }

    private fun tryInitialize(clazz: Class<*>, appId: String, secretKey: String, apiKey: String): Boolean {
        val signatures = listOf(
            MethodSignature(
                "initialize",
                arrayOf(Context::class.java, String::class.java, String::class.java, String::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(context, appId, secretKey, apiKey)
            },
            MethodSignature(
                "initialize",
                arrayOf(String::class.java, String::class.java, String::class.java, Context::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(appId, secretKey, apiKey, context)
            },
            MethodSignature(
                "initialize",
                arrayOf(String::class.java, Context::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(appId, context)
            },
            MethodSignature(
                "initialize",
                arrayOf(Context::class.java, String::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(context, appId)
            },
            MethodSignature(
                "activate",
                arrayOf(Context::class.java, String::class.java, String::class.java, String::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(context, appId, secretKey, apiKey)
            },
            MethodSignature(
                "initialize",
                arrayOf(Context::class.java, String::class.java, String::class.java, String::class.java),
                receiverProvider = { resolveInstance(it) }
            ) {
                arrayOf<Any>(context, appId, secretKey, apiKey)
            },
            MethodSignature(
                "initialize",
                arrayOf(String::class.java, String::class.java, String::class.java, Context::class.java),
                receiverProvider = { resolveInstance(it) }
            ) {
                arrayOf<Any>(appId, secretKey, apiKey, context)
            },
            MethodSignature(
                "activate",
                arrayOf(Context::class.java, String::class.java, String::class.java, String::class.java),
                receiverProvider = { resolveInstance(it) }
            ) {
                arrayOf<Any>(context, appId, secretKey, apiKey)
            }
        )

        return invokeFirstSuccessful(clazz, signatures)
    }

    private fun tryLogEvent(clazz: Class<*>, eventName: String, parameters: Map<String, Any>): Boolean {
        val jsonParams = JSONObject(parameters)
        val signatures = listOf(
            MethodSignature(
                "customEvent",
                arrayOf(String::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(eventName)
            },
            MethodSignature(
                "customEvent",
                arrayOf(String::class.java, JSONObject::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(eventName, jsonParams)
            },
            MethodSignature(
                "logEvent",
                arrayOf(String::class.java, JSONObject::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(eventName, jsonParams)
            },
            MethodSignature(
                "event",
                arrayOf(String::class.java, JSONObject::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(eventName, jsonParams)
            },
            MethodSignature(
                "customEvent",
                arrayOf(String::class.java),
                receiverProvider = { resolveInstance(it) }
            ) {
                arrayOf<Any>(eventName)
            },
            MethodSignature(
                "customEvent",
                arrayOf(String::class.java, JSONObject::class.java),
                receiverProvider = { resolveInstance(it) }
            ) {
                arrayOf<Any>(eventName, jsonParams)
            },
            MethodSignature(
                "logEvent",
                arrayOf(String::class.java, JSONObject::class.java),
                receiverProvider = { resolveInstance(it) }
            ) {
                arrayOf<Any>(eventName, jsonParams)
            },
            MethodSignature(
                "event",
                arrayOf(String::class.java, JSONObject::class.java),
                receiverProvider = { resolveInstance(it) }
            ) {
                arrayOf<Any>(eventName, jsonParams)
            }
        )

        return invokeFirstSuccessful(clazz, signatures)
    }

    private fun trySetUserId(clazz: Class<*>, userId: String): Boolean {
        val signatures = listOf(
            MethodSignature(
                "setUserId",
                arrayOf(String::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(userId)
            },
            MethodSignature(
                "setUserId",
                arrayOf(Context::class.java, String::class.java),
                receiverProvider = { null }
            ) {
                arrayOf<Any>(context, userId)
            },
            MethodSignature(
                "setUserId",
                arrayOf(String::class.java),
                receiverProvider = { resolveInstance(it) }
            ) {
                arrayOf<Any>(userId)
            },
            MethodSignature(
                "setUserId",
                arrayOf(Context::class.java, String::class.java),
                receiverProvider = { resolveInstance(it) }
            ) {
                arrayOf<Any>(context, userId)
            }
        )

        return invokeFirstSuccessful(clazz, signatures)
    }

    private fun invokeFirstSuccessful(clazz: Class<*>, signatures: List<MethodSignature>): Boolean {
        signatures.forEach { signature ->
            try {
                val method = clazz.getDeclaredMethod(signature.methodName, *signature.parameterTypes)
                method.isAccessible = true
                val receiver = if (Modifier.isStatic(method.modifiers)) {
                    null
                } else {
                    signature.receiverProvider.invoke(clazz) ?: return@forEach
                }
                method.invoke(receiver, *signature.argumentsProvider.invoke())
                return true
            } catch (ignored: Exception) {
                // Try next signature.
            }
        }
        return false
    }

    private data class MethodSignature(
        val methodName: String,
        val parameterTypes: Array<Class<*>>,
        val receiverProvider: (Class<*>) -> Any?,
        val argumentsProvider: () -> Array<Any>
    )

    private fun resolveInstance(clazz: Class<*>): Any? {
        val instanceFields = listOf("INSTANCE", "instance")
        instanceFields.forEach { fieldName ->
            try {
                val field = clazz.getDeclaredField(fieldName)
                field.isAccessible = true
                val instance = field.get(null)
                if (instance != null) {
                    return instance
                }
            } catch (_: Exception) {
                // Ignore and try other resolution strategies.
            }
        }

        val factoryMethods = listOf("getInstance", "instance", "shared", "sharedInstance")
        factoryMethods.forEach { methodName ->
            try {
                val method = clazz.getDeclaredMethod(methodName)
                method.isAccessible = true
                return method.invoke(null)
            } catch (_: Exception) {
                // Ignore and try next
            }
        }

        return null
    }
}