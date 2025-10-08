/// An interface for any class that can track text modifications.
///
/// Classes implementing this interface should provide a way to determine
/// if their text content has been modified from its original state.
abstract class TextModifiable {
  /// Returns `true` if the current text differs from the original text.
  bool get isTextModified;
}
