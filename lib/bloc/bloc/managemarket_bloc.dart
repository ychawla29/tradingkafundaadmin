import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tradingkafundaadmin/constants/marketConstants.dart';
import 'package:tradingkafundaadmin/model/model.dart';

part 'managemarket_event.dart';
part 'managemarket_state.dart';

class ManagemarketBloc extends Bloc<ManagemarketEvent, ManagemarketState> {
  ManagemarketBloc() : super(ManagemarketInitial());

  var firestore = FirebaseFirestore.instance;
  List<String> marketDataList = List();
  List<MarketTypeData> companyList = List();
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
        selectedData: event.updatedData, companyList: companyList);
  }

  Stream<ManagemarketState> resetMarketData(ResetMarketData event) async* {
    yield ManagemarketInitial();
    selectedData.callType = 0;
    if (selectedData.targetList != null) {
      selectedData.targetList[0]["value"] = "";
      selectedData.targetList[0]["isAchieved"] = false;

      selectedData.targetList[1]["value"] = "";
      selectedData.targetList[1]["isAchieved"] = false;

      selectedData.targetList[2]["value"] = "";
      selectedData.targetList[2]["isAchieved"] = false;

      selectedData.targetList[3]["value"] = "";
      selectedData.targetList[3]["isAchieved"] = false;
    }
    selectedData.commentList = List();

    selectedData.entryRate = 0;
    yield ManagemarketResetState(
        marketDataList: marketDataList,
        selectedData: selectedData,
        selectedIndex: selectedIndex,
        companyList: companyList);
  }

  Stream<ManagemarketState> fetchMarketData(FetchMarketData event) async* {
    yield ManagemarketInitial();
    marketDataList.clear();
    companyList.clear();
    var marketCollection = await firestore.collection("marketType").get();
    for (QueryDocumentSnapshot marketData in marketCollection.docs) {
      marketDataList.add(marketData["name"]);
    }
    yield ManagemarketLoaded(marketDataList, null, companyList: companyList);
  }

  Stream<ManagemarketState> changeSelectedIndex(
      ChangeSelectedIndex event) async* {
    yield ManagemarketInitial();
    selectedIndex = event.selectedIndex;
    companyList.clear();
    print("marketType : ${marketDataList[selectedIndex]}");
    String marketId = getMarketTypeId(marketDataList[selectedIndex]);
    print("ID: marketType/$marketId/data");
    var companyCollection =
        await firestore.collection("marketType/$marketId/data").get();
    for (QueryDocumentSnapshot companyData in companyCollection.docs) {
      MarketTypeData company = MarketTypeData();
      company.companyID = companyData["companyID"];
      company.isNew = companyData["isNew"];
      company.marketTypeId = marketId;
      company.docId = companyData.id;
      company.companyName = await getCompanyDetails(company.companyID);
      if (!company.isNew) {
        company.marketTypeName = marketDataList[selectedIndex];
        company.callType = companyData["callType"];
        company.commentList = companyData["commentList"];
        company.entryRate = companyData["entryRate"];
        company.targetList = companyData["targetList"];
        company.updatedOn = DateTime.parse(companyData["updatedOn"]);
      }
      if (company.companyName != '') companyList.add(company);
    }
    yield ManagemarketLoaded(marketDataList, event.selectedIndex,
        companyList: companyList);
  }

  Stream<ManagemarketState> setSelectedData(SetSelectedData event) async* {
    yield ManagemarketInitial();
    selectedData = event.marketTypeData;
    yield ManagemarketLoaded(marketDataList, selectedIndex,
        selectedData: event.marketTypeData, companyList: companyList);
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
            var companyDetails = await firestore
                .doc("companyMaster/${event.updatedData.companyID}")
                .get();
            var companyName = companyDetails.data()["name"];
            var time = DateTime.now().toString();
            firestore.collection("notification").add({
              "title": "TradingKaFunda",
              "body": "$companyName - All Targets Achieved, Call Closed",
              "time": time.substring(
                0,
                time.lastIndexOf("."),
              ),
              "companyID": event.updatedData.companyID
            });
            event.updatedData.callType = 2;
          } else {
            commentList.add(
                Comment("Target 1 and 2 Achieved", DateTime.now().toString())
                    .toMap());
            var companyDetails = await firestore
                .doc("companyMaster/${event.updatedData.companyID}")
                .get();
            var companyName = companyDetails.data()["name"];
            var time = DateTime.now().toString();
            firestore.collection("notification").add({
              "title": "TradingKaFunda",
              "body": "$companyName - Target 1 and 2 Achieved",
              "time": time.substring(
                0,
                time.lastIndexOf("."),
              ),
              "companyID": event.updatedData.companyID
            });
          }
        } else {
          commentList.add(
              Comment("Target 1 Achieved", DateTime.now().toString()).toMap());
          var companyDetails = await firestore
              .doc("companyMaster/${event.updatedData.companyID}")
              .get();
          var companyName = companyDetails.data()["name"];
          var time = DateTime.now().toString();
          firestore.collection("notification").add({
            "title": "TradingKaFunda",
            "body": "$companyName - Target 1 Achieved",
            "time": time.substring(
              0,
              time.lastIndexOf("."),
            ),
            "companyID": event.updatedData.companyID
          });
        }
      } else if (event.updatedData.targetList[3]["isAchived"] != null &&
          event.updatedData.targetList[3]["isAchived"]) {
        commentList.add(
            Comment("Stop Loss hit, Call Closed", DateTime.now().toString())
                .toMap());
        var companyDetails = await firestore
            .doc("companyMaster/${event.updatedData.companyID}")
            .get();
        var companyName = companyDetails.data()["name"];
        var time = DateTime.now().toString();
        firestore.collection("notification").add({
          "title": "TradingKaFunda",
          "body": "$companyName - Stop Loss hit, Call Closed",
          "time": time.substring(
            0,
            time.lastIndexOf("."),
          ),
          "companyID": event.updatedData.companyID
        });
        event.updatedData.callType = 2;
      }
      var reference = await firestore
          .doc(
              "marketType/${event.updatedData.marketTypeId}/data/${event.updatedData.docId}")
          .update({
        "isNew": false,
        "updatedOn": DateTime.now().toString(),
        "callType": event.updatedData.callType,
        "commentList": commentList,
        "entryRate": event.updatedData.entryRate,
        "targetList": event.updatedData.targetList,
      });
      event.updatedData.commentList = commentList;
    } else {
      List<dynamic> commentList = selectedData.commentList;
      print("CommentList: ${selectedData.commentList}");
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
            var companyDetails = await firestore
                .doc("companyMaster/${event.updatedData.companyID}")
                .get();
            var companyName = companyDetails.data()["name"];
            var time = DateTime.now().toString();
            firestore.collection("notification").add({
              "title": "TradingKaFunda",
              "body": "$companyName - All Targets Achieved, Call Closed",
              "time": time.substring(
                0,
                time.lastIndexOf("."),
              ),
              "companyID": event.updatedData.companyID
            });
            event.updatedData.callType = 2;
          }
        } else {
          commentList.add({
            "comment": "Target 2 Achieved",
            "time": DateTime.now().toString()
          });

          var time = DateTime.now().toString();
          var companyDetails = await firestore
              .doc("companyMaster/${event.updatedData.companyID}")
              .get();
          var companyName = companyDetails.data()["name"];
          firestore.collection("notification").add({
            "title": "TradingKaFunda",
            "body": "$companyName - Target 2 Achieved",
            "time": time.substring(
              0,
              time.lastIndexOf("."),
            ),
            "companyID": event.updatedData.companyID
          });
        }
      } else {
        if (event.updatedData.targetList[0]["isAchieved"]) {
          if (event.updatedData.targetList[1]["isAchieved"]) {
            if (event.updatedData.targetList[2]["isAchieved"]) {
              commentList.add({
                "comment": "All Targets Achieved, Call Closed",
                "time": DateTime.now().toString()
              });
              var companyDetails = await firestore
                  .doc("companyMaster/${event.updatedData.companyID}")
                  .get();
              var companyName = companyDetails.data()["name"];
              var time = DateTime.now().toString();
              firestore.collection("notification").add({
                "title": "TradingKaFunda",
                "body": "$companyName - All Targets Achieved, Call Closed",
                "time": time.substring(
                  0,
                  time.lastIndexOf("."),
                ),
                "companyID": event.updatedData.companyID
              });
              event.updatedData.callType = 2;
            } else {
              commentList.add({
                "comment": "Target 1 and 2 Achieved",
                "time": DateTime.now().toString()
              });
              var companyDetails = await firestore
                  .doc("companyMaster/${event.updatedData.companyID}")
                  .get();
              var companyName = companyDetails.data()["name"];
              var time = DateTime.now().toString();
              firestore.collection("notification").add({
                "title": "TradingKaFunda",
                "body": "$companyName - Target 1 and 2 Achieved",
                "time": time.substring(
                  0,
                  time.lastIndexOf("."),
                ),
                "companyID": event.updatedData.companyID
              });
            }
          } else {
            var time = DateTime.now().toString();
            commentList.add({
              "comment": "Target 1 Achieved",
              "time": DateTime.now().toString()
            });
            var companyDetails = await firestore
                .doc("companyMaster/${event.updatedData.companyID}")
                .get();
            var companyName = companyDetails.data()["name"];
            firestore.collection("notification").add({
              "title": "TradingKaFunda",
              "body": "$companyName - Target 1 Achieved",
              "time": time.substring(
                0,
                time.lastIndexOf("."),
              ),
              "companyID": event.updatedData.companyID
            });
          }
        } else {
          event.updatedData.commentList = List();
        }
        if (!event.updatedData.targetList[0]["isAchieved"] &&
            event.updatedData.targetList[3]["isAchieved"]) {
          commentList.add(
              Comment("Stop Loss Hit, Call Closed", DateTime.now().toString())
                  .toMap());
          var companyDetails = await firestore
              .doc("companyMaster/${event.updatedData.companyID}")
              .get();
          var companyName = companyDetails.data()["name"];
          var time = DateTime.now().toString();
          firestore.collection("notification").add({
            "title": "TradingKaFunda",
            "body": "$companyName - Stop Loss Hit, Call Closed",
            "time": time.substring(
              0,
              time.lastIndexOf("."),
            ),
            "companyID": event.updatedData.companyID
          });
          event.updatedData.callType = 2;
        }
      }
      var reference = await firestore
          .doc(
              "marketType/${event.updatedData.marketTypeId}/data/${event.updatedData.docId}")
          .update({
        "callType": event.updatedData.callType,
        "commentList": commentList,
        "entryRate": event.updatedData.entryRate,
        "targetList": event.updatedData.targetList,
      });
    }
    for (int i = 0; i < companyList.length; i++) {
      if (companyList[i].companyID == event.updatedData.companyID) {
        companyList[i] = event.updatedData;
      }
    }
    yield ManagemarketLoaded(marketDataList, selectedIndex,
        message: "List Updated", companyList: companyList);
  }

  String getMarketTypeId(String marketName) {
    if (marketName == "Equity")
      return MarketConstants.EQUITY;
    else if (marketName == "Commodity")
      return MarketConstants.COMMODITY;
    else if (marketName == "Forex")
      return MarketConstants.FOREX;
    else if (marketName == "Options")
      return MarketConstants.OPTIONS;
    else
      return MarketConstants.FUTURES;
  }

  Future<String> getCompanyDetails(String companyID) async {
    print("companyMaster/$companyID");
    try {
      var companyData = await firestore.doc("companyMaster/$companyID").get();
      String name = companyData["name"];
      return name;
    } catch (e) {
      return '';
    }
  }
}
