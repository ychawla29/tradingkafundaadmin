import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tradingkafundaadmin/model/model.dart';

part 'managemarket_event.dart';
part 'managemarket_state.dart';

class ManagemarketBloc extends Bloc<ManagemarketEvent, ManagemarketState> {
  ManagemarketBloc() : super(ManagemarketInitial());

  List<Map<String, List<MarketTypeData>>> marketDataList = List();
  var firestore = FirebaseFirestore.instance;
  MarketTypeData selectedData;
  int selectedIndex;
  @override
  Stream<ManagemarketState> mapEventToState(
    ManagemarketEvent event,
  ) async* {
    switch (event.runtimeType) {
      case FetchMarketData:
        yield* fetchMarketData(event as FetchMarketData);
        break;
      case ChangeSelectedIndex:
        yield* changeSelectedIndex(event as ChangeSelectedIndex);
        break;
      case SetSelectedData:
        yield* setSelectedData(event as SetSelectedData);
        break;
      case UpdateManageData:
        yield* updateManageData(event as UpdateManageData);
        break;
    }
  }

  Stream<ManagemarketState> fetchMarketData(FetchMarketData event) async* {
    yield ManagemarketInitial();
    marketDataList.clear();
    var companyCollection = await firestore.collection("companyMaster").get();
    var marketCollection = await firestore.collection("marketType").get();
    for (var company in companyCollection.docs) {
      List<MarketTypeData> listMarketData = List();
      for (var marketData in marketCollection.docs) {
        var docCollection = await firestore
            .collection("marketType/${marketData.id}/data")
            .get();
        for (var doc in docCollection.docs) {
          if (doc["companyID"] == company.id) {
            if (doc["isNew"] == false) {
              MarketTypeData marketTypeData = MarketTypeData();
              marketTypeData.companyID = company.id;
              marketTypeData.marketTypeName = marketData["name"];
              marketTypeData.callType = doc["callType"];
              marketTypeData.commentList = doc["commentList"];
              marketTypeData.entryRate = doc["entryRate"];
              marketTypeData.marketTypeId = marketData.id;
              marketTypeData.docId = doc.id;
              marketTypeData.targetList = doc["targetList"];
              marketTypeData.isNew = doc["isNew"];
              listMarketData.add(marketTypeData);
            } else {
              MarketTypeData marketTypeData = MarketTypeData();
              marketTypeData.companyID = company.id;
              marketTypeData.marketTypeName = marketData["name"];
              marketTypeData.marketTypeId = marketData.id;
              marketTypeData.docId = doc.id;
              marketTypeData.isNew = doc["isNew"];
              listMarketData.add(marketTypeData);
            }
          }
        }
      }
      marketDataList.add({company["name"]: listMarketData});
    }
    yield ManagemarketLoaded(marketDataList, 0);
  }

  Stream<ManagemarketState> changeSelectedIndex(
      ChangeSelectedIndex event) async* {
    yield ManagemarketInitial();
    selectedIndex = event.selectedIndex;
    yield ManagemarketLoaded(marketDataList, event.selectedIndex);
  }

  Stream<ManagemarketState> setSelectedData(SetSelectedData event) async* {
    yield ManagemarketInitial();
    selectedData = event.marketTypeData;
    yield ManagemarketLoaded(marketDataList, selectedIndex,
        selectedData: event.marketTypeData);
  }

  Stream<ManagemarketState> updateManageData(UpdateManageData event) async* {
    yield ManagemarketInitial();
    print(
        "marketType/${event.updatedData.marketTypeId}/data/${event.updatedData.docId}");
    if (selectedData.isNew) {
      List<Comment> commentList = List();
      var reference = await firestore
          .doc(
              "marketType/${event.updatedData.marketTypeId}/data/${event.updatedData.docId}")
          .update({
        "isNew": false,
        "callType": event.updatedData.callType,
        "commentList": commentList,
        "entryRate": event.updatedData.entryRate,
        "targetList": event.updatedData.targetList,
        "updatedOn": DateTime.now(),
      });
      marketDataList[selectedIndex]
          .values
          .where((element) =>
              element
                  .where((element) =>
                      element.companyID == event.updatedData.companyID)
                  .toList()
                  .first !=
              null)
          .toList()
          .first
          .first = event.updatedData;
      yield ManagemarketLoaded(marketDataList, 0, message: "List updated");
    } else {
      List<Comment> commentList = List();
      var reference = await firestore
          .doc(
              "marketType/${event.updatedData.marketTypeId}/data/${event.updatedData.docId}")
          .update({
        "callType": event.updatedData.callType,
        "commentList": commentList,
        "entryRate": event.updatedData.entryRate,
        "targetList": event.updatedData.targetList,
        "updatedOn": DateTime.now(),
      });
      marketDataList[selectedIndex]
          .values
          .where((element) =>
              element
                  .where((element) =>
                      element.companyID == event.updatedData.companyID)
                  .toList()
                  .first !=
              null)
          .toList()
          .first
          .first = event.updatedData;
      yield ManagemarketLoaded(marketDataList, 0, message: "List Updated");
    }
  }
}
