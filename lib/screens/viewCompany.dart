import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradingkafundaadmin/bloc/bloc/deletecompany_bloc.dart';
import 'package:tradingkafundaadmin/bloc/bloc/editcompany_bloc.dart';
import 'package:tradingkafundaadmin/bloc/bloc/viewcompany_bloc.dart';
import 'package:tradingkafundaadmin/color/colors.dart';
import 'package:tradingkafundaadmin/screens/deleteCompany.dart';
import 'package:tradingkafundaadmin/screens/editCompany.dart';

List<Color> colorList = [
  Colors.blue,
  Colors.cyan,
  Colors.purple,
  Colors.orange,
  Colors.green,
  Colors.teal
];

class ViewCompany extends StatefulWidget {
  const ViewCompany({Key key}) : super(key: key);

  @override
  _ViewCompanyState createState() => _ViewCompanyState();
}

class _ViewCompanyState extends State<ViewCompany> {
  @override
  void initState() {
    BlocProvider.of<ViewcompanyBloc>(context).add(FetchViewCompanyEvent());
    super.initState();
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
              child: BlocConsumer<ViewcompanyBloc, ViewcompanyState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ViewcompanyInitial) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorValues.blue),
                    ),
                  ),
                );
              } else if (state is ViewcompanyLoaded) {
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                    "Markets : ${getMarketsName(state.companiesList[index].getMarketsList)}"),
                              ),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BlocProvider(
                                                  create: (context) =>
                                                      EditcompanyBloc(),
                                                  child: EditCompany(
                                                    companyId: state
                                                        .companiesList[index]
                                                        .getCompanyId,
                                                    markets: state
                                                        .companiesList[index]
                                                        .getMarketsList,
                                                  ),
                                                )));
                                  },
                                  child: Text("Edit")),
                              Text(" | "),
                              FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BlocProvider(
                                                  create: (context) =>
                                                      DeletecompanyBloc(),
                                                  child: DeleteCompany(
                                                    companyId: state
                                                        .companiesList[index]
                                                        .getCompanyId,
                                                    markets: state
                                                        .companiesList[index]
                                                        .getMarketsList,
                                                  ),
                                                )));
                                  },
                                  child: Text("Delete"))
                            ],
                          ),
                        ),
                        leading: CircleAvatar(
                          child: Text(
                            state.companiesList[index].getCompanyName()[0],
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.orange,
                        ),
                        title:
                            Text(state.companiesList[index].getCompanyName()),
                      );
                    },
                    itemCount: state.companiesList.length);
              }

              return SizedBox();
            },
          ))
        ],
      ),
    );
  }

  String getMarketsName(List<dynamic> marketsList) {
    List<String> marketString = [];
    for (var market in marketsList) {
      marketString.add(market.keys.first);
    }
    return marketString.join(", ");
  }
}
