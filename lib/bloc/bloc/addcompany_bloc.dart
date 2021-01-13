import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tradingkafundaadmin/model/model.dart';

part 'addcompany_event.dart';
part 'addcompany_state.dart';

class AddcompanyBloc extends Bloc<AddcompanyEvent, AddcompanyState> {
  AddcompanyBloc() : super(AddcompanyInitial());

  @override
  Stream<AddcompanyState> mapEventToState(
    AddcompanyEvent event,
  ) async* {
    switch (event.runtimeType) {
      case AddCompanyEvent:
        yield* mapAddCompanyEventToState(event as AddCompanyEvent);
    }
  }

  Stream<AddcompanyState> mapAddCompanyEventToState(
      AddCompanyEvent event) async* {
    yield AddcompanyBusyState();
    var firestore = FirebaseFirestore.instance;
    var jsonData = Company.getCompanyJson(event.company);
    var reference = await firestore.collection("companyMaster").add(jsonData);
    if (reference.id != null) {
      var marketCollection = await firestore.collection("marketType").get();
      for (var marketname in event.company.marketsList) {
        for (var market in marketCollection.docs) {
          if (market["name"] == marketname) {
            var marketReference = await firestore
                .collection("marketType/${market.id}/data")
                .add({"isNew": true, "companyID": reference.id});
            if (marketReference == null) {}
          }
        }
      }
    }
    yield AddcompanyLoadedState();
  }
}
