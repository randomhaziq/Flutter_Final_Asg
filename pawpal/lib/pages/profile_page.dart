import 'package:flutter/material.dart';
import 'package:pawpal/pages/edit_profile_page.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/pages/donation_history_page.dart';
import 'package:pawpal/pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User currentUser;
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.orange[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //image profile
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              color: Colors.orange[50],
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 3),
                    ),
                    child:
                        currentUser.userProfileImage != null &&
                            currentUser.userProfileImage!.isNotEmpty
                        // Load from server
                        ? Image.network(
                            '${MyConfig.baseUrl}/pawpal/server/${currentUser.userProfileImage}',
                          )
                        : const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(height: 10),

                  //edit profile
                  GestureDetector(
                    onTap: () {
                      //go to Edit Profile and wait for result
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfilePage(user: currentUser),
                        ),
                      ).then((value) {
                        //if we returned with updated user data, refresh the state
                        if (value != null && value is User) {
                          setState(() {
                            currentUser = value;
                          });
                        }
                      });
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontFamily: 'Bubblegum Sans',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.edit, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  
                  // User Name
                  Text(
                    currentUser.userName ?? "No Name",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bubblegum Sans',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    currentUser.userEmail ?? "No Email",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // Profile Details in cards
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Phone Number
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.phone, color: Colors.orange),
                      title: const Text("Phone Number"),
                      subtitle: Text(currentUser.userPhone ?? "Not Set"),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 2. Donation History
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Colors.blue),
                      title: const Text('My Donation History'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DonationHistoryPage(user: currentUser),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. Adoption History
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Colors.deepPurple),
                      title: const Text('My Adoption Request History'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         AdoptionHistoryPage(user: currentUser),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 4. Logout Button
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Logout'),
                      onTap: () {
                        _confirmLogout();
                      },
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

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

