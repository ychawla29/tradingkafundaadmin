import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tradingkafundaadmin/model/model.dart';

part 'viewcompany_event.dart';
part 'viewcompany_state.dart';

class ViewcompanyBloc extends Bloc<ViewcompanyEvent, ViewcompanyState> {
  ViewcompanyBloc() : super(ViewcompanyInitial());
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Company> companiesList = [];

  @override
  Stream<ViewcompanyState> mapEventToState(
    ViewcompanyEvent event,
  ) async* {
    switch (event.runtimeType) {
      case FetchViewCompanyEvent:
        yield* fetchCompanies();
        break;
      default:
    }
  }

  Stream<ViewcompanyState> fetchCompanies() async* {
    yield ViewcompanyInitial();
    companiesList.clear();
    Query q = _firebaseFirestore.collection("companyMaster").orderBy("name");
    QuerySnapshot companySnapShots = await q.get();
    for (QueryDocumentSnapshot companyData in companySnapShots.docs) {
      Company company = Company();
      company.setCompanyId = companyData.id;
      company.setCompanyName(companyData["name"]);
      company.setShortName(companyData["shortName"]);
      company.setMarketsList = companyData["markets"];
      companiesList.add(company);
    }
    yield ViewcompanyLoaded(companiesList);
  }

  Future<List<Map<String, String>>> getDetails(String companyId) async {
    List<Map<String, String>> markets = [];
    var marketData = await _firebaseFirestore.collection("marketType").get();
    for (var doc in marketData.docs) {
      var snapData = await _firebaseFirestore
          .collection("marketType/${doc.id}/data")
          .get();
      for (var snapDoc in snapData.docs) {
        if (snapDoc["companyID"] == companyId)
          markets.add({doc["name"]: snapDoc.id});
      }
    }
    return markets;
  }
}
