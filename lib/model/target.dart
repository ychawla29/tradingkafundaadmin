part of model;

class Target {
  String _targetName;
  double _targetValue;
  bool _isAchieved;

  String getTargetName() {
    return this._targetName;
  }

  double getTargetValue() {
    return this._targetValue;
  }

  bool getAchieved() {
    return this._isAchieved;
  }

  void setTargetName(String targetName) {
    this._targetName = targetName;
  }

  void setTargetValue(double targetValue) {
    this._targetValue = targetValue;
  }

  void setAchieved(bool isAchieved) {
    this._isAchieved = isAchieved;
  }
}
