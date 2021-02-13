import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'deletecompany_event.dart';
part 'deletecompany_state.dart';

class DeletecompanyBloc extends Bloc<DeletecompanyEvent, DeletecompanyState> {
  DeletecompanyBloc() : super(DeletecompanyInitial());

  @override
  Stream<DeletecompanyState> mapEventToState(
    DeletecompanyEvent event,
  ) async* {
    switch (event.runtimeType) {
      case FetchCompanyDetailsEvent:
        yield* mapFetchCompanyDetailsEvent(event as FetchCompanyDetailsEvent);
        break;
      case DeleteCompanyFromAll:
        yield* mapDeleteCompanFromAllEvent(event as DeleteCompanyFromAll);
        break;
      case DeleteCompanyEvent:
        yield* mapDeleteCompany(event as DeleteCompanyEvent);
        break;
    }
  }

  Stream<DeletecompanyState> mapFetchCompanyDetailsEvent(
      FetchCompanyDetailsEvent event) async* {
    yield DeletecompanyInitial();
    var firestore = FirebaseFirestore.instance;
    var companyDetails =
        await firestore.doc("companyMaster/${event.companyId}").get();
    var companyData = companyDetails.data();
    yield DeletecompanyLoaded(companyData["name"], companyData["shortName"]);
  }

  Stream<DeletecompanyState> mapDeleteCompanFromAllEvent(
      DeleteCompanyFromAll event) async* {
    yield DeletecompanyInitial();
    var firestore = FirebaseFirestore.instance;
    var companyDetails =
        await firestore.doc("companyMaster/${event.companyId}").delete();
    var marketDetails = await firestore.collection("marketType").get();
    for (var marketData in marketDetails.docs) {
      for (var deleteData in event.companyIds) {
        if (deleteData.keys.first == marketData["name"]) {
          var marketCollection = firestore
              .doc(
                  "marketType/${marketData.id}/data/${deleteData.values.first}")
              .delete();
        }
      }
    }
    yield CompanyDeleted();
  }

  Stream<DeletecompanyState> mapDeleteCompany(DeleteCompanyEvent event) async* {
    yield DeletecompanyInitial();
    var firestore = FirebaseFirestore.instance;
    var marketDetails = await firestore.collection("marketType").get();
    for (var marketData in marketDetails.docs) {
      for (var deleteData in event.companyIds) {
        if (deleteData.keys.first == marketData["name"]) {
          var marketCollection = firestore
              .doc(
                  "marketType/${marketData.id}/data/${deleteData.values.first}")
              .delete();
        }
      }
    }
    yield CompanyDeleted();
  }
}
