import 'package:flutter/material.dart';
import 'package:tradingkafundaadmin/screens/addCompany.dart';
import 'package:tradingkafundaadmin/screens/manageMarketData.dart';
import 'package:tradingkafundaadmin/screens/viewCompany.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Trading Ka Funda Admin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Widget selectionWidget = ManageScreen();
  String title = "Trading Ka Funda Admin / Manage Market Data";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget menuGroupTitle(String title) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(
                    color: Colors.white,
                    indent: 2.0,
                  ),
                ),
              ],
            ),
          ),
        );

    Widget menuBarComponent(IconData icon, String title, bool isSelected,
            VoidCallback onClick) =>
        Container(
          color: isSelected ? Colors.blue.shade700 : Colors.transparent,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClick,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 15.0, top: 5.0, bottom: 5.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

    Widget sideMenuBar = Container(
      color: Colors.blue,
      width: size.width * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          menuGroupTitle("Market"),
          menuBarComponent(
              Icons.view_compact_rounded, "Manage Market Data", false, () {
            setState(() {
              selectionWidget = ManageScreen();
              title = "${widget.title} / Manage Market Data";
            });
          }),
          menuGroupTitle("Company"),
          menuBarComponent(Icons.add_business, "Add Company", false, () {
            setState(() {
              selectionWidget = AddCompany();
              title = "${widget.title} / Add Company";
            });
          }),
          menuBarComponent(Icons.view_compact_rounded, "View Companies", false,
              () {
            setState(() {
              selectionWidget = ViewCompany();
              title = "${widget.title} / View Companies";
            });
          }),
        ],
      ),
    );

    Widget mainComponent = Container(
      color: Colors.white,
      width: size.width * 0.80,
      child: selectionWidget,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [sideMenuBar, mainComponent],
        ),
      ),
    );
  }
}
