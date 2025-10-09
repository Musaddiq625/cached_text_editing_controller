# Cached Text Editing Controller

[![Pub](https://img.shields.io/pub/v/cached_text_editing_controller.svg)](https://pub.dev/packages/cached_text_editing_controller)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

A high-performance, drop-in replacement for Flutter's `TextEditingController` that efficiently tracks text modifications with minimal overhead.

## Features

- 🔄 **Drop-in Replacement**: Works anywhere you'd use a regular `TextEditingController`
- ⚡ **Optimized Performance**: Hash-based comparison with length optimization
- 📦 **Zero Dependencies**: Pure Dart implementation
- 🛡 **Null Safe**: Fully null-safe code
- 🧪 **Thoroughly Tested**: 100% test coverage
- 📱 **Platform Agnostic**: Works on all Flutter platforms

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  cached_text_editing_controller: <latest_version>
```

## Demo
![Demo animation](doc/demo.gif)

## Usage

### As a Direct Replacement

Simply replace your existing `TextEditingController` with `CachedTextEditingController`:

```dart
// Before
final textEditingController = TextEditingController(text: 'Hello');

// After - same API, but with modification tracking
final textEditingController = CachedTextEditingController(text: 'Hello');

// Check if text has been modified
if (textEditingController.isTextModified) {
  print('Text has changed!');
}
```

### With TextField/TextFormField

Works seamlessly with all Flutter form widgets:

```dart
TextField(
  controller: textEditingController,
  decoration: InputDecoration(labelText: 'Enter text'),
);
```

## Performance

- Performs quick length check before any content comparison
- Uses hash codes for fast inequality checking
- Falls back to exact string comparison only when necessary
- Maintains minimal internal state

## Practical Use Cases

### 1. Multi-Step Forms

Track changes across multiple form fields and enable/steppers or navigation only when changes exist:

```dart
// In your form state
final _nameController = CachedTextEditingController();
final _emailController = CachedTextEditingController();

// Check if any field is modified
bool get _isFormModified => 
    _nameController.isTextModified || 
    _emailController.isTextModified;

// In your stepper
Step(
  state: _isFormModified ? StepState.editing : StepState.complete,
  isActive: _currentStep >= 0,
  title: const Text('Personal Info'),
  content: Column(
    children: [
      TextField(controller: _nameController, /* ... */),
      TextField(controller: _emailController, /* ... */),
    ],
  ),
)
```

### 2. Edit/View Modes

Toggle between read-only and editable states while preserving original values:

```dart
class EditableText extends StatefulWidget {
  final String initialText;
  
  const EditableText({super.key, required this.initialText});

  @override
  _EditableTextState createState() => _EditableTextState();
}

class _EditableTextState extends State<EditableText> {
  late final _controller = CachedTextEditingController(text: widget.initialText);
  bool _isEditing = false;

  void _toggleEdit() {
    if (_isEditing && _controller.isTextModified) {
      _showSaveConfirmation();
    }
    setState(() => _isEditing = !_isEditing);
  }
  
  // ... rest of the implementation
}
```

### 3. Form Auto-Save

Implement auto-save functionality that only triggers on actual changes:

```dart
Timer? _debounce;

void _onTextChanged(String text) {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  
  _debounce = Timer(const Duration(seconds: 2), () {
    if (_controller.isTextModified) {
      _saveToBackend(_controller.text);
    }
  });
}
```

### 4. Bulk Edit Detection

Detect if any field in a collection of controllers has been modified:

```dart
class BulkEditForm extends StatefulWidget {
  final List<String> initialItems;
  
  const BulkEditForm({super.key, required this.initialItems});

  @override
  _BulkEditFormState createState() => _BulkEditFormState();
}

class _BulkEditFormState extends State<BulkEditForm> {
  late final List<CachedTextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.initialItems
        .map((text) => CachedTextEditingController(text: text))
        .toList();
  }

  bool get _hasChanges => _controllers.any((c) => c.isTextModified);

  // ... rest of the implementation
}
```

### 5. Undo/Reset Functionality

Implement reset to original values with a single call:

```dart
class ResettableForm extends StatefulWidget {
  final String initialValue;
  
  const ResettableForm({super.key, required this.initialValue});

  @override
  _ResettableFormState createState() => _ResettableFormState();
}

class _ResettableFormState extends State<ResettableForm> {
  late final _controller = CachedTextEditingController(text: widget.initialValue);

  void _resetToOriginal() {
    if (_controller.isTextModified) {
      _controller.text = widget.initialValue;
      // Controller will automatically update isTextModified
    }
  }
  
  // ... rest of the implementation
}
```

### 6. Real-time Collaboration

Show edit indicators in collaborative editing scenarios:

```dart
StreamBuilder<DocumentUpdate>(
  stream: _documentUpdates,
  builder: (context, snapshot) {
    if (snapshot.hasData && _controller.isTextModified) {
      return const Badge(
        label: Text('Unsaved Changes'),
        backgroundColor: Colors.orange,
      );
    }
    return const SizedBox.shrink();
  },
)
```

## Performance Considerations

`CachedTextEditingController` is optimized for all these scenarios with:
- Quick length-based pre-check
- Efficient hash comparison
- Minimal memory overhead
- No unnecessary rebuilds

### Key Benefits

- **Familiar API**: Drop-in replacement for `TextEditingController`
- **Performance Optimized**: Efficient modification tracking with minimal overhead
- **Battle-Tested**: Comprehensive test coverage for reliability

## Maintainer

Developed and maintained by [Musaddiq625](https://github.com/Musaddiq625)

## License

MIT License - See [LICENSE](LICENSE) for details.