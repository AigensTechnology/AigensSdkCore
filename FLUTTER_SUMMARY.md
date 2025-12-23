# aigens_sdk_core

Flutter plugin for Aigens SDK - enables native iOS/Android apps to embed Aigens universal UX.

## Installation

### Install from pub.dev (Recommended) ✅

If published to pub.dev, simply add to your `pubspec.yaml`:

```yaml
dependencies:
  aigens_sdk_core: ^0.1.3
```

Then run:

```bash
flutter pub get
```

### iOS Setup

1. Add required permissions to `ios/Runner/Info.plist`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>weixinULAPI</string>
    <string>weixin</string>
    <string>octopus</string>
    <string>wechat</string>
    <string>hsbcpaymepay</string>
    <string>alipay</string>
    <string>alipays</string>
    <string>alipayhk</string>
    <string>mpay</string>
    <string>gcash</string>
</array>

<!-- GPS Feature -->
<key>NSLocationAlwaysUsageDescription</key>
<string>We need your location to provide better service</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to provide better service</string>

<!-- Camera Feature -->
<key>NSCameraUsageDescription</key>
<string>We need camera access for QR code scanning</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need photo library access</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access</string>

<!-- Calendar -->
<key>NSCalendarsUsageDescription</key>
<string>We need calendar access to add events</string>
```

4. Configure AppDelegate (Swift):

```swift
    import Capacitor

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ApplicationDelegateProxy.shared.application(app, open: url, options: options)
    }

    override func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return ApplicationDelegateProxy.shared.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
```

### Android Setup

1. Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <activity
            android:name="com.aigens.sdk.WebContainerActivity"
            android:screenOrientation="portrait"
            android:exported="true"
            android:launchMode="singleTask">
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="https" />
                <data android:host="domain.name" android:pathPrefix="/toapp" />
            </intent-filter>
            <intent-filter>
				        <action android:name="android.intent.action.VIEW"/>
				        <category android:name="android.intent.category.DEFAULT"/>
				        <category android:name="android.intent.category.BROWSABLE"/>
				        <data android:scheme="xxxxapp"/>
			      </intent-filter>
        </activity>
        
    </application>

</manifest>
```

## Usage

```dart
import 'package:aigens_sdk_core/aigens_sdk_core.dart';

// Open WebContainer
final closedData = await AigensSdkCore.openUrl(
  url: 'https://scantest.aigens.com/scan?code=c3RvcmU9NTAwJnNwb3Q9MSZwYWdlPWJ5b2Q=',
  member: MemberData(
    memberCode: '<crmMemberId>',
    source: '<merchant>',
    sessionId: '<sessionId>',
    deviceId: '<deviceId>',
    universalLink: 'https://yourdomain.com/toapp',
    appScheme: 'yourappscheme',
    appleMerchantId: '<YourAppleMerchantId>', // iOS only
    language: 'en', // or 'zh'
    isGuest: false,
  ),
  deeplink: DeeplinkData(
    addItemId: '<itemId>',
    addDiscountCode: '<discountCode>',
    addOfferId: '<offerId>',
  ),
  debug: false, // Set to true for UAT
  clearCache: false,
  environmentProduction: true,
);

if (closedData != null) {
  print('Redirect URL: ${closedData.redirectUrl}');
  print('Action: ${closedData.action}');
}

// Check if app is installed
final isInstalled = await AigensSdkCore.isInstalledApp('weixin://');

// Open external URL
await AigensSdkCore.openExternalUrl('https://example.com');
```

## API Reference

### AigensSdkCore.openUrl

Opens the Aigens WebContainer with the specified URL.

**Parameters:**
- `url` (required): The URL to open in the WebContainer
- `member`: Optional member data for automatic login
- `deeplink`: Optional deeplink data for navigation
- `debug`: Enable debug mode (default: false)
- `clearCache`: Clear web cache before opening (default: false)
- `environmentProduction`: Set production environment (default: true)
- `externalProtocols`: Additional external URL protocols
- `addPaddingProtocols`: Additional padding protocols
- `excludedUniversalLinks`: URLs to exclude from universal links
- `exitUniversalLinks`: URLs that should exit the app

**Returns:** `Future<ClosedData?>` - Data returned when WebContainer is closed

### MemberData

- `memberCode`: The unique identifier of the member in CRM backend
- `source`: A merchant brand name string
- `sessionId`: Member's current session key for CRM access
- `deviceId`: Unique device identifier
- `universalLink`: Universal link to return to the app (start with https://)
- `appScheme`: App scheme for deep linking
- `appleMerchantId`: Apple Merchant ID (required if using Apple Pay)
- `language`: Language preference ("en" or "zh")
- `isGuest`: Whether the user is a guest

### DeeplinkData

- `addItemId`: Item to be added when user navigates to order page
- `addDiscountCode`: Discount code to be added automatically
- `addOfferId`: Apply the offer that belongs to the user when user checks out

### ClosedData

Returned when WebContainer is closed:

- `redirectUrl`: Redirect URL after closing
- `action`: Action type

## License

Aigens SDK is available for merchants with an active subscription.

