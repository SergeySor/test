import 'package:equatable/equatable.dart';

//ignore: must_be_immutable
class MediaInfo extends Equatable {
  MediaInfo({
    required this.createdDate,
    required this.id,
    required this.image,
    required this.lastOpened,
    required this.imagePreview,
    required this.location,
    required this.modifiedDate,
    required this.name,
    required this.size,
    required this.type,
    this.childs = const [],
    this.isFavorite = false,
    this.isChoosed = false,
  }) : deletedDate = DateTime(2021);

  MediaInfo.empty({
    DateTime? createdDate,
    this.id = '',
    this.image = '',
    DateTime? lastOpened,
    this.imagePreview = '',
    this.location = '',
    DateTime? modifiedDate,
    this.name = '',
    this.size = -1,
    this.type = MediaType.audio,
    this.childs = const [],
    this.isFavorite = false,
    this.isChoosed = false,
  })  : createdDate = createdDate ?? DateTime.now(),
        lastOpened = lastOpened ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now(),
        deletedDate = DateTime.now();

  final DateTime createdDate;
  final DateTime modifiedDate;
  final String id;
  String name;
  final String imagePreview;
  final String image;
  final double size;
  final String location;
  final DateTime lastOpened;
  final List<MediaInfo> childs;
  final MediaType type;
  bool isFavorite;
  final DateTime deletedDate;
  bool isChoosed;

  @override
  List<Object?> get props => [
        createdDate,
        modifiedDate,
        name,
        image,
        imagePreview,
        size,
        location,
        lastOpened,
        type,
        childs,
        isFavorite,
        id,
        isChoosed,
      ];
}

enum MediaType { picture, video, audio, folder }
