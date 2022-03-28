class classTestimoni {
  String id;
  String username;
  String review;
  double rating;
  String status;

  classTestimoni(this.id, this.username, this.review, this.rating, this.status);

  bool getStatus() {
    if (this.status == "1") {
      return true;
    } else {
      return false;
    }
  }
}
