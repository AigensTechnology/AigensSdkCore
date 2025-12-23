# Flutter Example App for Aigens SDK

This is an example Flutter application demonstrating how to use the `aigens_sdk_core` plugin.

**Perfect for Flutter beginners!** This guide will walk you through everything step by step.

## 📋 Prerequisites (Before You Start)

Before running this example, make sure you have:

### 1. Flutter Installed

Check if Flutter is installed:
```bash
flutter --version
```

If not installed, follow the official guide:
- **macOS**: https://docs.flutter.dev/get-started/install/macos
- **Windows**: https://docs.flutter.dev/get-started/install/windows
- **Linux**: https://docs.flutter.dev/get-started/install/linux

### 2. Required Tools

**For iOS (macOS only):**
- Xcode (from App Store)
- CocoaPods: `sudo gem install cocoapods`

**For Android:**
- Android Studio: https://developer.android.com/studio
- Android SDK (installed via Android Studio)

**For Web:**
- Chrome browser (usually pre-installed)

### 3. Verify Flutter Setup

```bash
flutter doctor
```

Fix any issues shown by `flutter doctor` before proceeding.

## 🚀 Quick Start

### Step 1: Install Dependencies

Open terminal in this directory (`flutter_example`) and run:

```bash
flutter pub get
```

This downloads all required packages.

**What this does:** Downloads the `aigens_sdk_core` plugin and other dependencies.

### Step 2: Choose Your Platform

You can run this app on:
- 🌐 **Web (Chrome)** - Easiest, no additional setup needed
- 📱 **iOS** - Requires macOS and Xcode
- 🤖 **Android** - Requires Android Studio

---

## 🌐 Running on Web (Chrome) - Easiest Way!

**Note:** The Aigens SDK requires native features, so some features may not work fully on web. However, you can still test the basic structure.

### Steps:

1. **Make sure you're in the project directory:**
   ```bash
   cd flutter_example
   ```

2. **Enable web support (if not already enabled):**
   ```bash
   flutter config --enable-web
   ```

3. **Run on Chrome:**
   ```bash
   flutter run -d chrome
   ```

   Or simply:
   ```bash
   flutter run
   ```
   Then select `Chrome` when prompted.

**What happens:** Flutter will compile your app and open it in Chrome browser automatically.

**Troubleshooting:**
- If Chrome doesn't open, manually open Chrome and go to `http://localhost:xxxxx` (check terminal for the port)
- If you see errors, make sure you ran `flutter pub get` first

---

## 📱 Running on iOS (macOS Only)

### Step 1: Install CocoaPods (if not installed)

```bash
sudo gem install cocoapods
```

### Step 2: Configure iOS Dependencies

1. **Navigate to iOS directory:**
   ```bash
   cd ios
   ```

2. **Open `Podfile` in a text editor** and add these lines inside the `target 'Runner' do` block:

   ```ruby
   target 'Runner' do
     use_frameworks!
     use_modular_headers!
   
     flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
   
   end
   ```

3. **Install iOS dependencies:**
   ```bash
   pod install
   ```

   **What this does:** Downloads iOS native dependencies (Aigens SDK).

4. **Go back to project root:**
   ```bash
   cd ..
   ```

### Step 3: Configure Info.plist

1. **Open** `ios/Runner/Info.plist` in Xcode or a text editor

2. **Add these permissions** (inside `<dict>` tag):

   ```xml
   <!-- URL Schemes -->
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

   <!-- Location Permissions -->
   <key>NSLocationAlwaysUsageDescription</key>
   <string>We need your location to provide better service</string>
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>We need your location to provide better service</string>

   <!-- Camera Permissions -->
   <key>NSCameraUsageDescription</key>
   <string>We need camera access for QR code scanning</string>
   <key>NSPhotoLibraryAddUsageDescription</key>
   <string>We need photo library access</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>We need photo library access</string>

   <!-- Calendar Permission -->
   <key>NSCalendarsUsageDescription</key>
   <string>We need calendar access to add events</string>
   ```

### Step 4: Configure AppDelegate.swift

1. **Open** `ios/Runner/AppDelegate.swift`

2. **Add this import at the top:**
   ```swift
   import Capacitor
   ```

3. **Add these methods** inside the `AppDelegate` class:

   ```swift
   func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
       return ApplicationDelegateProxy.shared.application(app, open: url, options: options)
   }

   func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
       return true
   }

   func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
       return ApplicationDelegateProxy.shared.application(application, continue: userActivity, restorationHandler: restorationHandler)
   }
   ```

### Step 5: Run on iOS

**Option A: Using Terminal**
```bash
flutter run
```
Then select `iPhone` or `iOS Simulator` when prompted.

**Option B: Using Xcode**
1. Open `ios/Runner.xcworkspace` (NOT `.xcodeproj`) in Xcode
2. Select a simulator or connected device
3. Click the Run button (▶️)

