import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FileRequired extends StatefulWidget {
  const FileRequired({
    super.key,
    required this.onFileChosen,
    required this.icon,
    required this.text,
    required this.child,
  });

  final void Function(XFile file) onFileChosen;
  final IconData icon;
  final String text;
  final Widget? child;

  @override
  State<FileRequired> createState() => _FileRequiredState();
}

class _FileRequiredState extends State<FileRequired> {
  bool _pickingFile = false;

  @override
  Widget build(BuildContext context) {
    final child = widget.child ??
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 64,
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: _pickingFile ? null : _pickFile,
                  child: Text(widget.text),
                )
              ],
            ),
          ),
        );

    return DropTarget(
      onDragDone: (details) {
        final file = details.files.firstOrNull;
        if (file == null) return;

        widget.onFileChosen(file);
      },
      child: child,
    );
  }

  void _pickFile() async {
    setState(() {
      _pickingFile = true;
    });

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      lockParentWindow: true,
    );

    final file = result?.files.firstOrNull;

    if (file == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cancelled.")));
      }

      setState(() {
        _pickingFile = false;
      });

      return;
    }

    XFile? xFile;
    if (kIsWeb) {
      xFile = XFile.fromData(
        file.bytes!,
        name: file.name,
        length: file.size,
      );
    } else {
      xFile = XFile(
        file.path!,
        name: file.name,
        bytes: file.bytes,
        length: file.size,
      );
    }

    widget.onFileChosen(xFile);

    setState(() {
      _pickingFile = false;
    });
  }
}
