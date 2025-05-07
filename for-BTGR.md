# AigensSdkCore

Aigens SDK enable native IOS/Android app to embed Aigens universal UX into the application.

## Requirement

* IOS - Swift 4.2+ , IOS 12+
* Android - API Level 28+, Android 9+

## IOS Installation

AigensSdkCore is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

Initialize pod file, if not already enabled: 

```ruby
pod init
```

Add AigensSdkCore into Podfile:

```ruby
pod 'AigensSdkCore', '0.1.1'

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

 #Calendar
 - NSCalendarsUsageDescription

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
    <string>mpay</string>
    <string>gcash</string>
</array>

```
![image](https://github.com/AigensTechnology/AigensSdkCore/blob/main/ios_schemes.png)

## Errors

* If got error: Sandbox: rsync.samba xxxxx
* Please set: User Script Sandboxing : No
![image](https://github.com/AigensTechnology/AigensSdkCore/blob/main/sandboxRsync.png)



```swift
import UIKit
import Foundation
import aigens_sdk_core

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // url:  https://xxx.order.place/crm/brand/xxxx/directory?brandId=xxxx
    
    // mode: takeaway / dinein 
    // store url: https://xxx.order.place/order/store/xxx/mode/xxx?brandId=xxxxx
   func openClicked(url: String) {
    
        let bridgeVC = WebContainerViewController()
        
        var options = [String: Any]()
        options["url"] = url
        
        let member:Dictionary<String, Any> = [
        
            "source" : "btgr",
            "sessionId" : "<MemberID>",
            "deviceId": "<deviceId>",
            "language": "en"  // en/zh,
            "isGuest": false   // true/false: (wether log in or not)
            
        ]


        options["member"] = member
        options["debug"] = isUat ? true : false; 
        bridgeVC.options = options

        //closed callback
        WebContainerViewController.closeCB = {
            (result: Any?) in
            if let r = result as? [String: Any], let closedData = r["closedData"] as? [String: Any] {
                if let redirectUrl = closedData["redirectUrl"] as? String, let action = closedData["action"] as? String, action == "btgr-top-up-action" {
                    //redirectUrl
                    print("redirectUrl:\(redirectUrl)")
                    
                    self.openAigensAgain(redirectUrl);
                }
            }
            print("closeCB:\(result)")
        }

        bridgeVC.modalPresentationStyle = .fullScreen
        self.present(bridgeVC, animated: true)
   } 

   openAigensAgain(redirectUrl: String) {
        // do top-up first
        .....

        // Then
        openClicked(url: redirectUrl)
    }
    
}
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

```groovy
dependencies {

    # Required
    # classpath 'com.android.tools.build:gradle:8.0.0'
    # distributionUrl=https\://services.gradle.org/distributions/gradle-8.0.2-all.zip
    # Android Studio Flamingo | 2022.2.1 or newer

    implementation 'com.aigens:aigens-sdk-core:5.0.5'
    
    # If you wanna use googlepay
    implementation 'com.aigens:aigens-sdk-googlepay:5.0.1'


    # If you wanna use legacy version, for gradle 7.0.0 or older
    implementation 'com.aigens:aigens-sdk-core-legacy:0.5.0'
    # If you wanna use googlepay
    implementation 'com.aigens:aigens-sdk-googlepay:0.0.6'
}
```

Include the actvity in "AndroidManifest.xml".

Add permissions required in "AndroidManifest.xml" depending on features. 

```xml
<manifest>
    <application>

        <activity
            android:name="com.aigens.sdk.WebContainerActivity"
            android:screenOrientation="portrait"
            android:exported="true"
            android:launchMode="singleTask"
            >
        </activity>
        
        <meta-data
            android:name="com.google.android.gms.walletapi.enabled"
            android:value="true" />
    </application>

    <queries>
        <package android:name="com.tencent.mm" />
        <package android:name="com.octopuscards.nfc_reader" /> 
        <package android:name="hk.com.hsbc.paymefromhsbc" />
        <package android:name="com.macaupass.rechargeEasy" />
        <package android:name="hk.alipay.wallet" />
        <package android:name="com.eg.android.AlipayGphone" />
    </queries>

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-feature android:name="android.hardware.location.gps" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.CAMERA" />
    
    <!-- calendar -->
    <uses-permission android:name="android.permission.WRITE_CALENDAR"/>
    <uses-permission android:name="android.permission.READ_CALENDAR"/>

 </manifest>
```



```java

import com.aigens.sdk.WebContainerActivity;


    // url:  https://xxx.order.place/crm/brand/xxxx/directory?brandId=xxxx
    
    // mode: takeaway / dinein 
    // store url: https://xxx.order.place/order/store/xxx/mode/xxx?brandId=xxxxx
    void openUrl(String url) {
        Activity activity = this;
        Intent intent = new Intent(activity, WebContainerActivity.class);
        intent.putExtra("url", url);
         Map<String, String> member = new HashMap<String, String>();

        member.put("source", "btgr");
        member.put("sessionId", "<MemberID>");
        member.put("deviceId", "<deviceId>");
        member.put("language", "en");  // en/zh,
        member.put("isGuest", String.valueOf(false));  // true/false: (wether log in or not)
        
    
        intent.putExtra("member", (Serializable) member);

        intent.putExtra("debug", isUat ? true : false);
        

        // for google pay
        intent.putExtra("ENVIRONMENT_PRODUCTION", isUat ? true : false);

        // for result
        activity.startActivityForResult(intent, WebContainerActivity.REQUEST_CODE_OPEN_URL);

    }

    void openAigensAgain(String redirectUrl) {
        // do top-up first
        .....

        // Then
        openUrl(redirectUrl);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (WebContainerActivity.REQUEST_CODE_OPEN_URL == requestCode) {
            if (resultCode == RESULT_OK && data != null) {

                Bundle extras = data.getExtras();
                if (extras != null) {
                    try {
                        String closedData = extras.getString("closedData");
                        JSONObject object = new JSONObject(closedData);
                        String redirectUrl = object.getString("redirectUrl");
                        String action = object.getString("action");
                        if ("btgr-top-up-action".equals(action) && redirectUrl != null) {
                            
                            self.openAigensAgain(redirectUrl);
                        }
                        Log.i("onActivityResult:", object.toString());
                    } catch (Exception e) {
                    }

                }

            }
        }
    }
```