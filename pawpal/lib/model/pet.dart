import 'dart:convert';

class Pet {
  String? petId;
  String? userId;
  String? petName;
  String? petType;
  String? category;
  String? description;
  List<dynamic>? imagePaths;
  String? lat;
  String? lng;
  String? createdAt;

  String? petAge;
  String? petGender;
  String? petHealth;


  Pet({
    this.petId,
    this.userId,
    this.petName,
    this.petAge,
    this.petGender,
    this.petType,
    this.category,
    this.petHealth,
    this.description,
    this.imagePaths,
    this.lat,
    this.lng,
    this.createdAt,
  });

  Pet.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id']?.toString();
    userId = json['user_id']?.toString();
    petName = json['pet_name'];
    petAge = json['age'];
    petGender = json['gender'];
    petType = json['pet_type'];
    category = json['category'];
    petHealth = json['health_status'];
    description = json['description'];

    // Handle imagePaths - backend returns it as List (already json_decoded in PHP)
    if (json['image_paths'] is List) {
      imagePaths = json['image_paths'] as List;
    } else if (json['image_paths'] is String) {
      try {
        imagePaths = jsonDecode(json['image_paths']) as List;
      } catch (e) {
        imagePaths = [];
      }
    } else {
      imagePaths = [];
    }

    // Handle latitude/longitude - database uses 'latitude' and 'longitude'
    lat = json['latitude']?.toString() ?? json['lat']?.toString();
    lng = json['longitude']?.toString() ?? json['lng']?.toString();
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['pet_age'] = petAge;
    data['pet_gender'] = petGender;
    data['pet_type'] = petType;
    data['category'] = category;
    data['pet_health'] = petHealth;
    data['description'] = description;
    data['image_paths'] = imagePaths;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = createdAt;
    return data;
  }
}
