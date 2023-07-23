import 'package:waste_time/models/company_info.dart';

class ShortestModel {
  CompanyInfor company;
  double distance;

  ShortestModel({required this.company, required this.distance});

  @override
  String toString() {
    return '$distance Name: ${company.name}';
  }
}
