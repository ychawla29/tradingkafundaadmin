class ViewCompanyModel {
  String companyName;

  String companyId;

  List<Map<String, String>> marketList;

  String marketsName;
  String get getCompanyName => this.companyName;

  set setCompanyName(String companyName) => this.companyName = companyName;

  String get getCompanyId => this.companyId;

  set setCompanyId(String companyId) => this.companyId = companyId;

  List<Map<String, String>> get getMarketList => this.marketList;

  set setMarketList(List<Map<String, String>> marketList) =>
      this.marketList = marketList;

  String get getMarketsName => this.marketsName;

  set setMarketsName(String marketsName) => this.marketsName = marketsName;
}
