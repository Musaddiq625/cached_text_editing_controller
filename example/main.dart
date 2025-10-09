import 'package:cached_text_editing_controller/cached_text_editing_controller.dart';
import 'package:flutter/material.dart';

void main() => runApp(ExampleScreen());

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final textController = CachedTextEditingController(
    text: 'This is the initial text',
  );

  // ValueNotifier is used to notify listeners (the UI) when the
  // `isTextModified` state changes.
  // This is necessary because `isTextModified` itself is just a getter
  // and does NOT notify Flutter when its value changes.
  // Without this notifier, the UI will NOT rebuild automatically.
  final isTextModified = ValueNotifier(false);

  @override
  void initState() {
    // This triggers UI rebuilds in any ValueListenableBuilder listening to it.
    textController.addListener(() {
      isTextModified.value = textController.isTextModified;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                'Editing a form',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ValueListenableBuilder(
                valueListenable: isTextModified,
                builder: (context, value, child) {
                  return Text('isTextModified -> $value');
                },
              ),
              TextFormField(controller: textController),
              ValueListenableBuilder(
                valueListenable: isTextModified,
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: !value ? null : () {},
                    child: const Text('Update'),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
