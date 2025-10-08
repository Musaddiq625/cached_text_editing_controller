import 'package:cached_text_editing_controller/src/tracker/text_modification_tracker.dart';
import 'package:flutter/widgets.dart';

/// A specialized TextEditingController that efficiently tracks text modifications
///
/// Implements [TextModifiable] to ensure a clear contract for modification tracking.
class CachedTextEditingController extends TextEditingController {
  late final TextModificationTracker _modificationTracker;

  /// Creates a [CachedTextEditingController] with optional initial text.
  ///
  /// If [text] is not provided, defaults to an empty string.
  CachedTextEditingController({super.text = ''}) {
    _modificationTracker = TextModificationTracker(
      text,
      getCurrentText: () => text,
    );
  }

  @override
  set text(String newText) {
    if (newText != text) {
      super.text = newText;
    }
  }

  /// Returns `true` if the current text differs from the original text.
  bool get isTextModified => _modificationTracker.isTextModified;
}
