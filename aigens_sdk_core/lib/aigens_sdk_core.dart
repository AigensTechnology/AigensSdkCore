library aigens_sdk_core;

import 'dart:async';
import 'package:flutter/services.dart';

/// Member data for automatic login
class MemberData {
  /// The unique identifier of the member in CRM backend
  final String? memberCode;

  /// A merchant brand name string to indicate which brand the member belongs to
  final String? source;

  /// Member's current session key for CRM access
  final String? sessionId;

  /// Push token registered with Apple/Google push service
  final String? pushId;

  /// Each device is unique, each device is the same value
  final String? deviceId;

  /// Universal link to return to the app (start with https://)
  final String? universalLink;

  /// App scheme for deep linking
  final String? appScheme;

  /// Apple Merchant ID (required if using Apple Pay)
  final String? appleMerchantId;

  /// Language preference: "en" or "zh"
  final String? language;

  /// Whether the user is a guest
  final bool? isGuest;

  MemberData({
    this.memberCode,
    this.source,
    this.sessionId,
    this.pushId,
    this.deviceId,
    this.universalLink,
    this.appScheme,
    this.appleMerchantId,
    this.language,
    this.isGuest,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (memberCode != null) map['memberCode'] = memberCode;
    if (source != null) map['source'] = source;
    if (sessionId != null) map['sessionId'] = sessionId;
    if (pushId != null) map['pushId'] = pushId;
    if (deviceId != null) map['deviceId'] = deviceId;
    if (universalLink != null) map['universalLink'] = universalLink;
    if (appScheme != null) map['appScheme'] = appScheme;
    if (appleMerchantId != null) map['appleMerchantId'] = appleMerchantId;
    if (language != null) map['language'] = language;
    if (isGuest != null) map['isGuest'] = isGuest;
    return map;
  }
}

/// Deeplink data for navigation
class DeeplinkData {
  /// Item to be added when user navigate to order page
  final String? addItemId;

  /// Discount code to be added automatically
  final String? addDiscountCode;

  /// Apply the offer that belong to the user when user checkout
  final String? addOfferId;

  DeeplinkData({
    this.addItemId,
    this.addDiscountCode,
    this.addOfferId,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (addItemId != null) map['addItemId'] = addItemId;
    if (addDiscountCode != null) map['addDiscountCode'] = addDiscountCode;
    if (addOfferId != null) map['addOfferId'] = addOfferId;
    return map;
  }
}

/// Closed data returned when WebContainer is closed
class ClosedData {
  /// Redirect URL after closing
  final String? redirectUrl;

  /// Action type
  final String? action;

  ClosedData({
    this.redirectUrl,
    this.action,
  });

  factory ClosedData.fromMap(Map<dynamic, dynamic> map) {
    final closedDataMap = map['closedData'] as Map<dynamic, dynamic>? ?? {};
    return ClosedData(
      redirectUrl: closedDataMap['redirectUrl'] as String?,
      action: closedDataMap['action'] as String?,
    );
  }
}

/// Aigens SDK Core Plugin
class AigensSdkCore {
  static const MethodChannel _channel = MethodChannel('aigens_sdk_core');

  /// Open WebContainer with the specified URL
  ///
  /// Returns a [ClosedData] when the WebContainer is closed
  static Future<ClosedData?> openUrl({
    required String url,
    MemberData? member,
    DeeplinkData? deeplink,
    bool debug = false,
    bool clearCache = false,
    bool environmentProduction = true,
    List<String>? externalProtocols,
    List<String>? addPaddingProtocols,
    List<String>? excludedUniversalLinks,
    List<String>? exitUniversalLinks,
  }) async {
    try {
      final arguments = <String, dynamic>{
        'url': url,
        'debug': debug,
        'clearCache': clearCache,
        'ENVIRONMENT_PRODUCTION': environmentProduction,
      };

      if (member != null) {
        arguments['member'] = member.toMap();
      }

      if (deeplink != null) {
        arguments['deeplink'] = deeplink.toMap();
      }

      if (externalProtocols != null) {
        arguments['externalProtocols'] = externalProtocols;
      }

      if (addPaddingProtocols != null) {
        arguments['addPaddingProtocols'] = addPaddingProtocols;
      }

      if (excludedUniversalLinks != null) {
        arguments['excludedUniversalLinks'] = excludedUniversalLinks;
      }

      if (exitUniversalLinks != null) {
        arguments['exitUniversalLinks'] = exitUniversalLinks;
      }

      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
          'openUrl', arguments);

      if (result != null) {
        return ClosedData.fromMap(result);
      }

      return null;
    } catch (e) {
      throw PlatformException(
        code: 'OPEN_URL_ERROR',
        message: 'Failed to open URL: $e',
      );
    }
  }

  /// Dismiss the current WebContainer
  static Future<void> dismiss({Map<String, dynamic>? closedData}) async {
    try {
      await _channel.invokeMethod('dismiss', {'closedData': closedData});
    } catch (e) {
      throw PlatformException(
        code: 'DISMISS_ERROR',
        message: 'Failed to dismiss: $e',
      );
    }
  }

  /// Check if an app is installed by URL scheme
  static Future<bool> isInstalledApp(String urlScheme) async {
    try {
      final result = await _channel
          .invokeMethod<bool>('isInstalledApp', {'key': urlScheme});
      return result ?? false;
    } catch (e) {
      throw PlatformException(
        code: 'CHECK_INSTALLED_ERROR',
        message: 'Failed to check installed app: $e',
      );
    }
  }

  /// Open an external URL
  static Future<void> openExternalUrl(String url) async {
    try {
      await _channel.invokeMethod('openExternalUrl', {'url': url});
    } catch (e) {
      throw PlatformException(
        code: 'OPEN_EXTERNAL_ERROR',
        message: 'Failed to open external URL: $e',
      );
    }
  }

  /// Get production environment status
  static Future<bool> getIsProductionEnvironment() async {
    try {
      final result =
          await _channel.invokeMethod<bool>('getIsProductionEnvironment');
      return result ?? true;
    } catch (e) {
      return true;
    }
  }
}
