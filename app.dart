import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_controller.dart';
import 'features/auth/presentation/screens/auth_gate.dart';
import 'features/home/presentation/providers/browsing_provider.dart';
import 'features/home/presentation/providers/favorites_provider.dart';
import 'features/home/presentation/providers/marketplace_provider.dart';
import 'features/home/presentation/providers/notifications_provider.dart';
import 'features/home/presentation/providers/recent_views_provider.dart';
import 'features/home/presentation/providers/saved_search_provider.dart';
import 'features/profile/presentation/providers/user_profile_provider.dart';
import 'services/auth_service.dart';
import 'services/browsing_insight_service.dart';
import 'services/chat_service.dart';
import 'services/deal_review_service.dart';
import 'services/favorite_service.dart';
import 'services/item_service.dart';
import 'services/notification_service.dart';
import 'services/push_notification_service.dart';
import 'services/rating_service.dart';
import 'services/recent_view_service.dart';
import 'services/report_service.dart';
import 'services/saved_search_service.dart';
import 'services/storage_service.dart';
import 'services/user_profile_service.dart';
import 'widgets/firebase_setup_screen.dart';

class UniRentBootstrap extends StatelessWidget {
  const UniRentBootstrap({required this.firebaseError, super.key});

  final String? firebaseError;

  @override
  Widget build(BuildContext context) {
    if (firebaseError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.lightTheme(),
        home: FirebaseSetupScreen(errorMessage: firebaseError!),
      );
    }

    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<ItemService>(create: (_) => ItemService()),
        Provider<StorageService>(create: (_) => StorageService()),
        Provider<NotificationService>(create: (_) => NotificationService()),
        Provider<UserProfileService>(create: (_) => UserProfileService()),
        Provider<DealReviewService>(
          create: (context) => DealReviewService(
            notificationService: context.read<NotificationService>(),
          ),
        ),
        Provider<RecentViewService>(create: (_) => RecentViewService()),
        Provider<SavedSearchService>(create: (_) => SavedSearchService()),
        Provider<ReportService>(create: (_) => ReportService()),
        Provider<FavoriteService>(
          create: (context) => FavoriteService(
            notificationService: context.read<NotificationService>(),
          ),
        ),
        Provider<ChatService>(
          create: (context) => ChatService(
            notificationService: context.read<NotificationService>(),
            itemService: context.read<ItemService>(),
            userProfileService: context.read<UserProfileService>(),
          ),
        ),
        Provider<RatingService>(create: (_) => RatingService()),
        Provider<BrowsingInsightService>(
          create: (_) => BrowsingInsightService(),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(
            context.read<AuthService>(),
            context.read<UserProfileService>(),
          ),
        ),
        ChangeNotifierProvider<MarketplaceProvider>(
          create: (_) => MarketplaceProvider(),
        ),
        ChangeNotifierProxyProvider<AuthController, FavoritesProvider>(
          create: (context) =>
              FavoritesProvider(context.read<FavoriteService>()),
          update: (context, authController, favoritesProvider) {
            favoritesProvider ??= FavoritesProvider(
              context.read<FavoriteService>(),
            );
            favoritesProvider.updateAuth(authController.user);
            return favoritesProvider;
          },
        ),
        ChangeNotifierProxyProvider<AuthController, NotificationsProvider>(
          create: (context) =>
              NotificationsProvider(context.read<NotificationService>()),
          update: (context, authController, notificationsProvider) {
            notificationsProvider ??= NotificationsProvider(
              context.read<NotificationService>(),
            );
            notificationsProvider.updateAuth(authController.user);
            return notificationsProvider;
          },
        ),
        ChangeNotifierProxyProvider<AuthController, BrowsingProvider>(
          create: (context) =>
              BrowsingProvider(context.read<BrowsingInsightService>()),
          update: (context, authController, browsingProvider) {
            browsingProvider ??= BrowsingProvider(
              context.read<BrowsingInsightService>(),
            );
            browsingProvider.updateAuth(authController.user);
            return browsingProvider;
          },
        ),
        ChangeNotifierProxyProvider<AuthController, UserProfileProvider>(
          create: (context) =>
              UserProfileProvider(context.read<UserProfileService>()),
          update: (context, authController, userProfileProvider) {
            userProfileProvider ??= UserProfileProvider(
              context.read<UserProfileService>(),
            );
            userProfileProvider.updateAuth(authController.user);
            return userProfileProvider;
          },
        ),
        ChangeNotifierProxyProvider<AuthController, RecentViewsProvider>(
          create: (context) =>
              RecentViewsProvider(context.read<RecentViewService>()),
          update: (context, authController, recentViewsProvider) {
            recentViewsProvider ??= RecentViewsProvider(
              context.read<RecentViewService>(),
            );
            recentViewsProvider.updateAuth(authController.user);
            return recentViewsProvider;
          },
        ),
        ChangeNotifierProxyProvider<AuthController, SavedSearchProvider>(
          create: (context) => SavedSearchProvider(
            context.read<SavedSearchService>(),
            context.read<ItemService>(),
            context.read<NotificationService>(),
          ),
          update: (context, authController, savedSearchProvider) {
            savedSearchProvider ??= SavedSearchProvider(
              context.read<SavedSearchService>(),
              context.read<ItemService>(),
              context.read<NotificationService>(),
            );
            savedSearchProvider.updateAuth(authController.user);
            return savedSearchProvider;
          },
        ),
        ProxyProvider<AuthController, PushNotificationService>(
          create: (context) => PushNotificationService(
            userProfileService: context.read<UserProfileService>(),
          ),
          dispose: (_, service) => service.dispose(),
          update: (context, authController, pushNotificationService) {
            pushNotificationService ??= PushNotificationService(
              userProfileService: context.read<UserProfileService>(),
            );
            pushNotificationService.updateAuth(authController.user);
            return pushNotificationService;
          },
        ),
      ],
      child: const UniRentApp(),
    );
  }
}

class UniRentApp extends StatelessWidget {
  const UniRentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme(),
      home: const AuthGate(),
    );
  }
}
