import 'package:favourite_places_app/providers/main_provider.dart';
import 'package:favourite_places_app/screens/add_item_sceen.dart';
import 'package:favourite_places_app/widgets/places_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen> {
  late Future<void> placesFuture;

  void moveToAddItem(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddItem()));
  }

  @override
  void initState() {
    super.initState();
    placesFuture = ref.read(listProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final text = ref.watch(listProvider);

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: placesFuture,
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : UserPlaces(
                      text: text,
                    );
            }),
      ),
    );
  }
}
