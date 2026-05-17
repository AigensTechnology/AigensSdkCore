# Aigens SDK Core - Flutter Plugin

## ⚡ Quick Start

### Step 1: Add Dependency

Add the following to your Flutter project's `pubspec.yaml`:

```yaml
dependencies:
  aigens_sdk_core: ^1.0.1
```

### Step 2: Get Dependencies

```bash
flutter pub get
```

### Step 3: Add SPM Package in Xcode (First Time Only)

```bash
open ios/Runner.xcworkspace
```

Then in Xcode:

1. **File** → **Add Package Dependencies...**
2. Enter URL:
   ```
   https://github.com/AigensTechnology/AigensSdkCore.git
   ```
3. Select version:
   - **Branch** → `spm-swift`
4. Select products:
   - ✅ `aigens-sdk-core` (Flutter plugin)
5. Click **Finish**

### Step 4: Run the Project

```bash
flutter run
```

**Done!** 🎉 After the initial setup, you only need to run `flutter pub get` and don't need to repeat Step 3.

---

## 📖 Detailed Instructions

### Why Manual SPM Package Addition is Required?

Flutter 3.16+ supports SPM, but **only automatically handles Flutter-generated plugins**.
Third-party SPM dependencies still need to be manually added to the Xcode project.

The good news is:
- ✅ **Only needs to be added once**
- ✅ Permanent after addition
- ✅ Works normally with `flutter pub get` afterwards

---

## 🔧 Troubleshooting

### Q: How to Verify SPM Package is Correctly Integrated?

In Xcode:
1. Select the project
2. Check the **Package Dependencies** tab
3. You should see `AigensSdkCore`

### Q: What to Do If Build Fails?

Try cleaning cache and rebuilding:

```bash
flutter clean
flutter pub get
flutter build ios
```

---

## 📱 Usage Example

```dart
import 'package:aigens_sdk_core/aigens_sdk_core.dart';

// Open WebContainer
final closedData = await AigensSdkCore.openUrl(
  url: 'https://your-server.com',
  member: MemberData(
    memberCode: 'member123',
    source: 'your-brand',
    universalLink: 'https://your-domain.com',
    appScheme: 'yourapp',
  ),
  deeplink: DeeplinkData(
    addItemId: 'item-001',
    addDiscountCode: 'SAVE10',
  ),
);

// Close WebContainer
await AigensSdkCore.dismiss();
```

---

## 📋 Version Requirements

- **Flutter**: >= 3.16.0
- **Dart**: >= 3.0.0
- **iOS**: >= 13.0
- **Xcode**: >= 14.0

---

## 📞 Technical Support

- GitHub: https://github.com/AigensTechnology/AigensSdkCore
- Issues: https://github.com/AigensTechnology/AigensSdkCore/issues

## 📄 License

See the LICENSE file for details.
