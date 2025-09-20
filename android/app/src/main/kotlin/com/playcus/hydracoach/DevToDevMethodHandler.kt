package com.playcus.hydracoach

import android.app.Application
import android.os.Bundle
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method
import java.util.ArrayList
import java.util.HashMap

private const val DEVTODEV_LOG_TAG = "DevToDevChannel"

class DevToDevMethodHandler(private val application: Application) {

    fun handle(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "initialize" -> handleInitialize(call, result)
                "setUserId" -> handleSetUserId(call, result)
                "clearUserId" -> handleClearUserId(result)
                "setUserProperty" -> handleSetUserProperty(call, result)
                "setTrackingEnabled" -> handleSetTrackingEnabled(call, result)
                "logScreenView" -> handleLogScreenView(call, result)
                "logEvent" -> handleLogEvent(call, result)
                else -> result.notImplemented()
            }
        } catch (exception: ClassNotFoundException) {
            val message = "DevToDev SDK not found: ${exception.message}"
            Log.e(DEVTODEV_LOG_TAG, message, exception)
            result.error("DEVTODEV_UNAVAILABLE", message, null)
        } catch (exception: NoSuchMethodException) {
            val message = "DevToDev SDK method missing: ${exception.message}"
            Log.e(DEVTODEV_LOG_TAG, message, exception)
            result.error("DEVTODEV_METHOD_MISSING", message, null)
        } catch (throwable: Throwable) {
            val message = "DevToDev SDK error: ${throwable.message}"
            Log.e(DEVTODEV_LOG_TAG, message, throwable)
            result.error("DEVTODEV_ERROR", message, null)
        }
    }

    @Throws(ClassNotFoundException::class, NoSuchMethodException::class)
    private fun handleInitialize(call: MethodCall, result: MethodChannel.Result) {
        val appId = call.argument<String>("appId")
        val secretKey = call.argument<String>("secretKey")
        val apiKey = call.argument<String>("apiKey")

        if (appId.isNullOrBlank() || secretKey.isNullOrBlank() || apiKey.isNullOrBlank()) {
            result.error(
                "INVALID_ARGUMENTS",
                "DevToDev initialize requires non-empty appId, secretKey and apiKey",
                null,
            )
            return
        }

        val clazz = resolveDevToDevClass()
        val method = findFirstMethod(
            clazz,
            listOf(
                MethodSignature(
                    "init",
                    arrayOf(
                        Application::class.java,
                        String::class.java,
                        String::class.java,
                        String::class.java,
                    ),
                ),
                MethodSignature(
                    "initialize",
                    arrayOf(
                        Application::class.java,
                        String::class.java,
                        String::class.java,
                        String::class.java,
                    ),
                ),
            ),
        )

        method.invoke(null, application, appId, secretKey, apiKey)
        result.success(null)
    }

    @Throws(ClassNotFoundException::class, NoSuchMethodException::class)
    private fun handleSetUserId(call: MethodCall, result: MethodChannel.Result) {
        val userId = call.argument<String?>("userId")
        val clazz = resolveDevToDevClass()
        val method = findFirstMethod(
            clazz,
            listOf(
                MethodSignature("setUserId", arrayOf(String::class.java)),
                MethodSignature("setUserID", arrayOf(String::class.java)),
            ),
        )

        method.invoke(null, userId)
        result.success(null)
    }

    @Throws(ClassNotFoundException::class, NoSuchMethodException::class)
    private fun handleClearUserId(result: MethodChannel.Result) {
        val clazz = resolveDevToDevClass()

        val clearMethod = findMethod(
            clazz,
            listOf(
                MethodSignature("clearUserId", emptyArray()),
                MethodSignature("clearUserID", emptyArray()),
            ),
        )

        if (clearMethod != null) {
            clearMethod.invoke(null)
        } else {
            val setMethod = findFirstMethod(
                clazz,
                listOf(
                    MethodSignature("setUserId", arrayOf(String::class.java)),
                    MethodSignature("setUserID", arrayOf(String::class.java)),
                ),
            )
            setMethod.invoke(null, null)
        }

        result.success(null)
    }

    @Throws(ClassNotFoundException::class, NoSuchMethodException::class)
    private fun handleSetUserProperty(call: MethodCall, result: MethodChannel.Result) {
        val name = call.argument<String>("name")
        val value = call.argument<String>("value")

        if (name.isNullOrBlank()) {
            result.error("INVALID_ARGUMENTS", "DevToDev setUserProperty requires name", null)
            return
        }

        if (value == null) {
            result.error("INVALID_ARGUMENTS", "DevToDev setUserProperty requires value", null)
            return
        }

        val clazz = resolveDevToDevClass()
        val method = findFirstMethod(
            clazz,
            listOf(
                MethodSignature("setUserProperty", arrayOf(String::class.java, String::class.java)),
                MethodSignature("setUserProperty", arrayOf(String::class.java, Any::class.java)),
                MethodSignature("setUserProperty", arrayOf(String::class.java, Any::class.java)),
                MethodSignature("setUserPropertyWithName", arrayOf(String::class.java, String::class.java)),
                MethodSignature("setUserProperty", arrayOf(String::class.java, CharSequence::class.java)),
            ),
        )

        method.invoke(null, name, value)
        result.success(null)
    }

    @Throws(ClassNotFoundException::class, NoSuchMethodException::class)
    private fun handleSetTrackingEnabled(call: MethodCall, result: MethodChannel.Result) {
        val enabled = call.argument<Boolean>("enabled")

        if (enabled == null) {
            result.error("INVALID_ARGUMENTS", "DevToDev setTrackingEnabled requires enabled flag", null)
            return
        }

        val clazz = resolveDevToDevClass()
        val method = findFirstMethod(
            clazz,
            listOf(
                MethodSignature("setTrackingEnabled", arrayOf(Boolean::class.javaPrimitiveType!!)),
                MethodSignature("setTrackingEnabled", arrayOf(Boolean::class.javaObjectType)),
                MethodSignature("setTrackingAvailability", arrayOf(Boolean::class.javaPrimitiveType!!)),
                MethodSignature("setTrackingAvailability", arrayOf(Boolean::class.javaObjectType)),
            ),
        )

        method.invoke(null, enabled)
        result.success(null)
    }

    @Throws(ClassNotFoundException::class, NoSuchMethodException::class)
    private fun handleLogScreenView(call: MethodCall, result: MethodChannel.Result) {
        val screenName = call.argument<String>("screenName")
        val screenClass = call.argument<String?>("screenClass")?.takeIf { it.isNotBlank() }

        if (screenName.isNullOrBlank()) {
            result.error("INVALID_ARGUMENTS", "DevToDev logScreenView requires screenName", null)
            return
        }

        val clazz = resolveDevToDevClass()

        if (screenClass != null) {
            val method = findMethod(
                clazz,
                listOf(
                    MethodSignature("logScreen", arrayOf(String::class.java, String::class.java)),
                    MethodSignature("logScreenView", arrayOf(String::class.java, String::class.java)),
                    MethodSignature("logScreen", arrayOf(String::class.java, CharSequence::class.java)),
                ),
            )

            if (method != null) {
                method.invoke(null, screenName, screenClass)
                result.success(null)
                return
            }
        }

        val method = findFirstMethod(
            clazz,
            listOf(
                MethodSignature("logScreen", arrayOf(String::class.java)),
                MethodSignature("logScreenView", arrayOf(String::class.java)),
                MethodSignature("logScreen", arrayOf(CharSequence::class.java)),
            ),
        )

        method.invoke(null, screenName)
        result.success(null)
    }

    @Throws(ClassNotFoundException::class, NoSuchMethodException::class)
    private fun handleLogEvent(call: MethodCall, result: MethodChannel.Result) {
        val eventName = call.argument<String>("name")
        if (eventName.isNullOrBlank()) {
            result.error("INVALID_ARGUMENTS", "DevToDev logEvent requires event name", null)
            return
        }

        val parameters = call.argument<Map<String, Any?>>("parameters")

        val clazz = resolveDevToDevClass()

        if (parameters != null && parameters.isNotEmpty()) {
            val hashMap = HashMap<String, Any?>(parameters)

            val method = findMethod(
                clazz,
                listOf(
                    MethodSignature("logEvent", arrayOf(String::class.java, Map::class.java)),
                    MethodSignature("logEvent", arrayOf(String::class.java, HashMap::class.java)),
                    MethodSignature("logEvent", arrayOf(String::class.java, java.util.Map::class.java)),
                    MethodSignature("logEvent", arrayOf(String::class.java, Bundle::class.java)),
                ),
            )

            if (method != null) {
                val argument = if (method.parameterTypes[1] == Bundle::class.java) {
                    toBundle(hashMap)
                } else {
                    hashMap
                }

                method.invoke(null, eventName, argument)
                result.success(null)
                return
            }
        }

        val method = findFirstMethod(
            clazz,
            listOf(
                MethodSignature("logEvent", arrayOf(String::class.java)),
                MethodSignature("logEvent", arrayOf(CharSequence::class.java)),
            ),
        )

        method.invoke(null, eventName)
        result.success(null)
    }

    @Throws(ClassNotFoundException::class)
    private fun resolveDevToDevClass(): Class<*> = Class.forName("com.devtodev.analytics.sdk.DevToDev")

    private fun findFirstMethod(
        clazz: Class<*>,
        signatures: List<MethodSignature>,
    ): Method {
        return findMethod(clazz, signatures)
            ?: throw NoSuchMethodException(
                "None of the expected methods found for ${clazz.simpleName}: " +
                    signatures.joinToString { signature ->
                        "${signature.name}(${signature.parameterTypes.joinToString { it.simpleName }})"
                    },
            )
    }

    private fun findMethod(
        clazz: Class<*>,
        signatures: List<MethodSignature>,
    ): Method? {
        signatures.forEach { signature ->
            try {
                return clazz.getMethod(signature.name, *signature.parameterTypes)
            } catch (_: NoSuchMethodException) {
                // Try next signature
            }
        }
        return null
    }

    @Suppress("UNCHECKED_CAST")
    private fun toBundle(map: HashMap<String, Any?>): Bundle {
        val bundle = Bundle()
        map.forEach { (key, value) ->
            when (value) {
                null -> bundle.putString(key, null)
                is String -> bundle.putString(key, value)
                is Int -> bundle.putInt(key, value)
                is Long -> bundle.putLong(key, value)
                is Double -> bundle.putDouble(key, value)
                is Float -> bundle.putFloat(key, value)
                is Boolean -> bundle.putBoolean(key, value)
                is Map<*, *> -> {
                    val nested = HashMap<String, Any?>()
                    value.forEach { (nestedKey, nestedValue) ->
                        if (nestedKey != null) {
                            nested[nestedKey.toString()] = nestedValue
                        }
                    }
                    if (nested.isNotEmpty()) {
                        bundle.putBundle(key, toBundle(nested))
                    }
                }
                is List<*> -> bundle.putStringArrayList(
                    key,
                    ArrayList(value.map { it?.toString() ?: "" }),
                )
                else -> bundle.putString(key, value.toString())
            }
        }
        return bundle
    }

    private data class MethodSignature(
        val name: String,
        val parameterTypes: Array<Class<*>>,
    )
}
