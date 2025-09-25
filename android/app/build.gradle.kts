import java.util.Properties
import java.io.File

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Загружаем настройки ключа
val keystoreProperties = Properties()
val keystorePropertiesFile = File(rootProject.projectDir, "key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
    println("✅ Key properties loaded: ${keystoreProperties.keys}")
} else {
    println("❌ Key properties file not found: ${keystorePropertiesFile.absolutePath}")
}

android {
    namespace = "com.playcus.hydracoach"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Принудительно включить все зависимости в APK
    packagingOptions {
        pickFirst("**/libfbjni.so")
        pickFirst("**/libjsc.so")
        pickFirst("**/libc++_shared.so")
        pickFirst("**/libhermes.so")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        applicationId = "com.playcus.hydracoach"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 33
        versionName = "2.1.1"
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

// Принудительное разрешение всех конфликтов версий
configurations.all {
    resolutionStrategy {
        force("com.appsflyer:purchase-connector:2.1.0")
        cacheDynamicVersionsFor(0, "seconds")
        cacheChangingModulesFor(0, "seconds")
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Google Play Billing Library (требуется для Purchase Connector)
    implementation("com.android.billingclient:billing:7.1.1")

    // AppsFlyer Purchase Connector для IAP валидации (ЯВНАЯ зависимость)
    implementation("com.appsflyer:purchase-connector:2.1.0") {
        isTransitive = true
        exclude(group = "com.android.support")
    }
    // Принудительно включаем как API dependency
    api("com.appsflyer:purchase-connector:2.1.0") {
        isTransitive = true
    }

    // Дополнительное принуждение через runtimeOnly
    runtimeOnly("com.appsflyer:purchase-connector:2.1.0")

    // Альтернативные версии для тестирования:
    // implementation("com.appsflyer:purchase-connector:2.1.1")
    // implementation("com.appsflyer:purchase-connector:2.0.1")

    // DevToDev Analytics SDK v2 (stable version)
    implementation("com.devtodev:android-analytics:2.5.1")
    implementation("com.devtodev:android-google:1.0.1")
}
