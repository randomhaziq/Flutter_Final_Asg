import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/pages/home_page.dart';

class SubmitPetScreen extends StatefulWidget {
  final User currentUser;
  const SubmitPetScreen({super.key, required this.currentUser});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  List<Uint8List?> petImages = [null, null, null];
  late double screenWidth, screenHeight;

  String? selectedPetType;
  String? selectedSubmissionCategory;
  String? selectedGender;

  late Position myposition;
  bool isLoading = false;

  TextEditingController petNameController = TextEditingController();
  TextEditingController petDescriptionController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController petAgeController = TextEditingController();
  TextEditingController petHealthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    final contentWidth = screenWidth > 900 ? 900.0 : screenWidth;
    final contentHeight = screenHeight > 600 ? 600.0 : screenHeight;

    return Scaffold(
      appBar: AppBar(title: const Text("Pet Submission")),
      body: Row(
        children: [
          // Left side image
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.orange[100],
              child: Center(
                child: Image.asset(
                  'assets/images/pet_submission_image.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Right side submit pet form
          Expanded(
            child: Container(
              width: contentWidth,
              height: contentHeight,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Submit A Pet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Bubblegum Sans',
                      ),
                    ),
                    SizedBox(height: 30),

                    // Pet Name field
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: petNameController,
                        decoration: InputDecoration(
                          labelText: 'Pet Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Row for Age and Gender (Grouped)
                    SizedBox(
                      width: 300,
                      child: Row(
                        children: [
                          // Age Field
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: petAgeController,
                              decoration: InputDecoration(
                                labelText: 'Age',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Gender Dropdown
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange),
                                ),
                              ),
                              value: selectedGender,
                              items: <String>['Male', 'Female'].map((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Dropdown for pet type
                    SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Pet Type',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                        initialValue: selectedPetType,
                        items: <String>['Dog', 'Cat', 'Bird', 'Other'].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPetType = newValue;
                          });
                        },
                        hint: const Text('Select Pet Type'),
                      ),
                    ),
                    SizedBox(height: 20),

                    //dropdown for submission type
                    SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Submission Category',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                        items:
                            <String>[
                              'Adoption',
                              'Donation Request',
                              'Help/ Rescue',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSubmissionCategory = newValue;
                          });
                        },
                        hint: const Text('Select Submission Category'),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Health Status field
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: petHealthController,
                        decoration: InputDecoration(
                          labelText: 'Health Status',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Description field
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: petDescriptionController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    //latitue and longitude fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: latitudeController,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Latitude',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: longitudeController,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Longitude',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.location_on),
                          onPressed: () async {
                            myposition = await _determinePosition();
                            setState(() {
                              latitudeController.text = myposition.latitude
                                  .toStringAsFixed(6);
                              longitudeController.text = myposition.longitude
                                  .toStringAsFixed(6);
                            });
                          },
                          iconSize: 40,
                          color: Colors.orange[400],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    //3 image placeholders
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        placeholderImage(0),
                        SizedBox(width: 10),
                        placeholderImage(1),
                        SizedBox(width: 10),
                        placeholderImage(2),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Upload image button
                    ElevatedButton(
                      onPressed: addImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        '+ Add Image',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Submit button
                    ElevatedButton(
                      onPressed: submitPet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[400],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget placeholderImage(int index) {
    return GestureDetector(
      onTap: () => pickImage(index),
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: petImages[index] != null ? Colors.grey[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[400] ?? Colors.grey, width: 2),
        ),
        child: petImages[index] != null
            ? Image.memory(petImages[index]!, fit: BoxFit.cover)
            : Icon(Icons.image, size: 40, color: Colors.grey),
      ),
    );
  }

  Future<void> pickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List imageData = await image.readAsBytes();
      setState(() {
        petImages[index] = imageData;
      });
    }
  }

  void addImage() {
    // Find first empty slot
    int emptyIndex = petImages.indexWhere((img) => img == null);

    if (emptyIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 3 images reached'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    pickImage(emptyIndex);
  }

  void submitPet() {
    // Validate minimum 1 image
    int imageCount = petImages.where((img) => img != null).length;
    if (imageCount < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least 1 image'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (petNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter pet name'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    int? age = int.tryParse(petAgeController.text);

    if (petAgeController.text.isEmpty || age == null || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid pet age'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select pet gender'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (selectedPetType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select pet type'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (selectedSubmissionCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select submission category'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (petDescriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter description'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else if (petDescriptionController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Description should be at least 10 characters'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (latitudeController.text.isEmpty || longitudeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set location'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    String userId = widget.currentUser.userId!;
    String petName = petNameController.text.trim();
    String petAge = petAgeController.text.trim();
    String petGender = selectedGender!;
    String petType = selectedPetType!;
    String category = selectedSubmissionCategory!;
    String health = petHealthController.text.trim();
    String petDescription = petDescriptionController.text.trim();
    double latitude = double.parse(latitudeController.text);
    double longitude = double.parse(longitudeController.text);

    uploadPetData(
      userId,
      petName,
      petAge,
      petGender,
      petType,
      category,
      health,
      petDescription,
      latitude,
      longitude,
      petImages,
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void uploadPetData(
    String userId,
    String petName,
    String petAge,
    String petGender,
    String petType,
    String category,
    String petHealth,
    String petDescription,
    double latitude,
    double longitude,
    List<Uint8List?> petImages,
  ) async {
    setState(() {
      isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.orange),
              SizedBox(width: 20),
              Text("Processing..."),
            ],
          ),
        );
      },
    );

    // Prepare body with individual image fields
    Map<String, String> requestBody = {
      'user_id': userId,
      'pet_name': petName,
      'age': petAge,
      'gender': petGender,
      'pet_type': petType,
      'category': category,
      'health_status': petHealth,
      'description': petDescription,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };

    // Add only non-null images with keys image1, image2, image3
    int imageIndex = 1;
    for (int i = 0; i < petImages.length; i++) {
      if (petImages[i] != null) {
        requestBody['image$imageIndex'] = base64Encode(petImages[i]!);
        imageIndex++;
      }
    }

    try {
      final response = await http.post(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/server/pawpal/api/submit_pet.php',
        ),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          if (!mounted) return;

          // Close loading dialog
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Pet submitted successfully!'),
              duration: Duration(seconds: 2),
            ),
          );

          // Delay redirect to allow SnackBar to show
          await Future.delayed(Duration(seconds: 2));
          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BrowsePets(user: widget.currentUser),
            ),
          );
        } else {
          if (!mounted) return;
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Submission failed: ${jsonResponse['message']}'),
              duration: Duration(seconds: 2),
            ),
          );
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if (!mounted) return;
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Server error: ${response.statusCode}'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error: $e'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}
