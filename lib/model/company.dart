part of model;

class Company {
  String companyName;
  String shortName;

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
    return jsonData;
  }

  @override
  String toString() {
    return "{\"name\":$companyName, \"shortName\":$shortName}";
  }
}
