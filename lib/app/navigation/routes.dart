import 'package:go_router/go_router.dart';
import 'package:practice_project/app/navigation/bottom_bar_base.dart';
import 'package:practice_project/features/favorites/presentation/favorites_page.dart';
import 'package:practice_project/features/login/presentation/login_page.dart';
import 'package:practice_project/features/post_details/presentation/post_details_page.dart';
import 'package:practice_project/features/posts/presentation/posts_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/post/:postId',
      builder: (context, state) => PostDetailsPage(
        postId: int.parse(state.pathParameters['postId']!),
      ),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesPage(),
    ),
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const PostsPage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
          ),
        ]),
      ],
      builder: (context, state, navigationShell) {
        return BottomBarBase(
          navigationShell: navigationShell,
        );
      },
    )
  ],
);
