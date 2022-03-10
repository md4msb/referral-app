import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DeepLinkService {
  DeepLinkService._();

  static DeepLinkService? _instance;

  static DeepLinkService? get instance {
    _instance ??= DeepLinkService._();
    return _instance;
  }

  ValueNotifier<String> referrerCode = ValueNotifier<String>('');

  final dynamicLink = FirebaseDynamicLinks.instance;

  Future<void> handleDynamicLinks() async {
    final data = await dynamicLink.getInitialLink();
    if (data != null) {
      _handleDeepLink(data);
    }

    dynamicLink.onLink.listen((event) {
      _handleDeepLink(event);
    }).onError((v) {
      debugPrint("Failed: $v");
    });
  }

  Future<String> createReferLink(String referCode) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: 'https://dynamicreferral.page.link',
      link:
          Uri.parse('https://dynamicreferral.page.link/refer?code=$referCode'),
      androidParameters: const AndroidParameters(
        packageName: "com.example.referral",
        minimumVersion: 1,
      ),
      socialMetaTagParameters: const SocialMetaTagParameters(
        title: "REFER AND EARN",
        description: "Earn 100 rupee on every referral",
      ),
    );
    final shortLink = await dynamicLink.buildShortLink(dynamicLinkParameters);

    return shortLink.shortUrl.toString();
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
    var isRefer = deepLink.pathSegments.contains('refer');
    if (isRefer) {
      var code = deepLink.queryParameters['code'];
      if (code != null) {
        referrerCode.value = code;
        referrerCode.notifyListeners();
      }
    }
  }
}
