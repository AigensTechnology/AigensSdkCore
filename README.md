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
pod 'AigensSdkCore', '0.1.3'

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

    implementation 'com.aigens:aigens-sdk-core:5.0.8'
    
    # If you wanna use googlepay
    implementation 'com.aigens:aigens-sdk-googlepay:5.0.1'


    # If you wanna use legacy version, for gradle 7.0.0 or older
    implementation 'com.aigens:aigens-sdk-core-legacy:0.5.3'
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
            <!-- 1. android:autoVerify="true" -->
            <!-- 2. <data android:scheme="https" /> -->
            <!-- 3. <data android:host="domain.name" android:pathPrefix="/toapp" /> -->
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                
                <data android:scheme="https" />
                <data android:host="domain.name" android:pathPrefix="/toapp" />
                
            </intent-filter>
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

## IOS Example

Sample Project: https://github.com/AigensTechnology/AigensSdkDemo

The SDK open a URL for the web UI. The URL can be a predefined URL or scan from an QR code. Developer can use a scanner to obtain the URL and use the following code to open the UI within native app.

* AppDelegate.m

```objc

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"CapacitorOpenURLNotification" object:[NSDictionary dictionaryWithObject: url forKey:@"url"]];
    return YES;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {


    [[NSNotificationCenter defaultCenter] postNotificationName:@"CapacitorOpenUniversalLinkNotification" object:[NSDictionary dictionaryWithObject: userActivity.webpageURL forKey:@"url"]];
        
    return YES;
}


```

* AppDelegate.swift

```swift

import Capacitor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return ApplicationDelegateProxy.shared.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return ApplicationDelegateProxy.shared.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }

}

```

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
            "deviceId": "<deviceId>",
            "universalLink": "<start with https://xxxx>",
            "appScheme": "xxxappScheme",
            "appleMerchantId": "<YourAppleMerchantId>",
            "language": "en"  // en/zh,
            "isGuest": false   // true/false
            
        ]

        let deeplink:Dictionary<String, Any> = [
        
            "addItemId" : "<itemId>",
            "addDiscountCode" : "<discountCode>",
            "addOfferId" : "<offerId>"
            
        ]
        
        options["member"] = member
        options["deeplink"] = deeplink

        options["debug"] = isUat ? true : false;
        
        bridgeVC.options = options

        //closed callback
        WebContainerViewController.closeCB = {
            (result: Any?) in
            if let r = result as? [String: Any], let closedData = r["closedData"] as? [String: Any] {
                if let redirectUrl = closedData["redirectUrl"] as? String, let action = closedData["action"] as? String, action == "xxx" {
                    //redirectUrl
                    print("redirectUrl:\(redirectUrl)")
                }
            }
            print("closeCB:\(result)")
        }
        
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
        member.put("language", "en");
        member.put("isGuest", String.valueOf(false));  // true/false
        
        // from : <data android:scheme="https" />
        //        <data android:host="domain.name" android:pathPrefix="/toapp" />
        member.put("universalLink", "https://xxx.xx.com/toapp");
        member.put("appScheme", "xxappScheme");

        Map<String, String> deeplink = new HashMap<String, String>();
        deeplink.put("addItemId", "<itemId>");
        deeplink.put("addDiscountCode", "<discountCode>");
        deeplink.put("addOfferId", "<offerId>");

        intent.putExtra("member", (Serializable) member);
        intent.putExtra("deeplink", (Serializable) deeplink);

        intent.putExtra("debug", isUat ? true : false);
        
        intent.putExtra("ENVIRONMENT_PRODUCTION", true);
        // intent.putExtra("ENVIRONMENT_PRODUCTION", false);

        //activity.startActivity(intent);
        // for result
        activity.startActivityForResult(intent, WebContainerActivity.REQUEST_CODE_OPEN_URL);

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
                        if ("xxx".equals(action) && redirectUrl != null) {

                        }
                        Log.i("onActivityResult:", object.toString());
                    } catch (Exception e) {
                    }

                }

            }
        }
    }
```

## Member Data

Optionally, pass a member object to automatucally login the customer.

Member Data:
* memberCode - The unique identifier of the member in CRM backend
* source - A merchant brand name string to indicate which brand the member belongs to
* sessionId - Member's current session key for CRM access
* pushId - Provide the push token registered with Google's push service. You can set pushId without other member detail for anonymous user.
* deviceId - Each device is unique, each device is the same value.
* universalLink - Use it to return to the app
  + [ios document](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW1)
  + [android document](https://developer.android.com/training/app-links)
* appleMerchantId - If you has applepay need to set.
* language - en/zh

Deeplink Data:
* addItemId - Item to be added when user navigate to order page.
* addDiscountCode - Discount code to be added automatically.
* addOfferId - Apply the offer that belong to the user when user checkout.

ENVIRONMENT_PRODUCTION
* default: true, set environment for google pay

## Plugins

TBA

## Author

Aigens Technology Limited

Contact the corresponding project manager for additional support.

## License

Aigens SDK is available for merchants with an active subscription.
