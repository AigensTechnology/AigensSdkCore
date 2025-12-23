package com.aigens.sdk.flutter;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.aigens.sdk.WebContainerActivity;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class AigensSdkCorePlugin implements FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private MethodChannel channel;
    private Activity activity;
    private MethodChannel.Result pendingResult;
    private ActivityPluginBinding activityBinding;

    private static final int REQUEST_CODE_OPEN_URL = WebContainerActivity.REQUEST_CODE_OPEN_URL;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "aigens_sdk_core");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "openUrl":
                handleOpenUrl(call, result);
                break;
            case "dismiss":
                handleDismiss(call, result);
                break;
            case "isInstalledApp":
                handleIsInstalledApp(call, result);
                break;
            case "openExternalUrl":
                handleOpenExternalUrl(call, result);
                break;
            case "getIsProductionEnvironment":
                handleGetIsProductionEnvironment(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void handleOpenUrl(MethodCall call, MethodChannel.Result result) {
        if (activity == null) {
            result.error("NO_ACTIVITY", "Activity is not available", null);
            return;
        }

        Map<String, Object> args = (Map<String, Object>) call.arguments;
        String url = (String) args.get("url");
        if (url == null) {
            result.error("INVALID_ARGUMENT", "URL is required", null);
            return;
        }

        try {
            // Direct import and usage of WebContainerActivity (no reflection needed)
            Intent intent = new Intent(activity, WebContainerActivity.class);
            intent.putExtra("url", url);

            // Add member data
            Map<String, Object> member = (Map<String, Object>) args.get("member");
            if (member != null) {
                HashMap<String, String> memberMap = new HashMap<>();
                for (Map.Entry<String, Object> entry : member.entrySet()) {
                    if (entry.getValue() != null) {
                        memberMap.put(entry.getKey(), entry.getValue().toString());
                    }
                }
                intent.putExtra("member", (Serializable) memberMap);
            }

            // Add deeplink data
            Map<String, Object> deeplink = (Map<String, Object>) args.get("deeplink");
            if (deeplink != null) {
                HashMap<String, String> deeplinkMap = new HashMap<>();
                for (Map.Entry<String, Object> entry : deeplink.entrySet()) {
                    if (entry.getValue() != null) {
                        deeplinkMap.put(entry.getKey(), entry.getValue().toString());
                    }
                }
                intent.putExtra("deeplink", (Serializable) deeplinkMap);
            }

            // Add debug flag
            Boolean debug = (Boolean) args.get("debug");
            if (debug != null) {
                intent.putExtra("debug", debug);
            }

            // Add environment production flag
            Boolean environmentProduction = (Boolean) args.get("ENVIRONMENT_PRODUCTION");
            if (environmentProduction != null) {
                intent.putExtra("ENVIRONMENT_PRODUCTION", environmentProduction);
            } else {
                intent.putExtra("ENVIRONMENT_PRODUCTION", true);
            }

            // Store result for activity result callback
            pendingResult = result;

            // Start activity for result
            activity.startActivityForResult(intent, REQUEST_CODE_OPEN_URL);
        } catch (Exception e) {
            result.error("ERROR", "Failed to open URL: " + e.getMessage(), null);
        }
    }

    private void handleDismiss(MethodCall call, MethodChannel.Result result) {
        if (activity != null && activity.hasWindowFocus()) {
            activity.finish();
            result.success(true);
        } else {
            result.success(false);
        }
    }

    private void handleIsInstalledApp(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> args = (Map<String, Object>) call.arguments;
        String urlScheme = (String) args.get("key");
        if (urlScheme == null) {
            result.error("INVALID_ARGUMENT", "URL scheme is required", null);
            return;
        }

        try {
            Intent intent = new Intent(Intent.ACTION_VIEW, android.net.Uri.parse(urlScheme));
            boolean canOpen = intent.resolveActivity(activity.getPackageManager()) != null;
            result.success(canOpen);
        } catch (Exception e) {
            result.error("ERROR", "Failed to check installed app: " + e.getMessage(), null);
        }
    }

    private void handleOpenExternalUrl(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> args = (Map<String, Object>) call.arguments;
        String url = (String) args.get("url");
        if (url == null) {
            result.error("INVALID_ARGUMENT", "URL is required", null);
            return;
        }

        try {
            Intent intent = new Intent(Intent.ACTION_VIEW, android.net.Uri.parse(url));
            
            if (intent.resolveActivity(activity.getPackageManager()) == null) {
                result.error("CANNOT_OPEN", "Cannot open URL: " + url, null);
                return;
            }

            activity.startActivity(intent);
            result.success(true);
        } catch (Exception e) {
            result.error("ERROR", "Failed to open external URL: " + e.getMessage(), null);
        }
    }

    private void handleGetIsProductionEnvironment(MethodCall call, MethodChannel.Result result) {
        result.success(true);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_OPEN_URL) {
            MethodChannel.Result result = pendingResult;
            pendingResult = null;

            if (resultCode == Activity.RESULT_OK && data != null) {
                Bundle extras = data.getExtras();
                if (extras != null) {
                    String closedDataJson = extras.getString("closedData");
                    if (closedDataJson != null) {
                        try {
                            org.json.JSONObject closedDataObject = new org.json.JSONObject(closedDataJson);

                            HashMap<String, Object> closedDataMap = new HashMap<>();
                            closedDataMap.put("redirectUrl", closedDataObject.optString("redirectUrl"));
                            closedDataMap.put("action", closedDataObject.optString("action"));

                            HashMap<String, Object> resultMap = new HashMap<>();
                            resultMap.put("closedData", closedDataMap);

                            if (result != null) {
                                result.success(resultMap);
                            }
                            return true;
                        } catch (org.json.JSONException e) {
                            // JSON 解析失败，返回空的 closedData
                            HashMap<String, Object> resultMap = new HashMap<>();
                            HashMap<String, Object> emptyClosedData = new HashMap<>();
                            resultMap.put("closedData", emptyClosedData);
                            if (result != null) {
                                result.success(resultMap);
                            }
                            return true;
                        }
                    }
                }
            }

            // 返回空的 closedData
            HashMap<String, Object> resultMap = new HashMap<>();
            HashMap<String, Object> emptyClosedData = new HashMap<>();
            resultMap.put("closedData", emptyClosedData);
            if (result != null) {
                result.success(resultMap);
            }
            return true;
        }
        return false;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
        this.activityBinding = binding;
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.activity = null;
        if (this.activityBinding != null) {
            this.activityBinding.removeActivityResultListener(this);
        }
        this.activityBinding = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
        this.activityBinding = binding;
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        this.activity = null;
        if (this.activityBinding != null) {
            this.activityBinding.removeActivityResultListener(this);
        }
        this.activityBinding = null;
    }
}