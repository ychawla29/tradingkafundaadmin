import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  String dropdownValue = "Not-Selected";
  String dropdownValue1 = "Not-Selected";

  bool checkedTarget1 = false;
  bool checkedTarget2 = false;
  bool checkedTarget3 = false;
  bool checkedStopLoss = false;

  bool checkedTypeBuy = true;
  bool checkedTypeSell = false;
  bool checkedTypeClosed = false;

  TextEditingController editingControllerTarget1 = TextEditingController();
  TextEditingController editingControllerTarget2 = TextEditingController();
  TextEditingController editingControllerTarget3 = TextEditingController();
  TextEditingController editingControllerStopLoss = TextEditingController();

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

    Widget addButtonRow() => Container(
          width: size.width * 0.35,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: size.width * 0.10,
                child: RaisedButton.icon(
                  onPressed: () {
                    Toast.show('Update Clicked', context,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        gravity: Toast.BOTTOM,
                        duration: Toast.LENGTH_SHORT);
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
                    Toast.show('Reset Clicked', context,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        gravity: Toast.BOTTOM,
                        duration: Toast.LENGTH_SHORT);
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
      child: Container(
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
                    "Please company name: ",
                    textScaleFactor: 1.2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    items: <String>[
                      "Not-Selected",
                      "Bank of Baroda",
                      "Muthoot Finance",
                      "Bajaj Finserv"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue1 = newValue;
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
                    items: <String>[
                      "Not-Selected",
                      "Equity",
                      "Futures",
                      "Options",
                      "Commodity",
                      "Forex"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
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
              Text(
                "Update Call Type",
                textScaleFactor: 1.2,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                              checkedTypeBuy = newValue;
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
                              checkedTypeSell = newValue;
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
                              checkedTypeClosed = newValue;
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
              SizedBox(
                height: 20,
              ),
              Text(
                "Update Targets",
                textScaleFactor: 1.2,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12,
              ),
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
              SizedBox(
                height: 20,
              ),
              Text(
                "Set Targets",
                textScaleFactor: 1.2,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
              addButtonRow()
            ],
          ),
        ),
      ),
    );
  }
}
