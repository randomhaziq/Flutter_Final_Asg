import 'package:flutter/material.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/pages/login_page.dart';

void main() {
  runApp(const PawPal());
}

class PawPal extends StatefulWidget {
  const PawPal({super.key});

  @override
  State<PawPal> createState() => _PawPalState();
}

class _PawPalState extends State<PawPal> {
  String userId = '';
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  String userPhone = '';
  String userRegDate = '';

  User currentUser = User(
    userId: '',
    userName: '',
    userEmail: '',
    userPassword: '',
    userPhone: '',
    userRegDate: '',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange[400],
          foregroundColor: Colors.white,
          toolbarTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'Bubblegum Sans',
          ),
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Bubblegum Sans',
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      // home: BrowsePets(),
      home: LoginPage(),
    );
  }
}
