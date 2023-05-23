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
      required this.type});

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
      "specialization": specialization
    };
  }

  CompanyInfor.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : id = documentSnapshot.data()!["id"],
        name = documentSnapshot.data()!["name"],
        type = documentSnapshot.data()!["type"],
        email = documentSnapshot.data()!["email"],
        birthDate = documentSnapshot.data()!["birthDate"],
        phone = documentSnapshot.data()!["phone"],
        rating = documentSnapshot.data()!["rating"],
        bio = documentSnapshot.data()!["bio"],
        address = documentSnapshot.data()!["address"],
        profilePhoto = documentSnapshot.data()!["profilePhoto"],
        openHour = documentSnapshot.data()!["openHour"],
        closeHour = documentSnapshot.data()!["closeHour"],
        specification = documentSnapshot.data()!["specification"],
        specialization = documentSnapshot.data()!["specialization"];
}
