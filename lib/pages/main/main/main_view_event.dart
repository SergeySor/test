import 'package:equatable/equatable.dart';

abstract class MainViewEvent extends Equatable {
  const MainViewEvent();

  @override
  List<Object?> get props => [];
}

class MainSearchFieldChanged extends MainViewEvent {
  final String text;

  MainSearchFieldChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

class MainPageOpened extends MainViewEvent {
  MainPageOpened();
}
