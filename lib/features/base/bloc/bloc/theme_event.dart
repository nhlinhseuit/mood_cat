part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

final class LoadTheme extends ThemeEvent {
  const LoadTheme();
}

final class ChangeTheme extends ThemeEvent {
  const ChangeTheme({required this.themeMode});

  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
}
