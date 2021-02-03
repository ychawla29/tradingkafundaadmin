import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:tradingkafundaadmin/bloc/bloc/managemarket_bloc.dart';
import 'package:tradingkafundaadmin/color/colors.dart';
import 'package:tradingkafundaadmin/model/model.dart';

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  String dropdownValue;
  String dropdownValue1;

  bool checkedTarget1 = false;
  bool checkedTarget2 = false;
  bool checkedTarget3 = false;
  bool checkedStopLoss = false;

  bool checkedTypeBuy = false;
  bool checkedTypeSell = false;
  bool checkedTypeClosed = false;

  TextEditingController editingControllerTarget1 = TextEditingController();
  TextEditingController editingControllerTarget2 = TextEditingController();
  TextEditingController editingControllerTarget3 = TextEditingController();
  TextEditingController editingControllerStopLoss = TextEditingController();
  TextEditingController editingControllerEntryRate = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<ManagemarketBloc>(context).add(FetchMarketData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget textField(String title, TextEditingController _controller) =>
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            width: size.width * 0.07,
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: title),
              validator: (value) {
                if (value.isEmpty) return "This field cannot be empty";
                return null;
              },
            ),
          ),
        );

    Widget addButtonRow({MarketTypeData oldData}) => Container(
          width: size.width * 0.35,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: size.width * 0.10,
                child: RaisedButton.icon(
                  onPressed: () {
                    MarketTypeData marketTypeData = MarketTypeData();
                    marketTypeData.companyID = oldData.companyID;
                    marketTypeData.marketTypeId = oldData.marketTypeId;
                    marketTypeData.docId = oldData.docId;
                    if (checkedTypeBuy) marketTypeData.callType = 0;
                    if (checkedTypeSell) marketTypeData.callType = 1;
                    if (checkedTypeClosed) marketTypeData.callType = 2;
                    marketTypeData.targetList = List();
                    marketTypeData.targetList.add({
                      "isAchieved": checkedTarget1,
                      "value": double.parse(editingControllerTarget1.text),
                      "name": "Target 1"
                    });
                    marketTypeData.targetList.add({
                      "isAchieved": checkedTarget2,
                      "value": double.parse(editingControllerTarget2.text),
                      "name": "Target 2"
                    });
                    marketTypeData.targetList.add({
                      "isAchieved": checkedTarget3,
                      "value": double.parse(editingControllerTarget3.text),
                      "name": "Target 3"
                    });
                    marketTypeData.targetList.add({
                      "isAchieved": checkedStopLoss,
                      "value": double.parse(editingControllerStopLoss.text),
                      "name": "Stop Loss"
                    });
                    marketTypeData.entryRate =
                        double.parse(editingControllerEntryRate.text);
                    BlocProvider.of<ManagemarketBloc>(context)
                        .add(UpdateManageData(marketTypeData));
                  },
                  icon: Icon(
                    Icons.update,
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
                width: size.width * 0.10,
                child: RaisedButton.icon(
                  onPressed: () {
                    setState(() {
                      checkedTarget1 = false;
                      checkedTarget2 = false;
                      checkedTarget3 = false;
                      checkedStopLoss = false;
                      editingControllerEntryRate.text = "";
                      editingControllerStopLoss.text = "";
                      editingControllerTarget1.text = "";
                      editingControllerTarget2.text = "";
                      editingControllerTarget3.text = "";
                    });
                  },
                  icon: Icon(
                    Icons.restore_page,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Reset",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
        );

    return SafeArea(
        child: BlocConsumer<ManagemarketBloc, ManagemarketState>(
      listener: (context, state) {
        if (state is ManagemarketLoaded) {
          if (state.message != null) {
            dropdownValue = null;
            dropdownValue1 = null;
            Toast.show('Market details updated successfully', context,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                gravity: Toast.BOTTOM,
                duration: Toast.LENGTH_SHORT);
          }
          if (state.selectedData != null) {
            if (!state.selectedData.isNew) {
              checkedTypeBuy = state.selectedData.callType == 0;
              checkedTypeSell = state.selectedData.callType == 1;
              checkedTypeClosed = state.selectedData.callType == 2;

              checkedTarget1 = state.selectedData.targetList[0]["isAchieved"];
              checkedTarget2 = state.selectedData.targetList[1]["isAchieved"];
              checkedTarget3 = state.selectedData.targetList[2]["isAchieved"];
              checkedStopLoss = state.selectedData.targetList[3]["isAchieved"];

              editingControllerTarget1.text =
                  state.selectedData.targetList[0]["value"].toString();
              editingControllerTarget2.text =
                  state.selectedData.targetList[1]["value"].toString();
              editingControllerTarget3.text =
                  state.selectedData.targetList[2]["value"].toString();
              editingControllerStopLoss.text =
                  state.selectedData.targetList[3]["value"].toString();

              editingControllerEntryRate.text =
                  state.selectedData.entryRate.toString();
            } else {
              checkedTypeBuy = true;
              editingControllerTarget1.text = "";
              editingControllerTarget2.text = "";
              editingControllerTarget3.text = "";
              editingControllerStopLoss.text = "";
              editingControllerEntryRate.text = "";
            }
          }
        } else if (state is ManagemarketResetState) {
          checkedTarget1 = false;
          checkedTarget2 = false;
          checkedTarget3 = false;
          checkedStopLoss = false;
          checkedTypeBuy = false;
          checkedTypeClosed = false;
          checkedTypeSell = false;
          editingControllerEntryRate.text = "";
          editingControllerStopLoss.text = "";
          editingControllerTarget1.text = "";
          editingControllerTarget2.text = "";
          editingControllerTarget3.text = "";
        }
      },
      builder: (context, state) {
        if (state is ManagemarketLoaded) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Please select company name: ",
                        textScaleFactor: 1.2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        items: state.marketDataList
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value.keys.first,
                            child: Text(value.keys.first),
                          );
                        }).toList(),
                        hint: Text("Select Company"),
                        onChanged: (newValue) {
                          BlocProvider.of<ManagemarketBloc>(context).add(
                              ChangeSelectedIndex(state.marketDataList
                                  .indexWhere((element) =>
                                      element.keys.first == newValue)));
                          setState(() {
                            dropdownValue1 = newValue;
                            dropdownValue = null;
                          });
                        },
                        value: dropdownValue1,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Please select the market type: ",
                        textScaleFactor: 1.2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        items: state
                            .marketDataList[state.selectedIndex].values.first
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value.marketTypeName,
                            child: Text(value.marketTypeName),
                          );
                        }).toList(),
                        hint: Text("Select Market Type"),
                        onChanged: (newValue) {
                          MarketTypeData marketTypeData;
                          for (var marketType in state
                              .marketDataList[state.selectedIndex].values) {
                            for (var market in marketType) {
                              if (market.marketTypeName == newValue)
                                marketTypeData = market;
                            }
                          }
                          BlocProvider.of<ManagemarketBloc>(context)
                              .add(SetSelectedData(marketTypeData));
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        value: dropdownValue,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (state.selectedData != null)
                    Text(
                      "Update Call Type",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 12,
                    ),
                  if (state.selectedData != null)
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text("Buy"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTypeBuy,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedTypeBuy = true;
                                    checkedTypeClosed = false;
                                    checkedTypeSell = false;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text("Sell"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTypeSell,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedTypeSell = true;
                                    checkedTypeBuy = false;
                                    checkedTypeClosed = false;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text("Closed"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTypeClosed,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedTypeClosed = true;
                                    checkedTypeBuy = false;
                                    checkedTypeSell = false;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 20,
                    ),
                  if (state.selectedData != null)
                    Text(
                      "Update Targets",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 12,
                    ),
                  if (state.selectedData != null)
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text("Target 1"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTarget1,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedTarget1 = newValue;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          child: Row(
                            children: [
                              Text("Target 2"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTarget2,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedTarget2 = newValue;
                                    checkedTarget1 = true;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          child: Row(
                            children: [
                              Text("Target 3"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTarget3,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedTarget3 = newValue;
                                    checkedTarget2 = true;
                                    checkedTarget1 = true;
                                    checkedTypeClosed = true;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          child: Row(
                            children: [
                              Text("Stop Loss"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedStopLoss,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedStopLoss = newValue;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 20,
                    ),
                  if (state.selectedData != null)
                    Text(
                      "Set Initial data",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (state.selectedData != null)
                    Row(
                      children: [
                        Row(children: [
                          Text("Entry Rate:"),
                          textField(
                            "",
                            editingControllerEntryRate,
                          )
                        ]),
                      ],
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 20,
                    ),
                  if (state.selectedData != null)
                    Text(
                      "Set Targets",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (state.selectedData != null)
                    Row(
                      children: [
                        Row(
                          children: [
                            Text("Target 1:"),
                            textField(
                              "",
                              editingControllerTarget1,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Target 2:"),
                            textField(
                              "",
                              editingControllerTarget2,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Target 3:"),
                            textField(
                              "",
                              editingControllerTarget3,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Stop Loss:"),
                            textField(
                              "",
                              editingControllerStopLoss,
                            )
                          ],
                        ),
                      ],
                    ),
                  if (state.selectedData != null)
                    Container(
                      width: size.width * 0.35,
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: size.width * 0.10,
                            child: RaisedButton.icon(
                              onPressed: () {
                                MarketTypeData marketTypeData =
                                    MarketTypeData();
                                marketTypeData.companyID =
                                    state.selectedData.companyID;
                                marketTypeData.marketTypeId =
                                    state.selectedData.marketTypeId;
                                marketTypeData.marketTypeName =
                                    state.selectedData.marketTypeName;
                                marketTypeData.docId = state.selectedData.docId;
                                marketTypeData.isNew = false;
                                if (checkedTypeBuy) marketTypeData.callType = 0;
                                if (checkedTypeSell)
                                  marketTypeData.callType = 1;
                                if (checkedTypeClosed)
                                  marketTypeData.callType = 2;
                                marketTypeData.targetList = List();
                                marketTypeData.targetList.add({
                                  "isAchieved": checkedTarget1,
                                  "value": double.parse(
                                      editingControllerTarget1.text),
                                  "name": "Target 1"
                                });
                                marketTypeData.targetList.add({
                                  "isAchieved": checkedTarget2,
                                  "value": double.parse(
                                      editingControllerTarget2.text),
                                  "name": "Target 2"
                                });
                                marketTypeData.targetList.add({
                                  "isAchieved": checkedTarget3,
                                  "value": double.parse(
                                      editingControllerTarget3.text),
                                  "name": "Target 3"
                                });
                                marketTypeData.targetList.add({
                                  "isAchieved": checkedStopLoss,
                                  "value": double.parse(
                                      editingControllerStopLoss.text),
                                  "name": "Stop Loss"
                                });
                                marketTypeData.entryRate = double.parse(
                                    editingControllerEntryRate.text);
                                BlocProvider.of<ManagemarketBloc>(context).add(
                                    UpdateManageData(marketTypeData,
                                        marketTypeName: dropdownValue));
                              },
                              icon: Icon(
                                Icons.update,
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
                            width: size.width * 0.10,
                            child: RaisedButton.icon(
                              onPressed: () {
                                BlocProvider.of<ManagemarketBloc>(context)
                                    .add(ResetMarketData());
                              },
                              icon: Icon(
                                Icons.restore_page,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Reset",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          );
        } else if (state is ManagemarketResetState) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Please select company name: ",
                        textScaleFactor: 1.2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        items: state.marketDataList
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value.keys.first,
                            child: Text(value.keys.first),
                          );
                        }).toList(),
                        hint: Text("Select Company"),
                        onChanged: (newValue) {
                          BlocProvider.of<ManagemarketBloc>(context).add(
                              ChangeSelectedIndex(state.marketDataList
                                  .indexWhere((element) =>
                                      element.keys.first == newValue)));
                          setState(() {
                            dropdownValue1 = newValue;

                            dropdownValue = null;
                          });
                        },
                        value: dropdownValue1,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Please select the market type: ",
                        textScaleFactor: 1.2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        items: state
                            .marketDataList[state.selectedIndex].values.first
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value.marketTypeName,
                            child: Text(value.marketTypeName),
                          );
                        }).toList(),
                        hint: Text("Select Market Type"),
                        onChanged: (newValue) {
                          BlocProvider.of<ManagemarketBloc>(context).add(
                              SetSelectedData(state
                                  .marketDataList[state.selectedIndex].values
                                  .where((element) =>
                                      element
                                          .where((element) =>
                                              element.marketTypeName ==
                                              newValue)
                                          .toList()
                                          .first !=
                                      null)
                                  .toList()
                                  .first
                                  .first));
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        value: dropdownValue,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (state.selectedData != null)
                    Text(
                      "Update Call Type",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 12,
                    ),
                  if (state.selectedData != null)
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text("Buy"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTypeBuy,
                                onChanged: (newValue) {
                                  state.selectedData.callType = 0;
                                  BlocProvider.of<ManagemarketBloc>(context)
                                      .add(RefreshMarketData(
                                          state.selectedData));
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text("Sell"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTypeSell,
                                onChanged: (newValue) {
                                  state.selectedData.callType = 1;
                                  BlocProvider.of<ManagemarketBloc>(context)
                                      .add(RefreshMarketData(
                                          state.selectedData));
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Text("Closed"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTypeClosed,
                                onChanged: (newValue) {
                                  state.selectedData.callType = 2;
                                  BlocProvider.of<ManagemarketBloc>(context)
                                      .add(RefreshMarketData(
                                          state.selectedData));
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 20,
                    ),
                  if (state.selectedData != null)
                    Text(
                      "Update Targets",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 12,
                    ),
                  if (state.selectedData != null)
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text("Target 1"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTarget1,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedTarget1 = newValue;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          child: Row(
                            children: [
                              Text("Target 2"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTarget2,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedTarget2 = newValue;
                                    checkedTarget1 = newValue;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          child: Row(
                            children: [
                              Text("Target 3"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedTarget3,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedTarget3 = newValue;
                                    checkedTarget1 = newValue;
                                    checkedTarget2 = newValue;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          child: Row(
                            children: [
                              Text("Stop Loss"),
                              SizedBox(width: 5.5),
                              Checkbox(
                                value: checkedStopLoss,
                                onChanged: (newValue) {
                                  setState(() {
                                    checkedStopLoss = newValue;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 20,
                    ),
                  if (state.selectedData != null)
                    Text(
                      "Set Initial data",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (state.selectedData != null)
                    Row(
                      children: [
                        Row(children: [
                          Text("Entry Rate:"),
                          textField(
                            "",
                            editingControllerEntryRate,
                          )
                        ]),
                      ],
                    ),
                  if (state.selectedData != null)
                    SizedBox(
                      height: 20,
                    ),
                  if (state.selectedData != null)
                    Text(
                      "Set Targets",
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (state.selectedData != null)
                    Row(
                      children: [
                        Row(
                          children: [
                            Text("Target 1:"),
                            textField(
                              "",
                              editingControllerTarget1,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Target 2:"),
                            textField(
                              "",
                              editingControllerTarget2,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Target 3:"),
                            textField(
                              "",
                              editingControllerTarget3,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Stop Loss:"),
                            textField(
                              "",
                              editingControllerStopLoss,
                            )
                          ],
                        ),
                      ],
                    ),
                  if (state.selectedData != null)
                    Container(
                      width: size.width * 0.35,
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: size.width * 0.10,
                            child: RaisedButton.icon(
                              onPressed: () {
                                MarketTypeData marketTypeData =
                                    MarketTypeData();
                                marketTypeData.companyID =
                                    state.selectedData.companyID;
                                marketTypeData.marketTypeId =
                                    state.selectedData.marketTypeId;
                                marketTypeData.docId = state.selectedData.docId;
                                if (checkedTypeBuy) marketTypeData.callType = 0;
                                if (checkedTypeSell)
                                  marketTypeData.callType = 1;
                                if (checkedTypeClosed)
                                  marketTypeData.callType = 2;
                                marketTypeData.targetList = List();
                                marketTypeData.targetList.add({
                                  "isAchieved": checkedTarget1,
                                  "value": double.parse(
                                      editingControllerTarget1.text),
                                  "name": "Target 1"
                                });
                                marketTypeData.targetList.add({
                                  "isAchieved": checkedTarget2,
                                  "value": double.parse(
                                      editingControllerTarget2.text),
                                  "name": "Target 2"
                                });
                                marketTypeData.targetList.add({
                                  "isAchieved": checkedTarget3,
                                  "value": double.parse(
                                      editingControllerTarget3.text),
                                  "name": "Target 3"
                                });
                                marketTypeData.targetList.add({
                                  "isAchieved": checkedStopLoss,
                                  "value": double.parse(
                                      editingControllerStopLoss.text),
                                  "name": "Stop Loss"
                                });
                                marketTypeData.entryRate = double.parse(
                                    editingControllerEntryRate.text);
                                BlocProvider.of<ManagemarketBloc>(context)
                                    .add(UpdateManageData(marketTypeData));
                              },
                              icon: Icon(
                                Icons.update,
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
                            width: size.width * 0.10,
                            child: RaisedButton.icon(
                              onPressed: () {
                                BlocProvider.of<ManagemarketBloc>(context)
                                    .add(ResetMarketData());
                              },
                              icon: Icon(
                                Icons.restore_page,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Reset",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
            ColorValues.blue,
          )),
        );
      },
    ));
  }
}
