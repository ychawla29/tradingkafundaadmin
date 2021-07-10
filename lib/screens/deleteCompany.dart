import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:tradingkafundaadmin/bloc/bloc/deletecompany_bloc.dart';
import 'package:tradingkafundaadmin/color/colors.dart';

class DeleteCompany extends StatefulWidget {
  const DeleteCompany({Key key, this.companyId, this.markets})
      : super(key: key);

  @override
  _DeleteCompanyState createState() => _DeleteCompanyState();

  final String companyId;
  final List<dynamic> markets;
}

class _DeleteCompanyState extends State<DeleteCompany> {
  bool equity = true;
  bool future = true;
  bool option = true;
  bool commodity = true;
  bool forex = true;
  String companyName = '';
  String companyShortname = '';
  List<String> markets = List();
  List<String> discardMarkets = List();
  @override
  void initState() {
    markets = widget.markets
        .asMap()
        .values
        .toList()
        .map((e) => e.keys.first.toString())
        .toList();
    BlocProvider.of<DeletecompanyBloc>(context)
        .add(FetchCompanyDetailsEvent(widget.companyId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildCheckBox(String title, bool callBackValue,
            Function(bool value) callBackFunction) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: size.width * 0.30,
            child: CheckboxListTile(
              value: callBackValue,
              onChanged: callBackFunction,
              title: Text(title),
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Company"),
      ),
      body: BlocConsumer<DeletecompanyBloc, DeletecompanyState>(
          builder: (context, state) {
        if (state is DeletecompanyLoaded) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Container(
                      width: size.width * 0.5,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Company Name : ",
                            ),
                          ),
                          Expanded(
                            child: Text(state.companyName),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Container(
                      width: size.width * 0.50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Company Short Name : ",
                            ),
                          ),
                          Expanded(
                            child: Text(state.companyShortName),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Unselect the market type to delete",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (markets.contains("Equity"))
                    buildCheckBox("Equity", equity, (value) {
                      setState(() {
                        equity = value;
                        if (!value) {
                          discardMarkets.add("Equity");
                          markets.remove("Equity");
                        } else {
                          discardMarkets.remove("Equity");
                          markets.add("Equity");
                        }
                      });
                    }),
                  if (markets.contains("Futures"))
                    buildCheckBox("Futures", future, (value) {
                      setState(() {
                        future = value;
                        if (!value) {
                          discardMarkets.add("Futures");
                          markets.remove("Futures");
                        } else {
                          discardMarkets.remove("Futures");
                          markets.add("Futures");
                        }
                      });
                    }),
                  if (markets.contains("Options"))
                    buildCheckBox("Options", option, (value) {
                      setState(() {
                        option = value;
                        if (!value) {
                          discardMarkets.add("Options");
                          markets.remove("Options");
                        } else {
                          discardMarkets.remove("Options");
                          markets.add("Options");
                        }
                      });
                    }),
                  if (markets.contains("Commodity"))
                    buildCheckBox("Commodity", commodity, (value) {
                      setState(() {
                        commodity = value;
                        if (!value) {
                          discardMarkets.add("Commodity");
                          markets.remove("Commodity");
                        } else {
                          discardMarkets.remove("Commodity");
                          markets.add("Commodity");
                        }
                      });
                    }),
                  if (markets.contains("Forex"))
                    buildCheckBox("Forex", forex, (value) {
                      setState(() {
                        forex = value;
                        if (!value) {
                          discardMarkets.add("Forex");
                          markets.remove("Forex");
                        } else {
                          discardMarkets.remove("Forex");
                          markets.add("Forex");
                        }
                      });
                    }),
                  Container(
                    width: size.width * 0.50,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: size.width * 0.10,
                          child: RaisedButton.icon(
                            onPressed: () {
                              AlertDialog alertDialog = AlertDialog(
                                title: Text(
                                    "Delete ${state.companyName} from following markets"),
                                content: Text(discardMarkets.join(", ")),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No"),
                                  ),
                                  FlatButton(
                                      onPressed: () {
                                        List<Map<String, dynamic>> companyIds =
                                            List();
                                        for (var marketData in widget.markets) {
                                          if (discardMarkets.contains(
                                              marketData.keys.first)) {
                                            companyIds.add(marketData);
                                          }
                                        }
                                        print(
                                            "CompanyIds : ${companyIds.join(", ")}");
                                        BlocProvider.of<DeletecompanyBloc>(
                                                context)
                                            .add(
                                          DeleteCompanyEvent(
                                            companyId: widget.companyId,
                                            companyIds: companyIds,
                                            activeMarkets: markets,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text("Yes"))
                                ],
                              );

                              showDialog(
                                  context: context,
                                  builder: (_) => alertDialog);
                            },
                            icon: Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Update",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.20,
                          child: RaisedButton.icon(
                            onPressed: () {
                              AlertDialog alertDialog = AlertDialog(
                                title: Text("Delete ${state.companyName}"),
                                content: Text(
                                    "Are you sure you want to delete ${state.companyName} from all markets"),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No"),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      List<String> companyIds = List();
                                      for (var marketData in widget.markets) {
                                        companyIds.add(marketData.values.first);
                                      }
                                      BlocProvider.of<DeletecompanyBloc>(
                                              context)
                                          .add(DeleteCompanyFromAll(
                                              companyIds: widget.markets,
                                              companyId: widget.companyId));
                                      Navigator.pop(context);
                                    },
                                    child: Text("Yes"),
                                  ),
                                ],
                              );
                              showDialog(
                                context: context,
                                builder: (_) => alertDialog,
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Delete Company",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(ColorValues.blue),
              ),
            ],
          ),
        );
      }, listener: (context, state) {
        if (state is CompanyDeleted) {
          Toast.show('Company Deleted Successfully', context,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              gravity: Toast.BOTTOM,
              duration: Toast.LENGTH_SHORT);
          Navigator.pop(context);
        }
      }),
    );
  }
}
