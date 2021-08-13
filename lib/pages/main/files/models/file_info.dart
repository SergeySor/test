import 'package:equatable/equatable.dart';

class FileInfo extends Equatable {
  final String image;
  final String name;
  final String date;
  final FileType type;
  final int size; // in bytes
  bool isChoosed;

  // FileInfo(
  //     {required this.name,
  //     required this.date,
  //     required this.image,
  //     required this.type,
  //     required this.size});

  FileInfo({
    this.name = '',
    this.date = '',
    this.image = '',
    this.size = 0,
    this.type = FileType.txt,
    this.isChoosed = false,
  });

  FileInfo copyWith({
    String? image,
    String? name,
    String? date,
    FileType? type,
    int? size,
    bool? isChoosed,
  }) {
    return FileInfo(
      name: name ?? this.name,
      date: date ?? this.date,
      image: image ?? this.image,
      type: type ?? this.type,
      size: size ?? this.size,
      isChoosed: isChoosed ?? this.isChoosed,
    );
  }

  @override
  List<Object?> get props => [image, name, date, type, isChoosed];
}

enum FileType { doc, image, txt, png, folder }
