import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_text_editing_controller/cached_text_editing_controller.dart';

void main() {
  group('CachedTextEditingController Tests', () {
    test('Small text - unmodified', () {
      final controller = CachedTextEditingController(text: 'hello');
      expect(controller.isTextModified, isFalse);
      expect(controller.text, 'hello');
    });

    test('Small text - modified', () {
      final controller = CachedTextEditingController(text: 'hello');
      controller.text = 'world';
      expect(controller.isTextModified, isTrue);
      expect(controller.text, 'world');
    });

    test('Medium text - unmodified', () {
      final controller = CachedTextEditingController(
        text:
            'This is a medium length text that contains multiple sentences and should be long enough to test the controller behavior.',
      );
      expect(controller.isTextModified, isFalse);
      expect(controller.text.length, greaterThan(50));
    });

    test('Medium text - modified', () {
      final controller = CachedTextEditingController(
        text:
            'This is a medium length text that contains multiple sentences and should be long enough to test the controller behavior.',
      );
      controller.text = 'Modified text with different content and length.';
      expect(controller.isTextModified, isTrue);
    });

    test('Long text - unmodified', () {
      final longText = 'A' * 1000;
      final controller = CachedTextEditingController(text: longText);
      expect(controller.isTextModified, isFalse);
      expect(controller.text.length, 1000);
    });

    test('Long text - modified', () {
      final longText = 'A' * 1000;
      final controller = CachedTextEditingController(text: longText);
      controller.text = 'B' * 1000;
      expect(controller.isTextModified, isTrue);
    });

    test('Very long text - unmodified', () {
      final veryLongText = 'X' * 50000;
      final controller = CachedTextEditingController(text: veryLongText);
      expect(controller.isTextModified, isFalse);
      expect(controller.text.length, 50000);
    });

    test('Very long text - modified', () {
      final veryLongText = 'X' * 50000;
      final controller = CachedTextEditingController(text: veryLongText);
      controller.text = 'Y' * 50000;
      expect(controller.isTextModified, isTrue);
    });

    test('Extremely long text - unmodified', () {
      final extremelyLongText = 'Z' * 100000;
      final controller = CachedTextEditingController(text: extremelyLongText);
      expect(controller.isTextModified, isFalse);
      expect(controller.text.length, 100000);
    });

    test('Extremely long text - modified', () {
      final extremelyLongText = 'Z' * 100000;
      final controller = CachedTextEditingController(text: extremelyLongText);
      controller.text = 'W' * 100000;
      expect(controller.isTextModified, isTrue);
    });

    test('Modified state after clearing', () {
      final controller = CachedTextEditingController(text: 'some text');
      controller.clear();
      expect(controller.isTextModified, isTrue);
      expect(controller.text, '');
    });

    test('Empty text - unmodified', () {
      final controller = CachedTextEditingController(text: '');
      expect(controller.isTextModified, isFalse);
      expect(controller.text, '');
    });

    test('Empty text - modified', () {
      final controller = CachedTextEditingController(text: '');
      controller.text = 'not empty';
      expect(controller.isTextModified, isTrue);
    });

    test('Unicode characters - unmodified', () {
      final unicodeText = '🚀 Unicode 测试 🌟';
      final controller = CachedTextEditingController(text: unicodeText);
      expect(controller.isTextModified, isFalse);
      expect(controller.text, unicodeText);
    });

    test('Unicode characters - modified', () {
      final unicodeText = '🚀 Unicode 测试 🌟';
      final controller = CachedTextEditingController(text: unicodeText);
      controller.text = 'Modified 🚀 Unicode 🌟';
      expect(controller.isTextModified, isTrue);
    });

    test('Special characters - unmodified', () {
      final specialText = '!@#\$%^&*()_+{}|:<>?[]\\;\'",./`~';
      final controller = CachedTextEditingController(text: specialText);
      expect(controller.isTextModified, isFalse);
    });

    test('Special characters - modified', () {
      final specialText = '!@#\$%^&*()_+{}|:<>?[]\\;\'",./`~';
      final controller = CachedTextEditingController(text: specialText);
      controller.text = 'Modified !@#\$%^&*()_+{}|:<>?[]\\;\'",./`~';
      expect(controller.isTextModified, isTrue);
    });

    test('Newlines and whitespace - unmodified', () {
      final multilineText = 'Line 1\nLine 2\n\tTabbed\n  Spaced';
      final controller = CachedTextEditingController(text: multilineText);
      expect(controller.isTextModified, isFalse);
    });

    test('Newlines and whitespace - modified', () {
      final multilineText = 'Line 1\nLine 2\n\tTabbed\n  Spaced';
      final controller = CachedTextEditingController(text: multilineText);
      controller.text = 'Modified\nLine 2\n\tTabbed\n  Spaced';
      expect(controller.isTextModified, isTrue);
    });

    test('Hash collision scenario (theoretical)', () {
      // In practice, hash collisions are extremely rare, but this documents the behavior
      final controller = CachedTextEditingController(text: 'test');
      // If we had a string with same hash but different content, it would still be detected
      // as modified due to the final string comparison in _isContentModified
      controller.text = 'different content but same hash';
      expect(controller.isTextModified, isTrue);
    });

    test('Performance with extremely large text', () {
      final times = 100000000;
      final hugeText = 'A' * times;
      final stopwatch = Stopwatch()..start();

      final controller = CachedTextEditingController(text: hugeText);
      final initializationTime = stopwatch.elapsedMilliseconds;

      expect(controller.isTextModified, isFalse);
      expect(controller.text.length, times);

      controller.text = 'B' * times;
      final modificationTime =
          stopwatch.elapsedMilliseconds - initializationTime;

      expect(controller.isTextModified, isTrue);

      expect(initializationTime, lessThan(1000));
      expect(modificationTime, lessThan(1000));

      stopwatch.stop();
    });

    test('Multiple modifications tracking', () {
      final controller = CachedTextEditingController(text: 'original');

      expect(controller.isTextModified, isFalse);

      controller.text = 'first modification';
      expect(controller.isTextModified, isTrue);

      controller.text = 'second modification';
      expect(controller.isTextModified, isTrue);

      controller.text = 'third modification';
      expect(controller.isTextModified, isTrue);

      // Even if we change back to something different, it should still be modified
      controller.text = 'different from original';
      expect(controller.isTextModified, isTrue);
    });

    test('Case sensitivity in modification detection', () {
      final controller = CachedTextEditingController(text: 'Hello World');

      controller.text = 'hello world'; // Different case
      expect(controller.isTextModified, isTrue);

      controller.text = 'Hello world'; // Different capitalization
      expect(controller.isTextModified, isTrue);

      controller.text = 'HELLO WORLD'; // All caps
      expect(controller.isTextModified, isTrue);
    });

    test('Substring modifications', () {
      final controller = CachedTextEditingController(
        text: 'The quick brown fox jumps over the lazy dog',
      );

      controller.text =
          'The slow brown fox jumps over the lazy dog'; // Changed 'quick' to 'slow'
      expect(controller.isTextModified, isTrue);
    });

    test('Text IME composition', () {
      final controller = CachedTextEditingController();

      controller.value = const TextEditingValue(
        text: 'こんにちは',
        composing: TextRange(start: 0, end: 5),
        selection: TextSelection.collapsed(offset: 5),
      );

      expect(controller.value.composing, const TextRange(start: 0, end: 5));
      expect(controller.value.selection.baseOffset, 5);
    });

    test('Listeners notification', () {
      final controller = CachedTextEditingController(text: 'initial');
      bool wasNotified = false;

      void listener() {
        wasNotified = true;
      }

      expect(controller.isTextModified, isFalse);

      controller.addListener(listener);

      controller.text = 'changed';
      expect(wasNotified, isTrue);
      expect(controller.isTextModified, isTrue);

      wasNotified = false;
      controller.text = 'changed';
      expect(wasNotified, isFalse);
      expect(controller.isTextModified, isTrue);

      controller.text = 'initial';
      expect(wasNotified, isTrue);
      expect(controller.isTextModified, isFalse);

      wasNotified = false;
      controller.removeListener(listener);
      controller.text = 'removed';
      expect(wasNotified, isFalse);
      expect(controller.isTextModified, isTrue);
    });
  });
}
