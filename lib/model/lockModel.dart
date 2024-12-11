class LockModel {
  String? lockType;
  List<String>? lockValue;
  int? lockDigits;

  LockModel({this.lockType, this.lockValue, this.lockDigits});

  LockModel.fromJson(Map<String, dynamic> json) {
    lockType = json['lockType'];
    lockValue = json['lockValue'].cast<String>();
    lockDigits = json['lockDigits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lockType'] = this.lockType;
    data['lockValue'] = this.lockValue;
    data['lockDigits'] = this.lockDigits;
    return data;
  }
}
