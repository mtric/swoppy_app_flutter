class IndustryModel {
  String mainIndustry;
  String wzKey;
  List<String> industry;

  IndustryModel({this.mainIndustry, this.wzKey, this.industry});

  IndustryModel.fromJson(Map<String, dynamic> json) {
    mainIndustry = json['branch'];
    wzKey = json['key'];
    industry = json['trade'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch'] = this.mainIndustry;
    data['key'] = this.wzKey;
    data['trade'] = this.industry;
    return data;
  }
}
