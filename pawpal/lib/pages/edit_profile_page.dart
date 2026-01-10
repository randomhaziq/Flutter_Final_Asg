import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/myconfig.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}
class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? _image;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.userName ?? "";
    phoneController.text = widget.user.userPhone ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image Picker
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 2),
                    color: Colors.grey[200],
                    image: _image != null
                        ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                        : widget.user.profileImage != null
                        ? DecorationImage(
                            image: NetworkImage(
                              '${MyConfig.baseUrl}/pawpal/server/${widget.user.profileImage}',
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _image == null && widget.user.profileImage == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tap image to change",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Name Field
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

              // Phone Field
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 40),

              // Save Button
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Bubblegum Sans'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, maxHeight: 800, 
        maxWidth: 800,
        imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        isChanged = true;
      });
    }
  }

  void _updateProfile() async {
    String newName = nameController.text.trim();
    String newPhone = phoneController.text.trim();

    if (newName.isEmpty || newPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fields cannot be empty")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    String? base64Image;
    if (_image != null) {
      base64Image = base64Encode(_image!.readAsBytesSync());
    }

    try {
      final response = await http.post(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/server/pawpal/api/edit_profile.php',
        ),
        body: {
          'user_id': widget.user.userId,
          'name': newName,
          'phone': newPhone,
          'image': base64Image ?? '', 
        },
      ).timeout(const Duration(seconds: 30)); 

      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (response.statusCode == 200) {
        try {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status'] == 'success') {
            User updatedUser = widget.user;
            updatedUser.userName = newName;
            updatedUser.userPhone = newPhone;

            if (jsonResponse['new_image'] != null && jsonResponse['new_image'].toString().isNotEmpty) {
               updatedUser.profileImage = jsonResponse['new_image'];
            }

            if (!mounted) return;
            Navigator.pop(context, updatedUser); // Return to ProfilePage
             
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile Updated Successfully")),
            );
          } else {
             if (!mounted) return;
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed: ${jsonResponse['message']}")),
            );
          }
        } catch (e) {
          // JSON Decode failed (Server sent HTML/Text instead of JSON)
          print("JSON Parse Error: $e");
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Server returned invalid data.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
         Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
