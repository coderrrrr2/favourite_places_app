import 'dart:io';

import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Place {
  String id;

  Place({required this.name, required this.image}) : id = const Uuid().v4();
  final String name;
  final File image;
}
