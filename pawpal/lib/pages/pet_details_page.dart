import 'package:flutter/material.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/model/pet.dart';

class PetDetailsPage extends StatefulWidget {
  final User user;
  final Pet pet;

  const PetDetailsPage({super.key, required this.user, required this.pet});

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pet Details",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

