class IndustryModel {
  String branch;
  String branchKey;
  List<String> trade;

  IndustryModel({this.branch, this.branchKey, this.trade});

  IndustryModel.fromJson(Map<String, dynamic> json) {
    branch = json['branch'];
    branchKey = json['key'];
    trade = json['trade'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch'] = this.branch;
    data['key'] = this.branchKey;
    data['trade'] = this.trade;
    return data;
  }
}
