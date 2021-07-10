part of model;

class Company {
  String companyName;
  String shortName;
  String companyId;
  List<dynamic> marketsList;

  String get getCompanyId => this.companyId;

  set setCompanyId(String companyId) => this.companyId = companyId;

  List get getMarketsList => marketsList;

  set setMarketsList(List<dynamic> marketsList) =>
      this.marketsList = marketsList;

  String getCompanyName() {
    return companyName;
  }

  String getShortName() {
    return shortName;
  }

  void setCompanyName(String companyName) {
    this.companyName = companyName;
  }

  void setShortName(String shortName) {
    this.shortName = shortName;
  }

  static Map<String, dynamic> getCompanyJson(Company company) {
    Map<String, dynamic> jsonData = Map();
    jsonData.putIfAbsent("name", () => company.getCompanyName());
    jsonData.putIfAbsent("shortName", () => company.getShortName());
    jsonData.putIfAbsent("markets", () => company.getMarketsList);
    return jsonData;
  }

  @override
  String toString() {
    return "{\"name\":$companyName, \"shortName\":$shortName}";
  }
}
