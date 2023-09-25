import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndexSetter extends StateNotifier<int> {
  IndexSetter() : super(0);
  WidgetRef? ref;

  void setIndex(int newIndex) {
    state = newIndex;
  }
}

final indexProvider = StateNotifierProvider<IndexSetter, int>((ref) {
  return IndexSetter();
});
