import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// REPOSITORIOS
import 'package:mobile/data/repositories/auth_repository.dart';
import 'package:mobile/data/repositories/product_repository.dart';

// BLOCS
import 'package:mobile/logic/blocs/auth_bloc.dart';
import 'package:mobile/logic/blocs/product/product_bloc.dart';
import 'package:mobile/logic/blocs/product/product_event.dart';
import 'package:mobile/logic/blocs/cart/cart_bloc.dart';

// PANTALLAS
import 'package:mobile/presentation/auth/splash_screen.dart';
import 'package:mobile/presentation/auth/login_screen.dart';
import 'package:mobile/presentation/auth/register_screen.dart';
import 'package:mobile/presentation/client/home_screen.dart';
import 'package:mobile/presentation/client/catalog_screen.dart';
import  'package:mobile/presentation/client/cart_screen.dart';
import 'package:mobile/presentation/worker/inventory_screen.dart';
import 'package:mobile/presentation/admin/dashboard_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Repositorios disponibles en toda la app
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => ProductRepository()),
      ],
      // 2. Blocs disponibles en toda la app
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) => AuthBloc(authRepository: ctx.read<AuthRepository>())),
          BlocProvider(create: (ctx) => ProductBloc(productRepository: ctx.read<ProductRepository>())..add(LoadHomeProductsEvent())),
          BlocProvider(create: (_) => CartBloc()),
        ],
        // 3. MaterialApp con builder para evitar el error de contexto
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Gravity Tech',
          theme: _buildTheme(),
          initialRoute: '/splash',
          // Este builder es la clave: asegura que los Blocs estén presentes en cualquier pantalla
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
routes: {
            '/catalog': (context) => const CatalogScreen(), // Asegúrate que tu clase tenga const si es posible
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/client_home': (context) => const HomeScreen(),
            '/cart': (context) => const CartScreen(),
            '/worker_inventory': (context) => const InventoryScreen(),
            '/admin_dashboard': (context) => const DashboardScreen(),
          },
        ),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFE040FB),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE040FB),
        secondary: Color(0xFFF48FB1),
        surface: Color(0xFF1A1A1A),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF2D2D2D), 
        elevation: 4
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A), 
        elevation: 0, 
        centerTitle: true
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE040FB),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}