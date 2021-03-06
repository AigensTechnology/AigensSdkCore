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
pod 'AigensSdkCore', '0.0.12'

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


 # add schemes in info.plist

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
</array>


![image](https://github.com/AigensTechnology/AigensSdkCore/blob/main/ios_schemes.png)


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

    implementation 'com.aigens:aigens-sdk-core:0.0.13'

    # If have googlepay
    implementation 'com.aigens:aigens-sdk-googlepay:0.0.4'
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
<manifest>
    <application>
        ......
        
        <meta-data
            android:name="com.google.android.gms.wallet.api.enabled"
            android:value="true" />
    </application>

    <queries>
        <package android:name="com.tencent.mm" />   // for wechat
        <package android:name="com.octopuscards.nfc_reader" />   // for octopus
        <package android:name="hk.com.hsbc.paymefromhsbc" />   // for payme
    </queries>

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-feature android:name="android.hardware.location.gps" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.CAMERA" />

 </manifest>
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
            "pushId": "<applePushToken>",
            "deviceId": "<deviceId>"
            
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
        member.put("deviceId", "<deviceId>");


        Map<String, String> deeplink = new HashMap<String, String>();
        deeplink.put("addItemId", "<itemId>");
        deeplink.put("addDiscountCode", "<discountCode>");
        deeplink.put("addOfferId", "<offerId>");

        intent.putExtra("member", (Serializable) member);
        intent.putExtra("deeplink", (Serializable) deeplink);

        
        intent.putExtra("ENVIRONMENT_PRODUCTION", true);
        // intent.putExtra("ENVIRONMENT_PRODUCTION", false);

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
- deviceId - Each device is unique, each device is the same value.

Deeplink Data:
- addItemId - Item to be added when user navigate to order page.
- addDiscountCode - Discount code to be added automatically.
- addOfferId - Apply the offer that belong to the user when user checkout.

ENVIRONMENT_PRODUCTION
- default: true, set environment for google pay

## Plugins

TBA


## Author

Aigens Technology Limited

Contact the corresponding project manager for additional support.

## License

Aigens SDK is available for merchants with an active subscription.
