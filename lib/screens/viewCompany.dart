import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradingkafundaadmin/color/colors.dart';

List<Color> colorList = [
  Colors.blue,
  Colors.cyan,
  Colors.purple,
  Colors.orange,
  Colors.green,
  Colors.teal
];

class ViewCompany extends StatelessWidget {
  const ViewCompany({Key key}) : super(key: key);

  Color getRandomColor() {
    Random random = Random();
    int index = random.nextInt(6);
    return colorList[index];
  }

  Future<List<String>> getDetails(String companyId) async {
    List<String> markets = List();
    var firestore = FirebaseFirestore.instance;
    var marketData = await firestore.collection("marketType").get();
    for (var doc in marketData.docs) {
      var snapData =
          await firestore.collection("marketType/${doc.id}/data").get();
      for (var snapDoc in snapData.docs) {
        if (snapDoc["companyID"] == companyId) markets.add(doc["name"]);
      }
    }
    return markets;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("companyMaster")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> dataSnapshots =
                        snapshot.data.documents;
                    if (dataSnapshots.isNotEmpty) {
                      return ListView.separated(
                        separatorBuilder: (context, index) {
                          return Container(
                            height: 1,
                            color: Colors.grey,
                            width: MediaQuery.of(context).size.width,
                          );
                        },
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {},
                            subtitle: Container(
                              height: 30,
                              child: FutureBuilder<List<String>>(
                                future: getDetails(dataSnapshots[index].id),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData)
                                    return Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                                "Markets : ${snapshot.data.join(", ")}")),
                                      ],
                                    );
                                  else
                                    return CupertinoActivityIndicator(
                                      animating: true,
                                    );
                                },
                              ),
                            ),
                            leading: CircleAvatar(
                              child: Text(
                                dataSnapshots[index]["name"][0],
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.orange,
                            ),
                            title: Text(dataSnapshots[index]["name"]),
                          );
                        },
                        itemCount: dataSnapshots.length,
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(ColorValues.blue),
                        ),
                      );
                    }
                  }
                  return Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorValues.blue),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
