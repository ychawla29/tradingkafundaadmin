import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:tradingkafundaadmin/model/model.dart';
import 'package:tradingkafundaadmin/operations/addCompanyData.dart';

class AddCompany extends StatefulWidget {
  @override
  _AddCompanyState createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  var _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var shortNameController = TextEditingController();
  bool equity = true;
  bool future = false;
  bool option = false;
  bool commodity = false;
  bool forex = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget textField(String title, TextEditingController _controller) =>
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            width: size.width * 0.35,
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: title,
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(width: 0.5, color: Colors.blue)),
                errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(width: 0.5, color: Colors.blue)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(width: 0.5, color: Colors.blue)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(width: 0.5)),
              ),
              validator: (value) {
                if (value.isEmpty) return "This field cannot be empty";
                return null;
              },
            ),
          ),
        );

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

    Widget addButtonRow() => Container(
          width: size.width * 0.35,
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: size.width * 0.10,
                child: RaisedButton.icon(
                  onPressed: () {
                    Toast.show('Save Clicked', context,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        gravity: Toast.BOTTOM,
                        duration: Toast.LENGTH_SHORT);
                    if (_formKey.currentState.validate()) {
                      Company company = Company();
                      company.setCompanyName(nameController.text);
                      company.setShortName(shortNameController.text);
                      AddData.addCompanyData(company);
                    }
                  },
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Save",
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

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              textField("Company name", nameController),
              textField("Short name for company", shortNameController),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Please select the market type",
                  textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              buildCheckBox("Equity", equity, (value) {
                setState(() {
                  equity = value;
                });
              }),
              buildCheckBox("Future", future, (value) {
                setState(() {
                  future = value;
                });
              }),
              buildCheckBox("Options", option, (value) {
                setState(() {
                  option = value;
                });
              }),
              buildCheckBox("Commodity", commodity, (value) {
                setState(() {
                  commodity = value;
                });
              }),
              buildCheckBox("Forex", forex, (value) {
                setState(() {
                  forex = value;
                });
              }),
              addButtonRow(),
            ],
          ),
        ),
      ),
    );
  }

  showLoading() {}
}
