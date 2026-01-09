import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/model/pet.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/pages/login_page.dart';
import 'package:pawpal/pages/submit_pet_page.dart';
import 'package:pawpal/pages/pet_details_page.dart';

class BrowsePets extends StatefulWidget {
  final User? user;
  const BrowsePets({super.key, this.user});

  @override
  State<BrowsePets> createState() => _BrowsePetsState();
}

class _BrowsePetsState extends State<BrowsePets> {
  User? currentUser;
  List<Pet> listPets = [];
  List<String> categories = ["All", "Cat", "Dog", "Other"];

  String selectedCategory = "All";
  String searchQuery = "";
  bool isLoading = true;
  late double screenWidth, screenHeight;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
    loadPets();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // final contentWidth = screenWidth > 900 ? 900.0 : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              loadPets();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          //top section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.orange[100],
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "PawPal",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bubblegum Sans',
                    ),
                  ),
                  SizedBox(width: 20),

                  //search bar
                  SizedBox(
                    width: 400,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white70,
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: Icon(Icons.cancel),
                        labelText: 'Search by Pet Name',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) => searchPets(value),
                    ),
                  ),
                  const SizedBox(width: 10),

                  //filter dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration (
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: DropdownButton<String>(
                        value: selectedCategory,
                        underline: Container(),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                            isLoading = true;
                          });
                          loadPets();
                        },
                      ),
                  ),

                  const Spacer(),

                  // Submit Pet Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubmitPetScreen(
                            currentUser: currentUser ?? User(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[400],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Submit Pet',
                      style: TextStyle(
                        fontFamily: 'Bubblegum Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //bottom section
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : listPets.isEmpty
                ? const Center(child: Text('No submissions yet.'))
                : ListView.builder(
                    itemCount: listPets.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      return showPetCard(index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void searchPets(String petName) {}

  Widget showPetCard(int index) {
    Pet pet = listPets[index];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetailsPage(user: currentUser!, pet: pet),
          ),
        );
      },
      
      child: Card(
        color: Colors.orangeAccent[100],
        elevation: 5,
        margin: const EdgeInsets.all(10),
      
        //image
        child: Container(
          height: 140,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: pet.imagePaths != null
                    ? Image.network(
                        '${MyConfig.baseUrl}/pawpal/server/${pet.imagePaths![0]}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : Icon(Icons.broken_image, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 10),  
      
              //name and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${pet.petName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Pet Type: ${pet.petType}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Age: ${pet.petAge}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    //should move to pet details page
                    // Text(
                    //   'Description: ${pet.description}',
                    //   maxLines: 2,
                    //   overflow: TextOverflow.ellipsis,
                    //   style: const TextStyle(
                    //     fontSize: 14,
                    //     fontStyle: FontStyle.italic,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.deepOrange, size: 20),
              const SizedBox(width: 10),          
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadPets() async {
    try {
      final fetchedPets = await http.get(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/server/pawpal/api/get_my_pets.php',
        ),
      );

      var resArray = jsonDecode(fetchedPets.body);
      if (resArray['status'] == 'success') {
        var petsData = resArray['data'] as List;
        setState(() {
          isLoading = false;
          listPets = petsData.map((petJson) => Pet.fromJson(petJson)).toList();
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
