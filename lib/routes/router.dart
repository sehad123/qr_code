// GoRouter configuration
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_code/models/product.dart';
import 'package:qr_code/pages/add_product.dart';
import 'package:qr_code/pages/auth.dart';
import 'package:qr_code/pages/detail_product.dart';
import 'package:qr_code/pages/error.dart';
import 'package:qr_code/pages/home.dart';
import 'package:qr_code/pages/login.dart';
import 'package:qr_code/pages/product.dart';
import 'package:qr_code/pages/splash.dart';

part 'route_name.dart';

// push replacement -> route sebelumnya masih ada di stack
final router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    // cek kondisi saat ini => sedang terauntetifikasi gak
    if (auth.currentUser == null) {
      // tidak sedang login / tidak ada user
      return '/splash';
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage(), routes: [
      GoRoute(
          path: 'products',
          name: Routes.products,
          builder: (context, state) => const ProductsPage(),
          // masuk ke sub route product
          routes: [
            GoRoute(
              path: ':productId',
              name: Routes.detailproduct,
              builder: (context, state) => DetailProductPage(
                state.pathParameters['productId'].toString(),
                state.extra as Product,
              ),
            ),
          ]),
      GoRoute(
        path: 'add-product',
        name: Routes.addproduct,
        builder: (context, state) => AddProductPage(),
      ),
    ]),
    // push biasa jadi user tidak bisa kembali ke halaman sebelumnya

    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/splash',
      name: Routes.splash,
      builder: (context, state) => SplashPage(),
    ),
    GoRoute(
      path: '/biometric',
      name: Routes.biometric,
      builder: (context, state) => Biometric(),
    ),
  ],
);
