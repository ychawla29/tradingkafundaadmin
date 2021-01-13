part of model;

class Comment {
  String comment;
  DateTime dateTime;

  String getCommand() {
    return comment;
  }

  void setCommand(String comment) {
    this.comment = comment;
  }

  DateTime getDateTime() {
    return dateTime;
  }

  void setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
  }

  Comment(this.comment, this.dateTime);
}