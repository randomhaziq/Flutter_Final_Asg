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

  Pet({
    this.petId,
    this.userId,
    this.petName,
    this.petType,
    this.category,
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
    petType = json['pet_type'];
    category = json['category'];
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
    data['pet_type'] = petType;
    data['category'] = category;
    data['description'] = description;
    data['image_paths'] = imagePaths;
    data['lat'] = lat;
    data['lng'] = lng;
    data['created_at'] = createdAt;
    return data;
  }
}
