import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/model/pet.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/pages/profile_page.dart';
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
  List<String> categories = ["All", "Cat", "Dog", "Bird", "Other"];

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
        actionsPadding: EdgeInsets.symmetric(horizontal: 16),
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
      icon: const Icon(Icons.person),
      onPressed: () async {
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(user: currentUser!),
          ),
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
                      controller: searchController,
                      onSubmitted: (value) => searchPets(value),
                      decoration: InputDecoration(
                        fillColor: Colors.white70,
                        filled: true,
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              searchQuery = '';
                              isLoading = true;
                            });
                            loadPets();
                          },
                        ),
                        labelText: 'Search by Pet Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                                   
                 //ICON: ICON.FILTER
                  const Icon(Icons.filter_list, size: 30), 
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

  void searchPets(String petName) {
    setState(() {
      searchQuery = petName;
      isLoading = true;
    });
    loadPets();
  }

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
          height: 200,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 150,
                height: 150,
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
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Bubblegum Sans',
                      ),
                    ),
                    Text(
                      'Pet Type: ${pet.petType}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Age: ${pet.petAge}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
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
    listPets.clear();
    setState(() {
      isLoading = true;
    });

    String url = '${MyConfig.baseUrl}/pawpal/server/pawpal/api/get_my_pets.php';
    Map<String, String> queryParams = {};
    
    if (searchQuery.isNotEmpty) queryParams['search'] = searchQuery;
    if (selectedCategory != "All") queryParams['type'] = selectedCategory;

    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      var resArray = jsonDecode(response.body);
      if (resArray['status'] == 'success') {
        var petsData = resArray['data'] as List;
        setState(() {
          listPets = petsData.map((petJson) => Pet.fromJson(petJson)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          if (resArray['status'] == 'failed') {
             listPets.clear();
          }
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
