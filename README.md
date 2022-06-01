# AigensSdkCore

Aigens SDK enable native IOS/Android app to embed Aigens universal UX into the application.

## Requirement

- IOS - Swift 4.2+
- Android - API Level 21+

## IOS Installation


AigensSdkCore is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

Initialize pod file, if not already enabled: 

```ruby
pod init
```

Add AigensSdkCore into Podfile:

```ruby
pod 'AigensSdkCore', '0.0.6'
```

Run pod install to download the dependency.

```ruby
pod install
```

Add permissions required in "Info.plist" depending on features.

```ruby

#GPS Feature
 - NSLocationAlwaysUsageDescription (Privacy - Location Always Usage Description)
 - NSLocationWhenInUseUsageDescription (Privacy - Location When In Use Usage Description)

#Camera Feature
 - NSCameraUsageDescription (Privacy - Camera Usage Description)
 - NSPhotoLibraryAddUsageDescription (Privacy - Photo Library Additions Usage Description)
 - NSPhotoLibraryUsageDescription (Privacy - Photo Library Usage Description)

```

## Android Installation

Make sure jcenter() is part of reporsitory in the "settings.gradle" config.
Newer Android projects might not automatically include this repository.

```gradle
    repositories {
        google()
        mavenCentral()
        jcenter()
    }
```

Include the aigens-sdk-core dependency in "build.gradle".

```gradle
dependencies {

    implementation 'com.aigens:aigens-sdk-core:0.0.6'

}
```

Include the actvity in "AndroidManifest.xml".

```xml
    <activity
        android:name="com.aigens.sdk.WebContainerActivity"
        android:screenOrientation="portrait" />
```

Add permissions required in "AndroidManifest.xml" depending on features. 

```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-feature android:name="android.hardware.location.gps" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.CAMERA" />
```
## IOS Example

Sample Project: TBA

The SDK open a URL for the web UI. The URL can be a predefined URL or scan from an QR code. Developer can use a scanner to obtain the URL and use the following code to open the UI within native app.


```swift
import UIKit
import Foundation
import aigens_sdk_core

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openClicked(_ sender: Any) {
        
        let url = "https://scantest.aigens.com/scan?code=c3RvcmU9NTAwJnNwb3Q9MSZwYWdlPWJ5b2Q="
        
        let bridgeVC = WebContainerViewController()
        
        var options = [String: Any]()
        options["url"] = url
        
        let member:Dictionary<String, Any> = [
        
            "memberCode" : "<crmMemberId>",
            "source" : "<merchant>",
            "sessionId" : "<sessionId>"
            
        ]
        
        options["member"] = member
        
        bridgeVC.options = options;
        
        bridgeVC.modalPresentationStyle = .fullScreen
        self.present(bridgeVC, animated: true);
        
    }
    
}
```

## Android Example

Member information can be passed as input to automatically login the current user.

```java

import com.aigens.sdk.WebContainerActivity;

//...

    private void openUrl(){

        Activity activity = this;
        Intent intent = new Intent(activity, WebContainerActivity.class);

        String url = "https://scantest.aigens.com/scan?code=c3RvcmU9NTAwJnNwb3Q9MSZwYWdlPWJ5b2Q=";

        intent.putExtra("url", url);

        Map<String, String> member = new HashMap<String, String>();
        member.put("memberCode", "<crmMemberId>");
        member.put("source", "<merchant>");
        member.put("sessionId", "<sessionId>");

        intent.putExtra("member", (Serializable) member);

        activity.startActivity(intent);

    }
```

## Member Data

Optionally, pass a member object to automatucally login the customer.

Member Data:
- memberCode - The unique identifier of the member in CRM backend
- source - A merchant brand name string to indicate which brand the member belongs to
- sessionId - Member's current session key for CRM access


## Plugins

TBA


## Author

Aigens Technology Limited

Contact the corresponding project manager for additional support.

## License

Aigens SDK is available for merchants with an active subscription.
