import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyInfor {
  final String id;
  final String name;
  final String type;
  final String email;
  final dynamic birthDate;
  final dynamic phone;
  final dynamic bio;
  final dynamic address;
  final dynamic profilePhoto;
  final String openHour;
  final String closeHour;
  final dynamic rating;
  final dynamic specification;
  final String specialization;
  final GeoPoint location;

  CompanyInfor(
      {required this.id,
      required this.name,
      this.address,
      this.bio,
      this.birthDate,
      required this.closeHour,
      required this.email,
      required this.openHour,
      this.phone,
      this.profilePhoto,
      this.rating,
      required this.specialization,
      this.specification,
      required this.type,
      required this.location});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "email": email,
      "birthDate": birthDate,
      "phone": phone,
      "rating": rating,
      "bio": bio,
      "address": address,
      "profilePhoto": profilePhoto,
      "openHour": openHour,
      "closeHour": closeHour,
      "specification": specification,
      "specialization": specialization,
      'location': location
    };
  }

  CompanyInfor.fromDocumentSnapshot(Map<String, dynamic> documentSnapshot)
      : id = documentSnapshot["id"],
        name = documentSnapshot["name"],
        type = documentSnapshot["type"],
        email = documentSnapshot["email"],
        birthDate = documentSnapshot["birthDate"],
        phone = documentSnapshot["phone"],
        rating = documentSnapshot["rating"],
        bio = documentSnapshot["bio"],
        address = documentSnapshot["address"],
        profilePhoto = documentSnapshot["profilePhoto"],
        openHour = documentSnapshot["openHour"],
        closeHour = documentSnapshot["closeHour"],
        specification = documentSnapshot["specification"],
        specialization = documentSnapshot["specialization"],
        location = documentSnapshot["location"];
}