**What happens:** Flutter compiles the app and runs it on iOS simulator or your connected iPhone.

---

## 🤖 Running on Android


### Step 1: Configure AndroidManifest.xml

1. **Open** `android/app/src/main/AndroidManifest.xml`

2. **Add these inside `<manifest>` tag:**

   ```xml
   <manifest>
       <application>
           <!-- Add WebContainerActivity -->
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
           </activity>
           
           <!-- Google Pay meta-data -->
           <meta-data
               android:name="com.google.android.gms.walletapi.enabled"
               android:value="true" />
       </application>

       <!-- Queries for external apps -->
       <queries>
           <package android:name="com.tencent.mm" />
           <package android:name="com.octopuscards.nfc_reader" />
           <package android:name="hk.com.hsbc.paymefromhsbc" />
           <package android:name="com.macaupass.rechargeEasy" />
           <package android:name="hk.alipay.wallet" />
           <package android:name="com.eg.android.AlipayGphone" />
       </queries>

       <!-- Permissions -->
       <uses-permission android:name="android.permission.INTERNET" />
       <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
       <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
       <uses-feature android:name="android.hardware.location.gps" />
       <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
       <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
       <uses-permission android:name="android.permission.CAMERA" />
       <uses-permission android:name="android.permission.WRITE_CALENDAR"/>
       <uses-permission android:name="android.permission.READ_CALENDAR"/>
   </manifest>
   ```

### Step 4: Run on Android

**Option A: Using Terminal**
```bash
flutter run
```
Then select an Android emulator or connected device when prompted.

**Option B: Using Android Studio**
1. Open `android/` folder in Android Studio
2. Wait for Gradle sync to complete
3. Select an emulator or connected device
4. Click Run (▶️)

**What happens:** Flutter compiles the app and runs it on Android emulator or your connected Android device.

---

## 🎯 Features Demonstrated

This example app shows how to:

- ✅ Open Aigens WebContainer with member data
- ✅ Pass deeplink data for navigation
- ✅ Check if apps are installed (e.g., WeChat)
- ✅ Open external URLs
- ✅ Handle closed data from WebContainer

## ⚙️ Configuration Notes

Before running, you may want to update these values in `lib/main.dart`:

```dart
// Replace these with your actual values:
memberCode: 'testMember123',        // Your CRM member ID
source: 'testMerchant',              // Your merchant name
sessionId: 'testSession123',         // User session ID
pushId: 'testPushToken123',          // Push notification token
deviceId: 'testDevice123',           // Unique device ID
universalLink: 'https://yourdomain.com/toapp',  // Your universal link
appScheme: 'yourappscheme',          // Your app URL scheme
appleMerchantId: 'merchant.your.merchant.id',  // iOS Apple Pay merchant ID
```

## 🐛 Common Issues & Solutions

### Issue: "flutter: command not found"
**Solution:** Make sure Flutter is installed and added to your PATH. Run `flutter doctor` to check.

### Issue: "CocoaPods not found" (iOS)
**Solution:** Install CocoaPods: `sudo gem install cocoapods`

### Issue: "No devices found"
**Solution:** 
- **iOS**: Open Xcode and start a simulator, or connect an iPhone
- **Android**: Start an Android emulator from Android Studio, or connect an Android device with USB debugging enabled

### Issue: "Gradle sync failed" (Android)
**Solution:** 
- Make sure `jcenter()` is in `settings.gradle`
- Check your internet connection
- Try: `cd android && ./gradlew clean`

### Issue: "Pod install failed" (iOS)
**Solution:**
- Make sure you're using `.xcworkspace` file, not `.xcodeproj`
- Try: `cd ios && pod deintegrate && pod install`

### Issue: App crashes when opening WebContainer
**Solution:**
- Make sure you've added all required permissions in `Info.plist` (iOS) or `AndroidManifest.xml` (Android)
- Check that native SDK dependencies are properly installed

## 📚 Learning Resources

- **Flutter Basics**: https://docs.flutter.dev/get-started/learn-more
- **Flutter Plugin Development**: https://docs.flutter.dev/development/packages-and-plugins/developing-packages
- **Aigens SDK Documentation**: See `../aigens_sdk_core/README.md`

## 💡 Tips for Beginners

1. **Start with Web**: If you're new to Flutter, try running on web first - it's the easiest!
2. **Use VS Code or Android Studio**: These IDEs have great Flutter support
3. **Check Terminal Output**: When something goes wrong, read the error messages carefully
4. **Run `flutter doctor`**: This command helps identify setup issues
5. **Clean Build**: If things get stuck, try `flutter clean && flutter pub get`

## 🆘 Need Help?

- Check the main plugin README: `../aigens_sdk_core/README.md`
- Flutter documentation: https://docs.flutter.dev
- Flutter community: https://flutter.dev/community

---

**Happy Coding! 🎉**

