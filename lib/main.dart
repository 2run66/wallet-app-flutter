import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_deneme/screens/second_screen.dart';
import 'package:getx_deneme/services/derive_path.dart';
import 'package:getx_deneme/services/generate_address.dart';
import 'package:getx_deneme/services/generate_seed.dart';

import 'controllers/main_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _mainController = Get.put(MainController());
  String _mnemonic = "";
  String _address = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void generateWallet() {
    _mnemonic = generateMnemonic();
    _mainController.setMnemonic(_mnemonic.split(" "));
    var key = deriveKey(_mnemonic);
    _address = publicKeyToAddress(key.publicKey);
    _mainController.setAddress(_address);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta',
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Şifre',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Giriş yap işlemini gerçekleştir
                generateWallet();
                debugPrint('address: $_address');
                Get.to(() => SecondScreen());
              },
              child: const Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}