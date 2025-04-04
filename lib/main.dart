import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:reserva_hub_admin/screens/login_page.dart';
import 'package:reserva_hub_admin/screens/main_menu_screen%20.dart';
// import 'cadastro_espaco_screen.dart'; // Importe a tela de cadastro que criamos anteriormente

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(AdminApp());
}

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Administrativo',
      theme: ThemeData(
        primarySwatch: Colors.indigo, 
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MainMenuScreen(),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}