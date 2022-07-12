# AigensSdkCore

Aigens SDK enable native IOS/Android app to embed Aigens universal UX into the application.

## Requirement

- IOS - Swift 4.2+
- Android - API Level 22+

## IOS Installation


AigensSdkCore is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

Initialize pod file, if not already enabled: 

```ruby
pod init
```

Add AigensSdkCore into Podfile:

```ruby
pod 'AigensSdkCore', '0.0.8'

# If have applepay
pod 'AigensSdkApplepay', '0.0.8'
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

    implementation 'com.aigens:aigens-sdk-core:0.0.8'

    # If have googlepay
    implementation 'com.aigens:aigens-sdk-googlepay:0.0.1'
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

Sample Project: https://github.com/AigensTechnology/AigensSdkDemo

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
            "sessionId" : "<sessionId>",
            "pushId": "<applePushToken>"
            
        ]


        let deeplink:Dictionary<String, Any> = [
        
            "addItemId" : "<itemId>",
            "addDiscountCode" : "<discountCode>",
            "addOfferId" : "<offerId>"
            
        ]
        
        options["member"] = member
        options["deeplink"] = deeplink
        
        bridgeVC.options = options
        
        bridgeVC.modalPresentationStyle = .fullScreen
        self.present(bridgeVC, animated: true)
        
    }
    
}
```

## Android Example

Sample Project: https://github.com/AigensTechnology/AigensSdkDemo


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
        member.put("pushId", "<googlePushToken>");


        Map<String, String> deeplink = new HashMap<String, String>();
        member.put("addItemId", "<itemId>");
        member.put("addDiscountCode", "<discountCode>");
        member.put("addOfferId", "<offerId>");

        intent.putExtra("member", (Serializable) member);
        intent.putExtra("deeplink", (Serializable) deeplink);

        // If hava googlepay, Please add
        String[] extraClasspaths = new String[] {
            "com.aigens.googlepay.GooglePayPlugin",
        };
        intent.putExtra("extraClasspaths", extraClasspaths);

        activity.startActivity(intent);

    }
```

## Member Data

Optionally, pass a member object to automatucally login the customer.

Member Data:
- memberCode - The unique identifier of the member in CRM backend
- source - A merchant brand name string to indicate which brand the member belongs to
- sessionId - Member's current session key for CRM access
- pushId - Provide the push token registered with Google's push service. You can set pushId without other member detail for anonymous user.

Deeplink Data:
- addItemId - Item to be added when user navigate to order page.
- addDiscountCode - Discount code to be added automatically.
- addOfferId - Apply the offer that belong to the user when user checkout.

## Plugins

TBA


## Author

Aigens Technology Limited

Contact the corresponding project manager for additional support.

## License

Aigens SDK is available for merchants with an active subscription.
