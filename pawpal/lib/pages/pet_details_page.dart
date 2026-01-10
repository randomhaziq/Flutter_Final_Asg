import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/model/pet.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/myconfig.dart';

class PetDetailsPage extends StatefulWidget {
  final User user;
  final Pet pet;

  const PetDetailsPage({super.key, required this.user, required this.pet});

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  late double screenWidth, screenHeight;
  TextEditingController messageController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    int imageCount = widget.pet.imagePaths?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Pet Details")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION
            Container(
              width: double.infinity,
              color: Colors.orange[100],
              height: imageCount > 1 ? 300 : 400,

              child: imageCount > 1
                  //MULTIPLE IMAGES (Row)
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (imageCount > 0)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              child: Image.network(
                                '${MyConfig.baseUrl}/pawpal/server/${widget.pet.imagePaths![0]}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        if (imageCount > 1)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              child: Image.network(
                                '${MyConfig.baseUrl}/pawpal/server/${widget.pet.imagePaths![1]}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        if (imageCount > 2)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              child: Image.network(
                                '${MyConfig.baseUrl}/pawpal/server/${widget.pet.imagePaths![2]}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                      ],
                    )
                  //SINGLE IMAGE
                  : Container(
                      width: double.infinity,
                      child: imageCount == 1
                          ? Image.network(
                              '${MyConfig.baseUrl}/pawpal/server/${widget.pet.imagePaths![0]}',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Padding(
                                    padding: EdgeInsets.all(50.0),
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                          : const Padding(
                              padding: EdgeInsets.all(50.0),
                              child: Icon(
                                Icons.image_not_supported,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                    ),
            ),

            // DETAILS FORM
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //pet name
                  Text(
                    widget.pet.petName ?? "Unknown Name",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bubblegum Sans',
                    ),
                  ),
                  const SizedBox(height: 5),

                  //status (available/adopted)
                  Row(
                    children: [
                      //Pet Status (Available/Adopted)
                      if (widget.pet.petStatus != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            // Logic: Green for Available, Grey/Red for others
                            color: widget.pet.petStatus == 'Available'
                                ? Colors.green[100]
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            widget.pet.petStatus!,
                            style: TextStyle(
                              color: widget.pet.petStatus == 'Available'
                                  ? Colors.green[800]
                                  : Colors.red[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      const SizedBox(width: 10),

                      //Submission Category (Adoption/Help/Donation)
                      if (widget.pet.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Colors.blue[100], // Distinct color for category
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            widget.pet.category!,
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),

                  //details about pet
                  detailPet("Type", "${widget.pet.petType}"),
                  detailPet("Category", "${widget.pet.category}"),
                  detailPet("Age", "${widget.pet.petAge}"),
                  detailPet("Gender", "${widget.pet.petGender}"),
                  detailPet("Health", "${widget.pet.petHealth}"),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // DESCRIPTION
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${widget.pet.description}",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // POSTED BY
                  const Text(
                    "Posted by",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "Name: ${widget.user.userName}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // BUTTON
                  if (widget.pet.category == 'Adoption')
                    ElevatedButton(
                      onPressed: _showAdoptionDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[400],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Request to Adopt',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _showDonationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Donate Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdoptionDialog() {
    messageController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Request to Adopt"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Why do you want to adopt this pet?"),
              const SizedBox(height: 10),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Enter your message here...",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                if (messageController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  submitAdoptionRequest();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a message")),
                  );
                }
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDonationDialog() {
    String selectedType = 'Money';
    TextEditingController donationInputController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // StatefulBuilder required to update Dropdown/TextField state inside Dialog
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Make a Donation"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Donation Type',
                      border: OutlineInputBorder(),
                    ),
                    items: <String>['Money', 'Food', 'Medical'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        selectedType = newValue!;
                        donationInputController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  // Dynamic Input
                  TextField(
                    controller: donationInputController,
                    keyboardType: selectedType == 'Money'
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.text,
                    maxLines: selectedType == 'Money' ? 1 : 3,
                    decoration: InputDecoration(
                      labelText: selectedType == 'Money'
                          ? 'Amount (RM)'
                          : 'Description of Items',
                      hintText: selectedType == 'Money'
                          ? 'e.g. 50.00'
                          : 'e.g. 2 bags of kibble',
                      border: const OutlineInputBorder(),
                      prefixText: selectedType == 'Money' ? 'RM ' : '',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    double amount =
                        double.tryParse(donationInputController.text) ?? 0.0;

                    if (selectedType == 'Money') {
                      if (amount <= 0.0 ||
                          donationInputController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a valid amount"),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                        submitDonation(
                          selectedType,
                          donationInputController.text,
                        );
                      }
                    } else {
                      if (donationInputController.text.isNotEmpty) {
                        Navigator.of(context).pop();
                        submitDonation(
                          selectedType,
                          donationInputController.text,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter a description"),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget detailPet(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.orange, size: 24),
          const SizedBox(width: 15),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void submitDonation(String type, String value) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/server/pawpal/api/submit_donation.php',
        ),
        body: {
          'pet_id': widget.pet.petId,
          'user_id': widget.user.userId,
          'donation_type': type,
          'amount': type == 'Money' ? value : '0',
          'description': type == 'Money' ? 'Monetary Donation' : value,
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Donation successful!'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed: ${jsonResponse['message']}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Server Error'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void submitAdoptionRequest() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/server/pawpal/api/submit_adoption_request.php',
        ),
        body: {
          'pet_id': widget.pet.petId,
          'user_id': widget.user.userId,
          'message': messageController.text,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Request sent successfully! Check My Adoption Request History for updates.',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed: ${jsonResponse['message']}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Server Error'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
        messageController.clear();
      });
    }
  }
}
