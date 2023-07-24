import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:waste_time/models/company_info.dart';
import 'package:waste_time/util.dart';

class MainAppController extends GetxController {
  var pos = Rxn<Position>();

  var isLoading = false.obs;
  var selectedCompany = Rxn<CompanyInfor>();

  @override
  onInit() {
    loadUserLocation();
    super.onInit();
  }

  loadUserLocation() async {
    setLoadingStatus(true);
    pos.value = await determinePosition();
    print(pos.value);
    setLoadingStatus(false);
  }

  updateRecordStatus(var d, String newStatus) async {
    print(d.id);

    var data = d.data();

    print(data);

    data['scheduleStatus'] = newStatus;

    print(data);

    var collection = FirebaseFirestore.instance.collection('customerSchedules');
    await collection.doc(d.id).update(data);
  }

  set setSelectedCompany(CompanyInfor sCompny) {
    selectedCompany.value = sCompny;
  }

  setLoadingStatus(bool newStat) {
    isLoading.value = newStat;
    update();
  }
}
