import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Fallback controller (should never be used)
class HtmlEditorController {
  HtmlEditorController({
    this.processInputHtml = false,
    this.processOutputHtml = true,
  });

  /// Determines whether text processing should happen on input HTML, e.g.
  /// whether a new line should be converted to a <br>.
  ///
  /// The default value is false.
  final bool processInputHtml;

  /// Determines whether text processing should happen on output HTML, e.g.
  /// whether <p><br></p> is returned as "". For reference, Summernote uses
  /// that HTML as the default HTML (when no text is in the editor).
  ///
  /// The default value is true.
  final bool processOutputHtml;

  /// Allows the [InAppWebViewController] for the Html editor to be accessed
  /// outside of the package itself for endless control and customization.
  InAppWebViewController? get editorController => null;

  /// Gets the text from the editor and returns it as a [String].
  Future<String?> getText() => Future.value(null);

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  void setText(String text) {}

  /// Sets the editor to full-screen mode.
  void setFullScreen() {}

  /// Sets the focus to the editor.
  void setFocus() {}

  /// Clears the editor of any text.
  void clear() {}

  /// Sets the hint for the editor.
  void setHint(String text) {}

  /// toggles the codeview in the Html editor
  void toggleCodeView() {}

  /// disables the Html editor
  void disable() {}

  /// enables the Html editor
  void enable() {}

  /// Undoes the last action
  void undo() {}

  /// Redoes the last action
  void redo() {}

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  void insertText(String text) {}

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  void insertHtml(String html) {}

  /// Insert a network image at the position of the cursor in the editor
  void insertNetworkImage(String url, {String filename = ""}) {}

  /// Insert a link at the position of the cursor in the editor
  void insertLink(String text, String url, bool isNewWindow) {}

  /// Clears the focus from the webview by hiding the keyboard, calling the
  /// clearFocus method on the [InAppWebViewController], and resetting the height
  /// in case it was changed.
  void clearFocus() {}

  /// Resets the height of the editor back to the original if it was changed to
  /// accommodate the keyboard. This should only be used on mobile, and only
  /// when [adjustHeightForKeyboard] is enabled.
  void resetHeight() {}

  /// Refresh the page
  ///
  /// Note: This should only be used in Flutter Web!!!
  void reloadWeb() {}
}