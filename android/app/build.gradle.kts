plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ohresto"
    compileSdk = 35 // 🔹 SDK le plus élevé requis par tes plugins

    defaultConfig {
        applicationId = "com.example.ohresto"
        minSdk = 21
        targetSdk = 35 // 🔹 SDK cible mis à jour
        versionCode = 1
        versionName = "1.0"

        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Core library desugaring pour plugins nécessitant Java 8+
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")

    // AndroidX de base
    implementation("androidx.core:core-ktx:1.10.1")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.9.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // Flutter plugins Android
    implementation("androidx.multidex:multidex:2.0.1") // pour multiDex
    // Les autres dépendances Flutter natives sont gérées automatiquement
}

flutter {
    source = "../.."
}
