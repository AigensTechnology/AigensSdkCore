# Flutter Example App for Aigens SDK

This is an example Flutter application demonstrating how to use the `aigens_sdk_core` plugin.

## Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. iOS Setup

1. Navigate to `ios/` directory
2. Edit `Podfile` and add:

```ruby
pod 'AigensSdkCore', '0.1.3'

# If using Apple Pay
pod 'AigensSdkApplepay', '0.0.8'
```

3. Run:

```bash
cd ios
pod install
cd ..
```

4. Add required permissions to `ios/Runner/Info.plist` (see main README)

5. Update `ios/Runner/AppDelegate.swift` (see main README)

### 3. Android Setup

1. Edit `android/app/build.gradle` and add:

```groovy
dependencies {
    implementation 'com.aigens:aigens-sdk-core:5.0.8'
    
    // If using Google Pay
    implementation 'com.aigens:aigens-sdk-googlepay:5.0.1'
}
```

2. Ensure `jcenter()` is in `android/settings.gradle`

3. Add required permissions and activities to `android/app/src/main/AndroidManifest.xml` (see main README)

### 4. Run the App

```bash
flutter run
```

## Features Demonstrated

- Opening Aigens WebContainer with member data
- Passing deeplink data
- Checking if apps are installed
- Opening external URLs
- Handling closed data from WebContainer

## Notes

- Replace placeholder values (memberCode, sessionId, etc.) with actual values
- Update `universalLink` and `appScheme` to match your app configuration
- Set `debug: false` for production builds
- For iOS, configure your `appleMerchantId` if using Apple Pay

