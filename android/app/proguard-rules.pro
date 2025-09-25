# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep AppsFlyer classes (including Purchase Connector)
-keep class com.appsflyer.** { *; }
-dontwarn com.appsflyer.**

# Additional Purchase Connector rules - all possible package structures
-keep class com.appsflyer.purchase.** { *; }
-dontwarn com.appsflyer.purchase.**
-keep class com.appsflyer.purchaseconnector.** { *; }
-dontwarn com.appsflyer.purchaseconnector.**
-keep class com.appsflyer.sdk.purchase.** { *; }
-dontwarn com.appsflyer.sdk.purchase.**
-keep class com.appsflyer.connector.** { *; }
-dontwarn com.appsflyer.connector.**

# Keep all AppsFlyer Purchase Connector interface classes and methods
-keep class * extends com.appsflyer.** { *; }
-keepclassmembers class * {
    @com.appsflyer.** *;
}

# Prevent obfuscation of Purchase Connector configuration and builder classes
-keepnames class **PurchaseConnector* { *; }
-keepnames class **PurchaseConnectorConfig* { *; }
-keepnames class **LogLevel* { *; }

# Keep Flutter classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep DevToDev classes
-keep class com.devtodev.** { *; }
-dontwarn com.devtodev.**