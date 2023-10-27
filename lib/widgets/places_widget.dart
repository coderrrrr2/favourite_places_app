import 'package:favourite_places_app/models/place.dart';
import 'package:favourite_places_app/providers/index_setter.dart';
import 'package:favourite_places_app/providers/main_provider.dart';
import 'package:favourite_places_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserPlaces extends ConsumerWidget {
  const UserPlaces({super.key, required this.text});
  final List<Place> text;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget currentBody = ListView.builder(
      itemCount: text.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(text[index].id),
          child: ListTile(
            onTap: () {
              ref.watch(indexProvider.notifier).setIndex(index);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DetailsScreen()));
            },
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: FileImage(text[index].image),
            ),
            title: Text(
              text[index].title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          onDismissed: (direction) {
            var currentItem = text[index];
            ref.watch(listProvider.notifier).remove(text[index]);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Item removed from List"),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    ref
                        .watch(listProvider.notifier)
                        .add(currentItem.title, currentItem.image);
                  },
                ),
              ),
            );
          },
        );
      },
    );
    if (text.isEmpty) {
      currentBody = Center(
        child: Text(
          "No Places added yet",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white, fontSize: 20),
        ),
      );
    }
    return currentBody;
  }
}
