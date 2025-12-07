// LOKASI: android/app/build.gradle.kts

plugins {
    // MASALAHNYA DI SINI: KTS membutuhkan id("string")
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.minumyuk" 
    
    // Pastikan ini adalah String
    compileSdkVersion = "34" 

    ndkVersion = "27.0.12077973" 

    defaultConfig {
        applicationId = "com.example.minumyuk"
        minSdk = 21
        targetSdk = 34
        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }
}

flutter {
    // Menggunakan sintaks yang paling logis yang menyebabkan error terakhir
    // Kita biarkan Gradle mencoba resolver ini lagi
    source.setFrom(setOf("..")) 
}