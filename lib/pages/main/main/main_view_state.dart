import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

class MainViewState extends Equatable {
  final List<FileInfo> filtredFiles;
  final List<MediaInfo> filtredMedia;

  final List<FileInfo> recesntFiles;

  final FormzStatus status;

  final bool hasPremium;
  final bool isDownloading;
  final bool isUploading;
  final bool isSearching;

  MainViewState({
    this.filtredFiles = const [],
    this.filtredMedia = const [],
    this.recesntFiles = const [],
    this.status = FormzStatus.pure,
    this.hasPremium = false,
    this.isDownloading = false,
    this.isUploading = false,
    this.isSearching = false,
  });

  MainViewState copyWith({
    List<FileInfo>? filtredFiles,
    List<MediaInfo>? filtredMedia,
    List<FileInfo>? recesntFiles,
    FormzStatus? status,
    bool? hasPremium,
    bool? isDownloading,
    bool? isUploading,
    bool? isSearching,
  }) {
    return MainViewState(
      filtredFiles: filtredFiles ?? this.filtredFiles,
      filtredMedia: filtredMedia ?? this.filtredMedia,
      recesntFiles: recesntFiles ?? this.recesntFiles,
      status: status ?? this.status,
      hasPremium: hasPremium ?? this.hasPremium,
      isDownloading: isDownloading ?? this.isDownloading,
      isUploading: isUploading ?? this.isUploading,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
        filtredFiles,
        filtredMedia,
        recesntFiles,
        status,
        hasPremium,
        isDownloading,
        isUploading,
        isSearching,
      ];
}
