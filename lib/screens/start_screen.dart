import 'package:favourite_places_app/providers/index_setter.dart';
import 'package:favourite_places_app/providers/main_provider.dart';
import 'package:favourite_places_app/screens/add_item_sceen.dart';
import 'package:favourite_places_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  void moveToAddItem(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        var text = ref.watch(listProvider);
        Widget currentBody = ListView.builder(
          itemCount: text.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(text[index].id),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    text[index].name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
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
                        ref.watch(listProvider.notifier).add(currentItem);
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
                  .copyWith(color: Colors.white),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Your Places"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  moveToAddItem(context);
                },
              )
            ],
          ),
          body: currentBody,
        );
      },
    );
  }
}
