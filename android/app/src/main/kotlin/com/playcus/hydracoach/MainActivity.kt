package com.playcus.hydracoach

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "hydracoach.purchase_connector"
    private val DEVTODEV_CHANNEL = "devtodev_analytics"
    private val TAG = "PurchaseConnector"
    private val DEVTODEV_TAG = "DevToDevAnalytics"

    private lateinit var devToDevHandler: DevToDevMethodHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize DevToDev handler
        devToDevHandler = DevToDevMethodHandler(this)

        // Purchase Connector MethodChannel - LEGACY MODE ONLY
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initializePurchaseConnector" -> {
                    Log.d(TAG, "🔧 Purchase Connector: using LEGACY mode (validateAndLogInAppPurchase)")
                    Log.d(TAG, "✅ Legacy approach ready - no Purchase Connector dependencies")

                    result.success(mapOf(
                        "status" to "initialized",
                        "message" to "Legacy validateAndLogInAppPurchase approach ready",
                        "sandbox" to false, // Production mode
                        "method" to "legacy",
                        "connector" to false
                    ))
                }
                "startPurchaseConnector" -> {
                    Log.d(TAG, "🚀 Legacy purchase validation ready")
                    Log.d(TAG, "💡 Use validateAndLogInAppPurchase for manual purchase tracking")

                    result.success(mapOf(
                        "status" to "started",
                        "message" to "Legacy purchase validation active",
                        "observing" to false,
                        "method" to "legacy"
                    ))
                }
                "stopPurchaseConnector" -> {
                    Log.d(TAG, "🛑 Legacy purchase validation stopped")

                    result.success(mapOf(
                        "status" to "stopped",
                        "message" to "Legacy purchase validation stopped",
                        "method" to "legacy"
                    ))
                }
                else -> result.notImplemented()
            }
        }

        // DevToDev Analytics MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVTODEV_CHANNEL).setMethodCallHandler { call, result ->
            devToDevHandler.handle(call, result)
        }
    }
}