import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/model/user.dart'; // Import your User model
import 'package:pawpal/myconfig.dart';

class DonationHistoryPage extends StatefulWidget {
  final User user;

  const DonationHistoryPage({super.key, required this.user});

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  List<dynamic> donationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDonationHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Donations")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : donationList.isEmpty
          ? const Center(child: Text("No donations found."))
          : ListView.builder(
              itemCount: donationList.length,
              itemBuilder: (context, index) {
                final item = donationList[index];
                
                List<dynamic> petImages = [];
                if (item['image_paths'] != null && item['image_paths'].toString().isNotEmpty) {
                  petImages = jsonDecode(item['image_paths']);
                }

                return Card(
                  color: Colors.orange[50],
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 140,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        //image section
                        Container(
                          width: 100,
                          height: 120,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange, width: 1),
                          ),

                          // Check if pet_image exists in the donationlist
                          child:
                              (item['image_paths'] != null &&
                                  item['image_paths'].toString().isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.network(
                                    '${MyConfig.baseUrl}/pawpal/server/${petImages[0]}',
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                  ),
                                )
                              : const Icon(
                                  Icons.pets,
                                  size: 40,
                                  color: Colors.orangeAccent,
                                ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 1. Pet Name
                              Text(
                                "To: ${item['pet_name']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Bubblegum Sans',
                                ),
                              ),
                              const SizedBox(height: 5),

                              // 2. Donation Details
                              Text(
                                item['donation_type'] == 'Money'
                                    ? "RM ${item['amount']}"
                                    : "Items: ${item['description']}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),

                              const SizedBox(height: 5),

                              // 3. Type Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getColorType(item['donation_type']),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item['donation_type'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // 4. Date
                              Text(
                                item['donation_date'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Arrow Icon
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.deepOrange,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Helper function to choose Color based on selected type
  Color _getColorType(String type) {
    if (type == 'Money') return Colors.green;
    if (type == 'Food') return Colors.orange;
    return Colors.red;
  }

  Future<void> loadDonationHistory() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/server/pawpal/api/get_my_donation.php?user_id=${widget.user.userId}',
        ),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          setState(() {
            donationList = jsonResponse['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
}
