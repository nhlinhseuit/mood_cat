import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_cat/core/config/service_locator.dart';


/// Base config for StatefulWidget
///
///
/// Example use:
/// ```dart
/// class AppPage extends StatefulWidget {
///   const AppPage({super.key});
///
///   @override
///   State<AppPage> createState() => _AppPageState();
/// }
///
/// class _AppPageState extends BasePageState<AppPage, AppBloc> {
///   @override
///   Widget buildPage(BuildContext context) {
///     return PageWidget();
///   }
/// }
/// ```
abstract class BasePageState<W extends StatefulWidget,
    B extends Bloc<dynamic, dynamic>> extends BasePageStateDelegate<W, B> {}

/// Delegate of [BasePageState]
abstract class BasePageStateDelegate<W extends StatefulWidget,
    B extends Bloc<dynamic, dynamic>> extends State<W> {
  /// This is Bloc get from GetIt
  final B bloc = getIt<B>();

  @override
  Widget build(BuildContext context) {
    return buildProvider(context);
  }

  @protected
  Widget buildProvider(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<B>(create: (_) => bloc),
      ],
      child: buildPage(context),
    );
  }

  /// Build widget of page
  Widget buildPage(BuildContext context);
}
