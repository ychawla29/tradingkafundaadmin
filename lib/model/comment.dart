part of model;

class Comment {
  String comment;
  String dateTime;

  String getCommand() {
    return comment;
  }

  void setCommand(String comment) {
    this.comment = comment;
  }

  String getDateTime() {
    return dateTime;
  }

  void setDateTime(String dateTime) {
    this.dateTime = dateTime;
  }

  Comment(this.comment, this.dateTime);

  Map<String, dynamic> toMap() {
    return {"comment": comment, "time": dateTime};
  }
}
