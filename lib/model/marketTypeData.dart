part of model;

class MarketTypeData {
  String _marketTypeName;
  String _marketTypeId;
  List<dynamic> _targetList;
  List<dynamic> _commentList;
  int _callType;
  String _companyID;
  double _entryRate;
  DateTime _updatedOn;
  bool _isNew;
  String _docId;

  // ignore: unnecessary_getters_setters
  String get docId => _docId;

  // ignore: unnecessary_getters_setters
  set docId(String value) => _docId = value;

  // ignore: unnecessary_getters_setters
  bool get isNew => _isNew;

  // ignore: unnecessary_getters_setters
  set isNew(bool value) => _isNew = value;

  // ignore: unnecessary_getters_setters
  String get marketTypeName => _marketTypeName;

  // ignore: unnecessary_getters_setters
  set marketTypeName(String value) => _marketTypeName = value;

  // ignore: unnecessary_getters_setters
  String get marketTypeId => _marketTypeId;

  // ignore: unnecessary_getters_setters
  set marketTypeId(String value) => _marketTypeId = value;

  List get targetList => _targetList;

  set targetList(List value) => _targetList = value;

  List get commentList => _commentList;

  set commentList(List value) => _commentList = value;

  // ignore: unnecessary_getters_setters
  int get callType => _callType;

  // ignore: unnecessary_getters_setters
  set callType(int value) => _callType = value;

  // ignore: unnecessary_getters_setters
  String get companyID => _companyID;

  // ignore: unnecessary_getters_setters
  set companyID(String value) => _companyID = value;

  // ignore: unnecessary_getters_setters

  
  double get entryRate => _entryRate;

  // ignore: unnecessary_getters_setters
  set entryRate(double value) => _entryRate = value;

  DateTime get updatedOn => _updatedOn;

  set updatedOn(DateTime value) => _updatedOn;
}
