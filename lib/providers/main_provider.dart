import 'package:favourite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListManipulator extends StateNotifier<List<Place>> {
  ListManipulator() : super(const []);
  WidgetRef? ref;

  void add(Place item) {
    state = [...state, item];
  }

  void remove(Place item) {
    state = state.where((element) => element != item).toList();
  }
}

final listProvider = StateNotifierProvider<ListManipulator, List<Place>>((ref) {
  return ListManipulator();
});
