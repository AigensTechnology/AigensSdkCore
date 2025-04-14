# ios
```ruby
pod 'AigensSdkCore', '0.1.1'
```

```swift

   func openClicked(url: String, otpToken: String?) {
    
        let bridgeVC = WebContainerViewController()
        
        var options = [String: Any]()
        options["url"] = url
        
        let member:Dictionary<String, Any> = [
        
            xxxx

            xxxx

            "otpToken": otpToken ?? ""
            
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

// implementation 'com.aigens:aigens-sdk-core:5.0.5'

implementation 'com.aigens:aigens-sdk-core-legacy:0.5.0'

```


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


        member.put("otpToken", otpToken);


        intent.putExtra("member", (Serializable) member);
        intent.putExtra("debug", isUat ? true : false);

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