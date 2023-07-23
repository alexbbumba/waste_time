class ScheduleModel {
  String companyId;
  String dateCreated;
  double customerLat;
  double customerLon;
  String status;
  String userId;
  String wasteWight;
  Map<String, dynamic> wasteType;

  ScheduleModel.fromFireBase(Map<String, dynamic> fbase)
      : companyId = fbase['companyId'],
        dateCreated = fbase['creationDate'],
        customerLat = fbase['customerLatitude'],
        customerLon = fbase['customerLongitude'],
        status = fbase['scheduleStatus'],
        userId = fbase['userId'],
        wasteWight = fbase['wasteWeight'],
        wasteType = fbase['wasteType'];
}
