# ios
```ruby
#  updated: 2025-06-16
pod 'AigensSdkCore', '0.1.3'
```

### Add permissions required in "Info.plist" depending on features.
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
	<string>wechat</string>
	<string>alipay</string>
	<string>alipays</string>
	<string>alipayhk</string>
</array>


# uat
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>hkbuuatapp</string>
		</array>
	</dict>
</array>

# prd
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>hkbuprdapp</string>
		</array>
	</dict>
</array>

```
![image](https://github.com/AigensTechnology/AigensSdkCore/blob/main/ios_schemes.png)

### openURl

* If your code use objc, please add the following code to AppDelegate.m

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

* If your code use swift, please add the following code to AppDelegate.swift

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


## iOS USE

```swift

   func openClicked(url: String, otpToken: String?) {
    
        let bridgeVC = WebContainerViewController()
        
        var options = [String: Any]()
        options["url"] = url
        
        var appScheme = isUat ? "hkbuuatapp://localhost" : "hkbuprdapp://localhost";
        
        let member:Dictionary<String, Any> = [
        
            xxxx

            xxxx

            "otpToken": otpToken ?? "",

            "appScheme": appScheme,


            <!-- Please remove universalLink -->
            <!-- "universalLink": "<start with https://xxxx>", -->
            
        ]
        options["member"] = member
        options["debug"] = isUat ? true : false;
        bridgeVC.options = options

        //closed callback
        WebContainerViewController.closeCB = {
            (result: Any?) in
            if let r = result as? [String: Any], let closedData = r["closedData"] as? [String: Any] {
                if let redirectUrl = closedData["redirectUrl"] as? String, let action = closedData["action"] as? String, action == "hkbu-verify-2nd" {
                    //redirectUrl
                    print("redirectUrl:\(redirectUrl)")
                    // emit event
                    self.emitVerify2nd(redirectUrl);
                }
            }
            print("closeCB:\(result)")
        }

        bridgeVC.modalPresentationStyle = .fullScreen
        self.present(bridgeVC, animated: true)
   } 

   openAigensAgain(redirectUrl: String, verifyToken: String) {
        //     //redirectUrl
        openClicked(url: redirectUrl, otpToken: verifyToken)
    }
```


# Android

```groovy

    // updated: 2025-06-16

    implementation 'com.aigens:aigens-sdk-core-legacy:0.5.3'
    implementation 'com.aigens:aigens-sdk-googlepay:0.0.6'

```

### AndroidManifest

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
            <intent-filter>
				<action android:name="android.intent.action.VIEW"/>
				<category android:name="android.intent.category.DEFAULT"/>
				<category android:name="android.intent.category.BROWSABLE"/>

                <!-- uat -->
				<data android:scheme="hkbuuatapp" android:host="localhost"/>
                
                <!-- prd -->
				<data android:scheme="hkbuprdapp" android:host="localhost"/>

			</intent-filter>
        </activity>
        
        <meta-data
            android:name="com.google.android.gms.walletapi.enabled"
            android:value="true" />
    </application>

    <queries>
        <package android:name="com.tencent.mm" />
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

### Google merchant Id 
* Please provide the google-merchant-id for Aigens


## Android USE

```java

    void openUrl(String url, String otpToken) {
        Activity activity = this;
        Intent intent = new Intent(activity, WebContainerActivity.class);
        intent.putExtra("url", url);
         Map<String, String> member = new HashMap<String, String>();

        member.put("xxxx", "xxxx");
        ...
        ...
        ...

        String appScheme = isUat ? "hkbuuatapp://localhost" : "hkbuprdapp://localhost";

        member.put("appScheme", appScheme);

        member.put("otpToken", otpToken);

        // please remove universalLink
        // member.put("universalLink", "https://xxx.xx.com/toapp");


        intent.putExtra("member", (Serializable) member);
        intent.putExtra("debug", isUat ? true : false);


        // for googlepay
        intent.putExtra("ENVIRONMENT_PRODUCTION", isUat ? false : true);
        //activity.startActivity(intent);

        // for result
        activity.startActivityForResult(intent, WebContainerActivity.REQUEST_CODE_OPEN_URL);

    }

    void openAigensAgain(String redirectUrl, String verifyToken) {
        openUrl(redirectUrl, verifyToken);
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
                        if ("hkbu-verify-2nd".equals(action) && redirectUrl != null) {
                            // emit event
                            self.emitVerify2nd(redirectUrl);
                        }
                        Log.i("onActivityResult:", object.toString());
                    } catch (Exception e) {
                    }

                }

            }
        }
    }
```