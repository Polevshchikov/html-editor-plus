import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html_editor_enhanced/src/html_editor_controller_unsupported.dart'
    as unsupported;

/// Controller for mobile
class HtmlEditorController extends unsupported.HtmlEditorController {
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
  InAppWebViewController? get editorController => controllerMap[this];

  /// Gets the text from the editor and returns it as a [String].
  Future<String> getText() async {
    String? text = await _evaluateJavascript(
        source: "\$('#summernote-2').summernote('code');") as String?;
    if (processOutputHtml &&
        (text == null ||
            text.isEmpty ||
            text == "<p></p>" ||
            text == "<p><br></p>" ||
            text == "<p><br/></p>")) text = "";
    return text ?? "";
  }

  /// Sets the text of the editor. Some pre-processing is applied to convert
  /// [String] elements like "\n" to HTML elements.
  void setText(String text) {
    if (processInputHtml) {
      text = text
          .replaceAll("'", '\\"')
          .replaceAll('"', '\\"')
          .replaceAll("[", "\\[")
          .replaceAll("]", "\\]")
          .replaceAll("\n", "<br/>")
          .replaceAll("\n\n", "<br/>")
          .replaceAll("\r", " ")
          .replaceAll('\r\n', " ");
    }
    _evaluateJavascript(
        source: "\$('#summernote-2').summernote('code', '$text');");
  }

  /// Sets the editor to full-screen mode.
  void setFullScreen() {
    _evaluateJavascript(
        source: '\$("#summernote-2").summernote("fullscreen.toggle");');
  }

  /// Sets the focus to the editor.
  void setFocus() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('focus');");
  }

  /// Clears the editor of any text.
  void clear() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('reset');");
  }

  /// Sets the hint for the editor.
  void setHint(String text) {
    String hint = '\$(".note-placeholder").html("$text");';
    _evaluateJavascript(source: hint);
  }

  /// toggles the codeview in the Html editor
  void toggleCodeView() {
    _evaluateJavascript(
        source: "\$('#summernote-2').summernote('codeview.toggle');");
  }

  /// disables the Html editor
  void disable() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('disable');");
  }

  /// enables the Html editor
  void enable() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('enable');");
  }

  /// Undoes the last action
  void undo() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('undo');");
  }

  /// Redoes the last action
  void redo() {
    _evaluateJavascript(source: "\$('#summernote-2').summernote('redo');");
  }

  /// Insert text at the end of the current HTML content in the editor
  /// Note: This method should only be used for plaintext strings
  void insertText(String text) {
    _evaluateJavascript(
        source: "\$('#summernote-2').summernote('insertText', '$text');");
  }

  /// Insert HTML at the position of the cursor in the editor
  /// Note: This method should not be used for plaintext strings
  void insertHtml(String html) {
    _evaluateJavascript(
        source: "\$('#summernote-2').summernote('pasteHTML', '$html');");
  }

  /// Insert a network image at the position of the cursor in the editor
  void insertNetworkImage(String url, {String filename = ""}) {
    _evaluateJavascript(
        source:
            "\$('#summernote-2').summernote('insertImage', '$url', '$filename');");
  }

  /// Insert a link at the position of the cursor in the editor
  void insertLink(String text, String url, bool isNewWindow) {
    _evaluateJavascript(source: """
    \$('#summernote-2').summernote('createLink', {
        text: "$text",
        url: '$url',
        isNewWindow: $isNewWindow
      });
    """);
  }

  /// Clears the focus from the webview by hiding the keyboard, calling the
  /// clearFocus method on the [InAppWebViewController], and resetting the height
  /// in case it was changed.
  void clearFocus() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    editorController!.clearFocus();
    resetHeight();
  }

  /// Resets the height of the editor back to the original if it was changed to
  /// accommodate the keyboard. This should only be used on mobile, and only
  /// when [adjustHeightForKeyboard] is enabled.
  void resetHeight() {
    _evaluateJavascript(source: "console.log('_HtmlEditorWidgetMobileState().resetHeight();');");
  }

  /// Reloads the IFrameElement, throws an exception on mobile
  void reloadWeb() {
    throw Exception(
        "Non-Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart and check kIsWeb before calling this function");
  }

  /// Helper function to evaluate JS and check the current environment
  dynamic _evaluateJavascript({required source}) async {
    if (!kIsWeb) {
      if (controllerMap[this] == null || await editorController!.isLoading())
        throw Exception(
            "HTML editor is still loading, please wait before evaluating this JS: $source!");
      var result = await editorController!.evaluateJavascript(source: source);
      return result;
    } else {
      throw Exception(
          "Flutter Web environment detected, please make sure you are importing package:html_editor_enhanced/html_editor.dart");
    }
  }
}