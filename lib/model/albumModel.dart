import 'package:photo_gallery_flutter/photo_gallery_flutter.dart';
import 'package:video_player/video_player.dart';

class AlbumModel {
  int? id;
  String? albumName;
  List<ImageAlbumModel>? albumImagesList;

  AlbumModel({this.albumName, this.albumImagesList, this.id});

  AlbumModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumName = json['albumName'];
    albumImagesList = (json['albumImagesList'] as List?)?.map((item) {
      if (item is Map<String, dynamic>) {
        return ImageAlbumModel.fromJson(item);
      } else if (item is ImageAlbumModel) {
        return item;
      }
      throw Exception("Invalid type in albumImagesList: $item");
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['albumName'] = this.albumName;
    data['albumImagesList'] = this.albumImagesList;
    return data;
  }
}

class ImageAlbumModel {
  int? id;
  String? imagePath;
  String? thumbnail;
  MediumType? mediumType;
  VideoPlayerController? videoPlayerController;
  int? duration;

  ImageAlbumModel(
      {this.id,
      this.imagePath,
      this.thumbnail,
      this.mediumType,
      this.videoPlayerController,
      this.duration});

  ImageAlbumModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagePath = json['imagePath'];
    thumbnail = json['thumbnail'];
    mediumType = jsonToMediumType(json['mediumType']);
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagePath'] = this.imagePath;
    data['thumbnail'] = this.thumbnail;
    data['mediumType'] = mediumTypeToJson(this.mediumType);
    data['duration'] = this.duration;
    return data;
  }
}
