import 'dart:io';

import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Place {
  String id;

  Place({required this.title, required this.image, id})
      : id = id ?? const Uuid().v4();
  final String title;
  final File image;
}
