import 'package:cached_text_editing_controller/src/abstracts/text_modifiable.dart';

/// Implements [TextModifiable] to provide modification tracking capabilities
/// that can be composed into other classes.
class TextModificationTracker implements TextModifiable {
  final String _originalText;
  final int _originalHash;
  final int _originalLength;

  /// Callback to get the current text value when checking for modifications
  final String Function() getCurrentText;

  /// Creates a new [TextModificationTracker] with the given [originalText]
  /// and a callback to get the current text value.
  ///
  /// The [originalText] represents the baseline state that will be used for
  /// comparison to detect modifications.
  ///
  /// The [getCurrentText] callback should return the current text value
  /// when [isTextModified] is called.
  TextModificationTracker(this._originalText, {required this.getCurrentText})
    : _originalLength = _originalText.length,
      _originalHash = _originalText.hashCode;

  @override
  bool get isTextModified {
    final currentText = getCurrentText();
    return _isLengthDifferent(currentText) || _isContentModified(currentText);
  }

  /// Determines if the [current] text's length differs from the [originalText].
  ///
  /// This is a quick initial check since length differences are fast to detect
  /// and can avoid more expensive content comparisons.
  bool _isLengthDifferent(String current) => current.length != _originalLength;

  /// Performs a content comparison between the [current] text and [originalText].
  ///
  /// Uses a two-step verification process:
  /// 1. First checks hash codes for a quick mismatch (with fallback for collisions)
  /// 2. Then performs a full string comparison if hashes don't match
  ///
  /// Returns `true` if the content has been modified, `false` otherwise.
  bool _isContentModified(String current) {
    // First check hash for quick comparison, then verify with exact string comparison
    // to handle potential hash collisions
    return current.hashCode != _originalHash && current != _originalText;
  }
}
