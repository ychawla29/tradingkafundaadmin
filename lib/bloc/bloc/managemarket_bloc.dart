import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tradingkafundaadmin/model/model.dart';

part 'managemarket_event.dart';
part 'managemarket_state.dart';

class ManagemarketBloc extends Bloc<ManagemarketEvent, ManagemarketState> {
  ManagemarketBloc() : super(ManagemarketInitial());

  var firestore = FirebaseFirestore.instance;
  List<Map<String, List<MarketTypeData>>> marketDataList = List();
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
      case ResetMarketData:
        yield* resetMarketData(event as ResetMarketData);
        break;
      case RefreshMarketData:
        yield* refreshMarketData(event as RefreshMarketData);
        break;
    }
  }

  Stream<ManagemarketState> refreshMarketData(RefreshMarketData event) async* {
    yield ManagemarketLoaded(marketDataList, selectedIndex,
        selectedData: event.updatedData);
  }

  Stream<ManagemarketState> resetMarketData(ResetMarketData event) async* {
    yield ManagemarketInitial();
    selectedData.callType = 0;
    selectedData.targetList[0]["value"] = "";
    selectedData.targetList[0]["isAchieved"] = false;

    selectedData.targetList[1]["value"] = "";
    selectedData.targetList[1]["isAchieved"] = false;

    selectedData.targetList[2]["value"] = "";
    selectedData.targetList[2]["isAchieved"] = false;

    selectedData.targetList[3]["value"] = "";
    selectedData.targetList[3]["isAchieved"] = false;

    selectedData.commentList = List();

    selectedData.entryRate = 0;
    yield ManagemarketResetState(
        marketDataList: marketDataList,
        selectedData: selectedData,
        selectedIndex: selectedIndex);
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
      List<dynamic> commentList = List();
      if (event.updatedData.targetList[0]["isAchieved"] != null &&
          event.updatedData.targetList[0]["isAchieved"]) {
        if (event.updatedData.targetList[1]["isAchieved"]) {
          if (event.updatedData.targetList[2]["isAchieved"]) {
            commentList.add(Comment("All Targets Achieved, Call Closed",
                    DateTime.now().toString())
                .toMap());
            event.updatedData.callType = 2;
          } else {
            commentList.add(
                Comment("Target 1 and 2 Achieved", DateTime.now().toString())
                    .toMap());
          }
        } else {
          commentList.add(
              Comment("Target 1 Achieved", DateTime.now().toString()).toMap());
        }
      } else if (event.updatedData.targetList[3]["isAchived"] != null &&
          event.updatedData.targetList[3]["isAchived"]) {
        commentList.add(
            Comment("Stop Loss hit, Call Closed", DateTime.now().toString())
                .toMap());
        event.updatedData.callType = 2;
      }
      var reference = await firestore
          .doc(
              "marketType/${event.updatedData.marketTypeId}/data/${event.updatedData.docId}")
          .update({
        "isNew": false,
        "callType": event.updatedData.callType,
        "commentList": commentList,
        "entryRate": event.updatedData.entryRate,
        "targetList": event.updatedData.targetList,
        "updatedOn": DateTime.now().toString(),
      });
      for (int i = 0;
          i < marketDataList[selectedIndex].values.toList().length;
          i++) {
        for (int j = 0;
            j < marketDataList[selectedIndex].values.toList()[i].length;
            j++) {
          if (marketDataList[selectedIndex]
                  .values
                  .toList()[i][j]
                  .marketTypeName ==
              event.marketTypeName) {
            marketDataList[selectedIndex].values.toList()[i][j] =
                event.updatedData;
          }
        }
      }
    } else {
      List<dynamic> commentList = selectedData.commentList;
      if (commentList == null) {
        commentList = List();
      }
      if (selectedData.targetList[0]["isAchieved"]) {
        if (selectedData.targetList[1]["isAchieved"]) {
          if (event.updatedData.targetList[2]["isAchieved"]) {
            commentList.add({
              "comment": "All Targets Achieved, Call Closed",
              "time": DateTime.now().toString()
            });
            event.updatedData.callType = 2;
          }
        } else {
          if (event.updatedData.targetList[1]["isAchieved"]) {
            if (event.updatedData.targetList[2]["isAchieved"]) {
              commentList.add({
                "comment": "All Targets Achieved, Call Closed",
                "time": DateTime.now().toString()
              });
              event.updatedData.callType = 2;
            } else {
              commentList.add({
                "comment": "Target 2 Achieved",
                "time": DateTime.now().toString()
              });
            }
          }
        }
      } else {
        if (event.updatedData.targetList[0]["isAchieved"]) {}
      }
      if (event.updatedData.targetList[3]["isAchieved"]) {
        commentList.add(
            Comment("Stop Loss Hit, Call Closed", DateTime.now().toString())
                .toMap());
        event.updatedData.callType = 2;
      }
      var reference = await firestore
          .doc(
              "marketType/${event.updatedData.marketTypeId}/data/${event.updatedData.docId}")
          .update({
        "callType": event.updatedData.callType,
        "commentList": commentList,
        "entryRate": event.updatedData.entryRate,
        "targetList": event.updatedData.targetList,
        "updatedOn": DateTime.now().toString(),
      });
      for (int i = 0;
          i < marketDataList[selectedIndex].values.toList().length;
          i++) {
        for (int j = 0;
            j < marketDataList[selectedIndex].values.toList()[i].length;
            j++) {
          if (marketDataList[selectedIndex]
                  .values
                  .toList()[i][j]
                  .marketTypeName ==
              event.marketTypeName) {
            marketDataList[selectedIndex].values.toList()[i][j] =
                event.updatedData;
          }
        }
      }
    }
    yield ManagemarketLoaded(marketDataList, 0, message: "List Updated");
  }
}
