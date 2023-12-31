import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor_plus.dart';
import 'package:html_editor_enhanced_example/plus/core/control_button.dart';
import 'package:html_editor_enhanced_example/plus/core/controls.dart';

import 'core/app_bar_icon_button.dart';

class HtmlEditorPlusExample extends StatefulWidget {
  const HtmlEditorPlusExample({super.key});

  @override
  State<HtmlEditorPlusExample> createState() => _HtmlEditorPlusExampleState();
}

class _HtmlEditorPlusExampleState extends State<HtmlEditorPlusExample> {
  late final HtmlEditorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HtmlEditorController(initialHtml: "Initial text");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar,
        body: Column(
          children: [
            Expanded(
              child: HtmlEditor(
                controller: _controller,
              ),
            ),
            EditorControls(
              controls: [
                ControlButton(
                  onPressed: _controller.clear,
                  icon: Icons.clear,
                  label: "Clear",
                ),
                ControlButton(
                  onPressed: _controller.undo,
                  icon: Icons.undo,
                  label: "Undo",
                ),
                ControlButton(
                  onPressed: _controller.redo,
                  icon: Icons.redo,
                  label: "Redo",
                ),
                ControlButton(
                  onPressed: _controller.disable,
                  icon: Icons.edit_off,
                  label: "Disable",
                ),
                ControlButton(
                  onPressed: _controller.enable,
                  icon: Icons.edit,
                  label: "Enable",
                ),
              ],
            ),
          ],
        ),
      );

  AppBar get _appBar => AppBar(
        title: const Text('HtmlEditorPlus Example'),
        actions: [
          AppBarIconButton(
            icon: Icons.refresh,
            onPressed: _controller.reload,
          ),
          AppBarIconButton(
            icon: Icons.code,
            onPressed: _controller.toggleCodeView,
          ),
        ],
      );
}
