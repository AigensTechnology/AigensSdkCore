# AigensSdkCore

Aigens SDK enable native IOS/Android app to embed Aigens universal UX into the application.

## Requirement

IOS - Swift 4.1+
Android - API Level 21+

## IOS Installation


aigens-sdk-core is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

Initialize pod file, if not already enabled: 

```ruby
pod init
```

```ruby
pod 'aigens-sdk-core'
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

```ruby
    repositories {
        google()
        mavenCentral()
        jcenter()
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


## Plugins

TBA


## Author

Aigens Technology Limited

## License

Aigens SDK is available for merchants with an active subscription.
