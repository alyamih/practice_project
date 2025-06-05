import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_project/app/navigation/routes.dart';

class DeepLinkService {
  static void handleInit() async {
    var initialLink = await AppLinks().getInitialLink();
    if (initialLink != null && initialLink.fragment.isNotEmpty) {
      router.pushNamed('/${initialLink.fragment}');
    }
  }

  static void handleForeground() async {
    var initialLink = AppLinks().uriLinkStream;
    initialLink.forEach(
      (element) {
        if (element.fragment.isNotEmpty) {
          log('||||||${element.fragment}');
          // if (element.fragment == '/' || element.fragment == '/profile') {
          // StatefulNavigationShell.of(router.)
          //     .goBranch(1);

          //  } else {
          router.pushNamed('/${element.fragment}');
          // }
        }
      },
    );
  }
}
