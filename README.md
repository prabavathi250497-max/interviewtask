
30-09-2025
Assessment 


This document contains a complete, ready-to-run Flutter example that demonstrates an email+password login screen implemented with the BLoC pattern (`flutter_bloc`). It includes:


- A simple login screen with email & password fields.
- Basic validation (empty + email format check).
- Mock authentication calling ReqRes (https://reqres.in/api/login) with a graceful fallback to hardcoded credentials if network fails.
- A small `AuthBloc` with events and states.
- Navigation to a Home screen on success and a logout flow.


---


## Quick notes / test credentials
- ReqRes demo success credentials (use these to get a **real** token from reqres):
- **email:** `flutter@gmail.com`
- **password:** `123456`
- Fallback hardcoded credentials (works offline):
- **email:** `flutter1@gmail.com`
- **password:** `123456`


---


## Project structure (files included in this doc)
```

## How to run
1. Create a new Flutter project and replace/add the files above (or copy into `lib/`).
2. Add the dependencies from `pubspec.yaml` and run `flutter pub get`.
3. Run the app on emulator/device with `flutter run`.
4. Use the ReqRes demo creds (`flutter@gmail.com` / `123456`) to test a successful network login — the token displayed is from ReqRes. If you are offline, use the fallback `flutter1@gmail.com` / `123456` to simulate a successful login.

---

## Next steps / improvements (ideas)
- Persist the token securely (e.g., `flutter_secure_storage`) and restore the auth state on app start.
- Replace multiple `emit` calls on error with a single error flow and/or add a `message` field to `AuthUnauthenticated` for improved UX.
- Add form-level error messages inline below fields instead of just SnackBars.
- Add unit tests for the BLoC and mock the `AuthRepository`.

---

If you want, I can:
- Convert the BLoC to a Cubit (simpler API),
- Add secure storage & auto-login,
- Add unit tests and mocks,
- Or produce a single-file minimal example if you'd prefer.


<!-- end of document -->
Plugin Added / Used

1. flutter_webrtc: ^1.2.0
2. equatable: ^2.0.7
3. cloud_firestore: ^6.0.2
4. permission_handler: ^11.4.0
5. uuid: ^4.5.1
6. flutter_bloc: ^9.1.0




(Important: Do **not** use open rules in production.)

4. Android manifest: set `minSdkVersion 21` and add `INTERNET` permission.

5. Run `flutter pub get`.

6. Run the app on two devices/emulators and press `Join / Create Meeting (hardcoded)` on both. The first press creates the room and the second joins it and completes the offer/answer exchange.

7. Use the microphone and camera toggle buttons, and `screen share` to attempt to share your screen. On Android, `getDisplayMedia` may prompt for a screen-capture permission. On the Web it will show the browser screen picker. On iOS you will need ReplayKit-based implementation (not included here) to capture the screen.

## Notes & Caveats

- This example uses Firestore as the signaling mechanism; Firestore is only used to exchange SDP and ICE candidates — the media path is peer-to-peer.
- For production, implement authentication, permission checks, cleanup, and secure Firestore rules.
- Screen share on iOS requires ReplayKit and additional native code; the `getDisplayMedia` call is supported on Web and on some Android setups using flutter_webrtc but not universally. If screen-sharing fails on a platform, you should fallback to camera video.
- If testing on Android emulators, camera capture sometimes needs enabling via emulator config or use a physical device for best results.
- If you want to use Amazon Chime, Agora, or Twilio SDKs instead, swap the `SignalingRepository` and platform setup; those SDKs provide their own signaling and session management but need keys/credentials.

---

If you want, I can:
- Convert this sample to use Amazon Chime SDK (requires a server to create meetings) — I can provide a server snippet and Flutter platform channels.
- Add a production-ready Firestore / signaling cleanup and reconnect logic.
- Add a small CI-friendly test harness or a minimal server-based signaling using Node.js.





To make the google-services.json config values accessible to Firebase SDKs, you need the Google services Gradle plugin.


Kotlin DSL (build.gradle.kts)

Groovy (build.gradle)
Add the plugin as a dependency to your project-level build.gradle.kts file:

Root-level (project-level) Gradle file (<project>/build.gradle.kts):
plugins {
  // ...

  // Add the dependency for the Google services Gradle plugin
  id("com.google.gms.google-services") version "4.4.3" apply false

}
Then, in your module (app-level) build.gradle.kts file, add both the google-services plugin and any Firebase SDKs that you want to use in your app:

Module (app-level) Gradle file (<project>/<app-module>/build.gradle.kts):
plugins {
  id("com.android.application")

  // Add the Google services Gradle plugin
  id("com.google.gms.google-services")

  ...
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:34.3.0"))


  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  implementation("com.google.firebase:firebase-analytics")


  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}
By using the Firebase Android BoM, your app will always use compatible Firebase library versions. Learn more
After adding the plugin and the desired SDKs, sync your Android project with Gradle files.


<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION" />


<service
    android:name=".YourMediaProjectionService"
    android:exported="false"
    android:foregroundServiceType="mediaProjection"
    android:permission="android.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION" />


4. App Lifecycle & Store-Readiness (Splash Screen Setup)
---------------------------------------------------------------
"Step 1: Update yaml
flutter_launcher_icons:
  android: ""launcher_icon""
  image_path: ""assets/logo.png""
  ios: true
  remove_alpha_ios: true
Step 2: flutter pub get
Step 3:  flutter pub run flutter_launcher_icons:main
Step 4:
flutter_launcher_icons: ^0.14.3"



Build release Setup
-----------------------------

app/build.gradle.ts

signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }


key.properties(Build Credentials)
--------------------------------------

storePassword=Smy@XXXXX
keyPassword=Smy@XXXXXX
keyAlias=action
storeFile=E:/Praba/github/interviewtask/keystore.jks


Test App
-----------
Login Credential
User 1:
flutter@gmail.com/123456
User 2:
flutter1@gmail.com/123456





