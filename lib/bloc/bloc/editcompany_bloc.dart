import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tradingkafundaadmin/model/model.dart';

part 'editcompany_event.dart';
part 'editcompany_state.dart';

class EditcompanyBloc extends Bloc<EditcompanyEvent, EditcompanyState> {
  EditcompanyBloc() : super(EditcompanyInitial());

  @override
  Stream<EditcompanyState> mapEventToState(
    EditcompanyEvent event,
  ) async* {
    switch (event.runtimeType) {
      case FetchCompanyDetailsEvent:
        yield* mapFetchCompanyEvent(event as FetchCompanyDetailsEvent);
        break;
      case SaveCompanyEvent:
        yield* mapSaveEditCompanyEvent(event as SaveCompanyEvent);
        break;
    }
  }

  Stream<EditcompanyState> mapFetchCompanyEvent(
      FetchCompanyDetailsEvent event) async* {
    yield EditcompanyInitial();
    var firestore = FirebaseFirestore.instance;
    var companyDetails =
        await firestore.doc("companyMaster/${event.companyId}").get();
    var companyData = companyDetails.data();
    yield EditcompanyLoaded(
        companyName: companyData["name"],
        companyShortName: companyData["shortName"]);
  }

  Stream<EditcompanyState> mapSaveEditCompanyEvent(
      SaveCompanyEvent event) async* {
    yield EditcompanyInitial();
    var firestore = FirebaseFirestore.instance;
    // ignore: unused_local_variable
    var companyReference = await firestore
        .doc("companyMaster/${event.companyId}")
        .update(Company.getCompanyJson(event.company));
    var marketCollection = await firestore.collection("marketType").get();
    for (var marketname in event.company.marketsList) {
      for (var market in marketCollection.docs) {
        if (market["name"] == marketname) {
          var marketReference = await firestore
              .collection("marketType/${market.id}/data")
              .add({"isNew": true, "companyID": event.companyId});
          if (marketReference == null) {}
        }
      }
    }
    yield EditcompanySaved();
  }
}
