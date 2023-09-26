// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:favourite_places_app/providers/main_provider.dart';
import 'package:favourite_places_app/widgets/images_input.dart';
import 'package:favourite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItem extends ConsumerWidget {
  AddItem({super.key});
  String enteredText = "";

  File? selectedImage;

  void addItem(BuildContext context, String enteredtext, WidgetRef ref) {
    if (enteredtext.isEmpty || selectedImage == null) {
      return;
    }
    ref.read(listProvider.notifier).add(enteredtext, selectedImage!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Widget build method remains the same
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                enteredText = value;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            ImageInput(
              addImage: (image) {
                selectedImage = image;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const LocationInput(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                addItem(context, enteredText, ref);
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Place"),
            )
          ],
        ),
      ),
    );
  }
}
