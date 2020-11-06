part of model;

class CompanyData {
  String _companyName;
  List<MarketTypeData> _marketTypeDataList;

  String getCompanyName() {
    return this._companyName;
  }

  void setCompanyName(String companyName) {
    this._companyName = companyName;
  }
}
