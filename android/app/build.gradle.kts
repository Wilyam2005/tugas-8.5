plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // Plugin Firebase (SUDAH BENAR)
    id("com.google.gms.google-services")
}

android {
    // PERBAIKAN 1: Namespace harus sesuai dengan package di Firebase
    namespace = "com.example.w3_grocery_app"
    
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // PERBAIKAN 2: ID ini WAJIB SAMA dengan yang ada di google-services.json
        // Sebelumnya: "com.example.flutter_application_12" (SALAH)
        applicationId = "com.example.w3_grocery_app" // (BENAR)
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// PERBAIKAN 3: Menambahkan Dependencies Firebase (PENTING)
dependencies {
    // Import Firebase BoM (Bill of Materials) agar versi otomatis cocok
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))

    // Tambahkan Analytics (Standar)
    implementation("com.google.firebase:firebase-analytics")
}