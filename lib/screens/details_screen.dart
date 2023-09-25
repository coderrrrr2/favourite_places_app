import 'package:favourite_places_app/providers/object_returner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentItem = ref.watch(getIndexProvider);
    return Consumer(builder: (context, ref, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text(currentItem.name),
          ),
          body: Stack(
            children: [
              Image.file(
                currentItem.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            ],
          ));
    });
  }
}
