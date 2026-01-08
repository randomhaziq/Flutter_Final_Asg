import 'package:flutter/material.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? currentUser;    
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final contentWidth = screenWidth > 900 ? 900.0 : screenWidth;
    final contentHeight = screenHeight > 600 ? 600.0 : screenHeight;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: contentWidth,
        height: contentHeight,  
        color: Colors.orange[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to PawPal! ${currentUser?.userName ?? 'Guest'}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Bubblegum Sans',
                ),
              ),
              SizedBox(height: 20),
              Icon(Icons.pets, size: 100, color: Colors.orange[400]),
            ],
          ),
        ),
      ),
    );
  }
}
