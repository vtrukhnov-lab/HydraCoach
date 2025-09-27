buildscript {
    val kotlinVersion = "1.8.10"
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        // Firebase Google Services plugin
        classpath("com.google.gms:google-services:4.4.2")
        // Firebase Crashlytics plugin (для будущего использования)
        classpath("com.google.firebase:firebase-crashlytics-gradle:3.0.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        // DevToDev official Maven repository
        maven {
            url = uri("https://maven.devtodev.com/public")
        }
        // AppsFlyer Purchase Connector artifacts are hosted on the AppsFlyer Maven repo
        maven {
            url = uri("https://maven.appsflyer.com")
        }
        // Mintegral/Mbridge SDK repository
        maven {
            url = uri("https://dl-maven-android.mintegral.com/repository/mbridge_android_sdk_oversea")
        }
        // Chartboost SDK repository
        maven {
            url = uri("https://cboost.jfrog.io/artifactory/chartboost-ads/")
        }
        // BidMachine repository
        maven {
            url = uri("https://artifactory.bidmachine.io/bidmachine")
        }
        // Ogury repository
        maven {
            url = uri("https://maven.ogury.co")
        }
        // Unity Ads repository
        maven {
            url = uri("https://maven.unity.com/repository/public")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}