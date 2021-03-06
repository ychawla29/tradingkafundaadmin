import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradingkafundaadmin/model/model.dart';

class AddData {
  static void addCompanyData(Company company) async {
    var jsonData = Company.getCompanyJson(company);
    var reference = await FirebaseFirestore.instance
        .collection("companyMaster")
        .add(jsonData);
    if (reference.id != null) {
      print("Document Added: ${reference.id}");
    }
  }
}
