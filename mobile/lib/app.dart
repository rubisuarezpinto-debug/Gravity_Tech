import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/verify_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/client/screens/client_home_screen.dart';
import 'features/client/screens/cart_screen.dart';
import 'features/client/screens/catalog_screen.dart';
import 'features/client/screens/profile_screen.dart';
import 'features/worker/screens/worker_home_screen.dart';
import 'features/worker/screens/product_management_screen.dart';
import 'features/worker/screens/worker_profile_screen.dart';
import 'features/admin/screens/admin_home_screen.dart';
import 'features/admin/screens/admin_analytics_screen.dart';
import 'features/admin/screens/admin_staff_screen.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/verify', builder: (context, state) => const VerifyScreen()),
    GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(path: '/client/home',    builder: (context, state) => const ClientHomeScreen()),
    GoRoute(path: '/client/cart',    builder: (context, state) => const CartScreen()),
    GoRoute(path: '/client/catalog', builder: (context, state) => const CatalogScreen()),
    GoRoute(path: '/client/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/worker/home', builder: (context, state) => const WorkerHomeScreen()),
    GoRoute(path: '/worker/products', builder: (context, state) => const ProductManagementScreen()),
    GoRoute(path: '/worker/profile', builder: (context, state) => const WorkerProfileScreen()),
    GoRoute(path: '/admin/home', builder: (context, state) => const AdminHomeScreen()),
    GoRoute(path: '/admin/analytics', builder: (context, state) => const AdminAnalyticsScreen()),
    GoRoute(path: '/admin/staff', builder: (context, state) => const AdminStaffScreen()),
  ],
);

class GravityTechApp extends StatelessWidget {
  const GravityTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gravity Tech',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: _router,
    );
  }
}
