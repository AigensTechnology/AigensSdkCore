package com.aigens.sdk.flutter

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class AigensSdkCorePlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  private var pendingResult: Result? = null
  private var activityBinding: ActivityPluginBinding? = null

  companion object {
    const val REQUEST_CODE_OPEN_URL = 100001
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "aigens_sdk_core")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "openUrl" -> handleOpenUrl(call, result)
      "dismiss" -> handleDismiss(call, result)
      "isInstalledApp" -> handleIsInstalledApp(call, result)
      "openExternalUrl" -> handleOpenExternalUrl(call, result)
      "getIsProductionEnvironment" -> handleGetIsProductionEnvironment(call, result)
      else -> result.notImplemented()
    }
  }

  private fun handleOpenUrl(call: MethodCall, result: Result) {
    val activity = this.activity
    if (activity == null) {
      result.error("NO_ACTIVITY", "Activity is not available", null)
      return
    }

    val args = call.arguments as? Map<*, *>
    val url = args?.get("url") as? String
    if (url == null) {
      result.error("INVALID_ARGUMENT", "URL is required", null)
      return
    }

    try {
      // Import WebContainerActivity from Aigens SDK
      // This requires adding the dependency: implementation 'com.aigens:aigens-sdk-core:5.0.8'
      val intent = Intent(activity, Class.forName("com.aigens.sdk.WebContainerActivity"))
      intent.putExtra("url", url)

      // Add member data
      val member = args["member"] as? Map<*, *>
      if (member != null) {
        val memberMap = HashMap<String, String>()
        member.forEach { (key, value) ->
          if (value != null) {
            memberMap[key.toString()] = value.toString()
          }
        }
        intent.putExtra("member", memberMap as java.io.Serializable)
      }

      // Add deeplink data
      val deeplink = args["deeplink"] as? Map<*, *>
      if (deeplink != null) {
        val deeplinkMap = HashMap<String, String>()
        deeplink.forEach { (key, value) ->
          if (value != null) {
            deeplinkMap[key.toString()] = value.toString()
          }
        }
        intent.putExtra("deeplink", deeplinkMap as java.io.Serializable)
      }

      // Add debug flag
      val debug = args["debug"] as? Boolean ?: false
      intent.putExtra("debug", debug)

      // Add environment production flag
      val environmentProduction = args["ENVIRONMENT_PRODUCTION"] as? Boolean ?: true
      intent.putExtra("ENVIRONMENT_PRODUCTION", environmentProduction)

      // Store result for activity result callback
      pendingResult = result

      // Start activity for result
     activity.startActivityForResult(intent, REQUEST_CODE_OPEN_URL)
    } catch (e: ClassNotFoundException) {
      result.error(
          "SDK_NOT_AVAILABLE",
          "Aigens SDK not found. Please add 'implementation \"com.aigens:aigens-sdk-core:xx.xx.xx\"' to your build.gradle",
          null
      )
    } catch (e: Exception) {
      result.error("ERROR", "Failed to open URL: ${e.message}", null)
    }
  }

  private fun handleDismiss(call: MethodCall, result: Result) {
    val activity = this.activity
    if (activity != null && activity.hasWindowFocus()) {
      activity.finish()
      result.success(true)
    } else {
      result.success(false)
    }
  }

  private fun handleIsInstalledApp(call: MethodCall, result: Result) {
    val args = call.arguments as? Map<*, *>
    val urlScheme = args?.get("key") as? String
    if (urlScheme == null) {
      result.error("INVALID_ARGUMENT", "URL scheme is required", null)
      return
    }

    try {
      val activity = this.activity ?: return result.error("NO_ACTIVITY", "Activity is not available", null)
      val intent = Intent(Intent.ACTION_VIEW, android.net.Uri.parse(urlScheme))
      val canOpen = intent.resolveActivity(activity.packageManager) != null
      result.success(canOpen)
    } catch (e: Exception) {
      result.error("ERROR", "Failed to check installed app: ${e.message}", null)
    }
  }

  private fun handleOpenExternalUrl(call: MethodCall, result: Result) {
    val args = call.arguments as? Map<*, *>
    val url = args?.get("url") as? String
    if (url == null) {
      result.error("INVALID_ARGUMENT", "URL is required", null)
      return
    }

    try {
      val activity = this.activity ?: return result.error("NO_ACTIVITY", "Activity is not available", null)
      val intent = Intent(Intent.ACTION_VIEW, android.net.Uri.parse(url))
      
      if (intent.resolveActivity(activity.packageManager) == null) {
        result.error("CANNOT_OPEN", "Cannot open URL: $url", null)
        return
      }

      activity.startActivity(intent)
      result.success(true)
    } catch (e: Exception) {
      result.error("ERROR", "Failed to open external URL: ${e.message}", null)
    }
  }

  private fun handleGetIsProductionEnvironment(call: MethodCall, result: Result) {
    result.success(true)
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (requestCode == REQUEST_CODE_OPEN_URL) {
      val result = pendingResult
      pendingResult = null

      if (resultCode == Activity.RESULT_OK && data != null) {
        val extras = data.extras
        if (extras != null) {
          val closedData = extras.getString("closedData")
          if (closedData != null) {
            // Parse JSON string to map
            val resultMap = HashMap<String, Any>()
            resultMap["closedData"] = closedData
            result?.success(resultMap)
            return true
          }
        }
      }
      
      result?.success(mapOf("closedData" to mapOf<String, Any>()))
      return true
    }
    return false
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity
    this.activityBinding = binding
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    this.activity = null
    this.activityBinding?.removeActivityResultListener(this)
    this.activityBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.activity = binding.activity
    this.activityBinding = binding
    binding.addActivityResultListener(this)
  }

  override fun onDetachedFromActivity() {
    this.activity = null
    this.activityBinding?.removeActivityResultListener(this)
    this.activityBinding = null
  }
}

