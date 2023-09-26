import 'dart:io';

import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Place {
  Place({required this.title, required this.image, String? id})
      : id = id ?? const Uuid().v4();
  final String title;
  final String id;
  final File image;
}
