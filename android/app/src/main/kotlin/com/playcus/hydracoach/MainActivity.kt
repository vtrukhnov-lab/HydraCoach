package com.playcus.hydracoach

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
// Purchase Connector classes - reflection-based fallback due to v2.1.1 class loading issues
// DevToDev integration via reflection-based handler

class MainActivity: FlutterActivity() {
    private val CHANNEL = "hydracoach.purchase_connector"
    private val DEVTODEV_CHANNEL = "devtodev_analytics"
    private val TAG = "PurchaseConnector"
    private val DEVTODEV_TAG = "DevToDevAnalytics"

    private lateinit var devToDevHandler: DevToDevMethodHandler
    private var purchaseConnector: Any? = null
    private var isConnectorInitialized = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize DevToDev handler
        devToDevHandler = DevToDevMethodHandler(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initializePurchaseConnector" -> {
                    try {
                        Log.d(TAG, "Initializing AppsFlyer Purchase Connector via reflection...")

                        // Try different package structures for Purchase Connector v2.1.1
                        val packageNames = listOf(
                            "com.appsflyer.purchase.connector",
                            "com.appsflyer.purchaseconnector",
                            "com.appsflyer.sdk.purchase.connector",
                            "com.appsflyer.connector"
                        )

                        var configClass: Class<*>? = null
                        var configBuilderClass: Class<*>? = null

                        for (packageName in packageNames) {
                            try {
                                configClass = Class.forName("$packageName.PurchaseConnectorConfig")
                                configBuilderClass = Class.forName("$packageName.PurchaseConnectorConfig\$Builder")
                                Log.d(TAG, "✅ Found Purchase Connector classes in package: $packageName")
                                break
                            } catch (e: ClassNotFoundException) {
                                Log.v(TAG, "Package $packageName not found: ${e.message}")
                                continue
                            }
                        }

                        if (configClass == null || configBuilderClass == null) {
                            throw ClassNotFoundException("Purchase Connector classes not found in any expected package")
                        }

                        val configBuilder = configBuilderClass.getDeclaredConstructor(android.content.Context::class.java).newInstance(this)

                        // Set store country code
                        val setStoreCountryCodeMethod = configBuilderClass.getDeclaredMethod("setStoreCountryCode", String::class.java)
                        setStoreCountryCodeMethod.invoke(configBuilder, "RU")

                        // Set Android sandbox
                        val setAndroidSandboxMethod = configBuilderClass.getDeclaredMethod("setAndroidSandbox", Boolean::class.java)
                        setAndroidSandboxMethod.invoke(configBuilder, true)

                        // Build config
                        val buildConfigMethod = configBuilderClass.getDeclaredMethod("build")
                        val config = buildConfigMethod.invoke(configBuilder)

                        // Create PurchaseConnector using the found package
                        val foundPackage = configClass.packageName.removeSuffix(".PurchaseConnectorConfig").removeSuffix("Config")
                        val connectorClass = Class.forName("$foundPackage.PurchaseConnector")
                        val connectorBuilderClass = Class.forName("$foundPackage.PurchaseConnector\$Builder")

                        val connectorBuilder = connectorBuilderClass.getDeclaredConstructor(android.content.Context::class.java, configClass)
                            .newInstance(this, config)

                        // Set log level to VERBOSE
                        val logLevelClass = Class.forName("$foundPackage.PurchaseConnector\$LogLevel")
                        val verboseLevel = logLevelClass.getDeclaredField("VERBOSE").get(null)
                        val setLogLevelMethod = connectorBuilderClass.getDeclaredMethod("logLevel", logLevelClass)
                        setLogLevelMethod.invoke(connectorBuilder, verboseLevel)

                        // Set auto log purchase revenue
                        val setAutoLogMethod = connectorBuilderClass.getDeclaredMethod("setAutoLogPurchaseRevenue", Boolean::class.java, Boolean::class.java)
                        setAutoLogMethod.invoke(connectorBuilder, true, true) // autoLogInApps, autoLogSubscriptions

                        // Build connector
                        val buildConnectorMethod = connectorBuilderClass.getDeclaredMethod("build")
                        purchaseConnector = buildConnectorMethod.invoke(connectorBuilder)

                        isConnectorInitialized = true
                        Log.d(TAG, "✅ Purchase Connector initialized successfully via reflection")

                        result.success(mapOf(
                            "status" to "initialized",
                            "message" to "Purchase Connector initialized successfully via reflection",
                            "sandbox" to true,
                            "method" to "reflection"
                        ))
                    } catch (e: Exception) {
                        Log.e(TAG, "❌ Error initializing Purchase Connector via reflection: ${e.message}", e)
                        result.error("INITIALIZATION_FAILED", "Failed to initialize Purchase Connector: ${e.message}", null)
                    }
                }
                "startPurchaseConnector" -> {
                    try {
                        if (!isConnectorInitialized || purchaseConnector == null) {
                            Log.e(TAG, "❌ Purchase Connector not initialized")
                            result.error("NOT_INITIALIZED", "Purchase Connector not initialized", null)
                            return@setMethodCallHandler
                        }

                        Log.d(TAG, "🔍 Starting Purchase Connector transaction observer...")

                        // Use reflection to start observing transactions
                        val connectorClass = purchaseConnector!!.javaClass
                        val startObservingMethod = connectorClass.getDeclaredMethod("startObservingTransactions")
                        startObservingMethod.invoke(purchaseConnector)

                        Log.d(TAG, "✅ Purchase Connector started successfully")

                        result.success(mapOf(
                            "status" to "started",
                            "message" to "Purchase Connector started successfully",
                            "observing" to true
                        ))
                    } catch (e: Exception) {
                        Log.e(TAG, "❌ Error starting Purchase Connector: ${e.message}", e)
                        result.error("START_FAILED", "Failed to start Purchase Connector: ${e.message}", null)
                    }
                }
                "stopPurchaseConnector" -> {
                    try {
                        if (purchaseConnector != null) {
                            Log.d(TAG, "🛑 Stopping Purchase Connector...")

                            try {
                                // Use reflection to stop observing transactions
                                val connector = purchaseConnector!!
                                val connectorClass = connector.javaClass
                                val stopObservingMethod = connectorClass.getDeclaredMethod("stopObservingTransactions")
                                stopObservingMethod.invoke(connector)

                                Log.d(TAG, "✅ Purchase Connector stopped successfully")
                            } catch (e: Exception) {
                                Log.w(TAG, "Error stopping Purchase Connector: ${e.message}")
                            }
                        }

                        result.success(mapOf(
                            "status" to "stopped",
                            "message" to "Purchase Connector stopped successfully"
                        ))
                    } catch (e: Exception) {
                        Log.e(TAG, "❌ Error stopping Purchase Connector: ${e.message}", e)
                        result.error("STOP_FAILED", "Failed to stop Purchase Connector: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // DevToDev Analytics MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEVTODEV_CHANNEL).setMethodCallHandler { call, result ->
            devToDevHandler.handle(call, result)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            purchaseConnector?.let { connector ->
                // Use reflection to stop observing transactions
                val connectorClass = connector.javaClass
                val stopObservingMethod = connectorClass.getDeclaredMethod("stopObservingTransactions")
                stopObservingMethod.invoke(connector)
            }
            Log.d(TAG, "✅ MainActivity destroyed - Purchase Connector cleaned up")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error cleaning up Purchase Connector: ${e.message}", e)
        }
    }
}
