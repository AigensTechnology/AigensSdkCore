#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(CorePlugin, "Core",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(dismiss, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(finish, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(openBrowser, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(openSecondBrowser, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getDeeplink, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getMember, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(isInstalledApp, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(openExternalUrl, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getIsProductionEnvironment, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(checkNotificationPermissions, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getFinishData, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setTextZoom, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(readClipboard, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(addCalendar, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(makeHKFPSPayment, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setScreenName, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(logEvent, CAPPluginReturnPromise);
           
           
           

)
