import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:getx_deneme/screens/create_wallet_screen.dart';
import 'package:getx_deneme/screens/import_wallet_screen.dart';
import 'package:getx_deneme/screens/show_mnemonic_screen.dart';
import 'package:getx_deneme/screens/wallet_screen.dart';
import 'package:getx_deneme/screens/password_screen.dart';
import 'package:getx_deneme/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/main_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MainController()); // Initialize MainController here

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/password', // Always start with the password screen
      getPages: [
        GetPage(name: '/', page: () => const MyHomePage(title: 'Flutter Demo Home Page')),
        GetPage(name: '/wallet', page: () => WalletPage(address: '')),
        GetPage(name: '/password', page: () => const PasswordScreen()), // Add PasswordScreen route
        GetPage(name: '/import', page: () => ImportWalletScreen()), // Add ImportWalletScreen route
      ],
    );
  }
}
