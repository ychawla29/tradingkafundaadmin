import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradingkafundaadmin/model/model.dart';

class AddData {
  static void addCompanyData(Company company) async {
    var jsonData = Company.getCompanyJson(company);
    var reference =
        FirebaseFirestore.instance.collection("companyMaster").add(jsonData);
  }
}
