class AlbumModel {
  int? id;
  String? albumName;
  List<String>? albumImagesList;

  AlbumModel({this.albumName, this.albumImagesList, this.id});

  AlbumModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumName = json['albumName'];
    albumImagesList = json['albumImagesList'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['albumName'] = this.albumName;
    data['albumImagesList'] = this.albumImagesList;
    return data;
  }
}
