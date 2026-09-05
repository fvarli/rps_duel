import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load android/key.properties if present; otherwise leave the Properties empty
// and the release build will fall back to debug signing further below.
val keyProperties = Properties()
val keyPropertiesFile = rootProject.file("key.properties")
if (keyPropertiesFile.exists()) {
    keyPropertiesFile.inputStream().use { keyProperties.load(it) }
}
val hasReleaseSigning = keyPropertiesFile.exists()

android {
    namespace = "com.lunexa.games.rpsduel"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.lunexa.games.rpsduel"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                keyAlias = keyProperties["keyAlias"] as String?
                keyPassword = keyProperties["keyPassword"] as String?
                storePassword = keyProperties["storePassword"] as String?
                val storeFilePath = keyProperties["storeFile"] as String?
                if (storeFilePath != null) {
                    storeFile = file(storeFilePath)
                }
            }
        }
    }

    buildTypes {
        // Local development identities only — release is untouched below.
        //
        // The debug/profile builds install as `com.lunexa.games.rpsduel.dev`
        // so they coexist with the Google Play production install on a
        // physical device. Without this, `flutter run` would hit a signature
        // mismatch against the Play-signed app and its installer would
        // silently `adb uninstall` production (and all of its user data)
        // before retrying — see AndroidDevice.installApp in flutter_tools.
        //
        // Only `applicationId` is suffixed. `namespace` stays
        // com.lunexa.games.rpsduel, so `.MainActivity` and every R class
        // still resolve, and the release application ID, signing config and
        // version semantics are unaffected.
        debug {
            applicationIdSuffix = ".dev"
        }
        // `profile` is contributed by the Flutter Gradle Plugin. Suffix it
        // too: `flutter run --profile` is ordinary development and must not
        // be able to collide with the Play install either.
        maybeCreate("profile").applicationIdSuffix = ".dev"
        release {
            // Use release signing if android/key.properties is configured;
            // otherwise fall back to debug signing so dev `flutter run --release`
            // and CI `flutter build appbundle --release` keep working for
            // contributors without a keystore. Debug-signed AABs cannot be
            // uploaded to Play Console — see docs/release_android.md for the
            // real release workflow.
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
