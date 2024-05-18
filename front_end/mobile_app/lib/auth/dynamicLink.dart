import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class DynamicLinksManager {
  void initDynamicLinks(BuildContext context) async {
    // Get the initial dynamic link if the app is launched via a link
    final PendingDynamicLinkData? initialLinkData =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(context, initialLinkData?.link);

    // Attach a listener for dynamic links received while the app is running
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _handleDeepLink(context, dynamicLinkData.link);
    }, onError: (error) {
      print('Error occurred in dynamic links: $error');
    });
  }

  void _handleDeepLink(BuildContext context, Uri? deepLink) {
    if (deepLink != null) {
      // Check if the deep link matches the expected reset password path
      if (deepLink.path == '/reset_Password') {
        Navigator.pushNamed(context, '/reset_Password');
      }
    }
  }
}
