# honeywell_reader

<?code-excerpt path-base="example/lib"?>

The Unified Honeywell Barcode and RFID library for Android library that adds a comprehensive set of
APIs to easily create powerful applications for Honeywell Barcode Handheld readers and Fixed
readers. Barcode SDK for Android includes class library, sample apps and source code to enable
developers to easily build apps that take full advantage of the power of Honeywell devices. Wraps
platform-specific persistent storage for simple data(NSUserDefaults on iOS and macOS,
SharedPreferences on Android, etc.). Data may be persisted to disk asynchronously, and there is no
guarantee that writes will be persisted to disk after returning, so this plugin must not be used for
storing critical data.

|             | Android |
|-------------|---------|
| **Support** | SDK 26+ |

## Supported Devices

<?code-excerpt "readme_excerpts.dart (Write)"?>

### HandHeld Readers

- EDA52

### Fixed Readers

- ???

## Usage

### Examples

Here are small examples that show you how to use the API.

#### Honeywell Reader Connection

<?code-excerpt "readme_excerpts.dart (Write)"?>

``` dart
// Obtain shared preferences.
final HoneywellReader reader = await HoneywellReader.getInstance();

// Connect to device
await reader.connect();

// Disconnect to device
await reader.disconnect();
```

## Getting Started

# Flutter Package Configuration Guide

## 1. Include Modules in `settings.gradle`

To include the `honeywell_reader_plugin` and `honeywell_reader_data_collection` modules in your
Flutter project, update the `settings.gradle` file located in the `android` directory.

**Path**: `your_project/android/settings.gradle`

### Steps:

1. Open the `settings.gradle` file.
2. Add the following lines to include the required modules:

   ```groovy
   include ":rfid_reader_library"
   include ":data_collection_library"
   ```

This will link the specified modules to your project.

## 2. Set Minimum SDK Version

The minimum SDK version needs to be set to 26. This can be done in the `build.gradle` file for your
app.

### Steps:

1. Open the `build.gradle` file for your app located at `android/app/build.gradle`.
2. Find the `defaultConfig` block and set the `minSdkVersion` to 26:

   ```groovy
   android {
       defaultConfig {
           ...
           minSdkVersion 26
           ...
       }
   }
   ```

This ensures compatibility with the required SDK level.

## 3. Add Required Permissions in `AndroidManifest.xml`

To enable Bluetooth functionality and access fine location services, add the following permissions
to your `AndroidManifest.xml`.

### Steps:

1. Open the `AndroidManifest.xml` file located in the `android/app/src/main/` directory.
2. Add the following permission declarations inside the `<manifest>` tag:

   ```xml
   <uses-permission android:name="android.permission.BLUETOOTH" />
   <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   ```

These permissions are necessary for the RFID reader plugin to function properly.

## 4. Configure Build Types in `build.gradle`

To configure the build types for your project, specifically setting up the release and debug
configurations, update the `build.gradle` file.

**Path**: `your_project/android/app/build.gradle`

### Steps:

1. Open the `build.gradle` file.
2. Locate the `buildTypes` block and update it as follows:

   ```groovy
   buildTypes {
       debug {
           minifyEnabled false
           signingConfig signingConfigs.debug
       }
       release {
           shrinkResources = false
           minifyEnabled = false
           signingConfig signingConfigs.debug
       }
   }
   ```

This configuration disables resource shrinking and minification for the release build, using debug
signing temporarily.

## 5. Add aar files.

Please copy honeywell_reader_plugin and honeywell_reader_data_collection files from example app and
paste android folder in your project.

---

This guide provides the necessary steps to set up and configure the Flutter package with the
required modules, SDK version, permissions, and build types. Make sure to adjust paths and
configurations according to your project structure and requirements.
