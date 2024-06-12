import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_deneme/screens/wallet_stack/wallet_screen.dart';
import 'package:getx_deneme/screens/wallet_creation_stack/wallet_home_screen.dart';
import 'package:getx_deneme/screens/wallet_stack/password_screen.dart';
import 'package:getx_deneme/screens/wallet_creation_stack/create_password_screen.dart';
import 'package:getx_deneme/screens/wallet_creation_stack/import_wallet_screen.dart';
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
        GetPage(name: '/password', page: () => const PasswordScreen()), // Add PasswordScreen route
        GetPage(name: '/import', page: () => ImportWalletScreen()), // Add ImportWalletScreen route
        GetPage(name: '/create_password', page: () => CreatePasswordScreen()), // Add CreatePasswordScreen route
        GetPage(name: '/wallet', page: () => WalletPage(address: '0x0effsadad79756')), // Add WalletPage route
      ],
    );
  }
}
