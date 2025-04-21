import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_mood_list_event.dart';
part 'get_mood_list_state.dart';

class GetMoodListBloc extends Bloc<GetMoodListEvent, GetMoodListState> {
  GetMoodListBloc() : super(GetMoodListInitial()) {
    on<GetMoodListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
