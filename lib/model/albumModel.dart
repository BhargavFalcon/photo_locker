import 'package:flick_video_player/flick_video_player.dart';
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
    if (json['albumImagesList'] != null) {
      albumImagesList = <ImageAlbumModel>[];
      json['albumImagesList'].forEach((v) {
        albumImagesList!.add(new ImageAlbumModel.fromJson(v));
      });
    }
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
  FlickManager? flickManager;
  int? duration;

  ImageAlbumModel(
      {this.id,
      this.imagePath,
      this.thumbnail,
      this.mediumType,
      this.videoPlayerController,
      this.flickManager,
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
