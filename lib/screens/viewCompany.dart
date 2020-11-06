import 'dart:math';

import 'package:flutter/material.dart';

Map<String, String> modelData = {
  "BANKBARODA": "Bank Of Baroda",
  "BAJFINANCE": "BAJAJ FINANCE",
  "MUTHOOTFIN": "MUTHOOT FINANCE"
};

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(modelData.keys.toList()[index].substring(0, 1)),
                  backgroundColor: getRandomColor(),
                ),
                title: Text(modelData.values.toList()[index]),
              );
            },
            itemCount: modelData.length,
          ),
        ],
      ),
    );
  }
}
