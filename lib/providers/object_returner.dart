import 'package:favourite_places_app/models/place.dart';
import 'package:favourite_places_app/providers/index_setter.dart';
import 'package:favourite_places_app/providers/main_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getIndexProvider = Provider<Place>((ref) {
  int index = ref.watch(indexProvider);
  List<Place> list = ref.watch(listProvider);

  return list[index];
});
