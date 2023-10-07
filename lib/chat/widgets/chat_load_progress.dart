import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

import '../../duration_extensions.dart';
import '../data/chat_data.dart';

class ChatLoadProgress extends StatelessWidget {
  const ChatLoadProgress({
    super.key,
    required this.metadata,
  });

  final ChatLoadMetadata? metadata;

  @override
  Widget build(BuildContext context) {
    final metadata = this.metadata;

    if (metadata == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final range = metadata.timestampRange;

    final duration = DateTime.fromMicrosecondsSinceEpoch(range.endInclusive)
        .difference(DateTime.fromMicrosecondsSinceEpoch(range.start));

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "${filesize(metadata.loadedBytes)} / ${filesize(metadata.totalBytes)}"),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (metadata.totalBytes != null && metadata.totalBytes! > 0)
                  ? metadata.loadedBytes / metadata.totalBytes!
                  : null,
            ),
            const SizedBox(height: 16),
            Text(duration.toStringCompact()),
            if (metadata.itemCount > 0) Text("${metadata.itemCount} items"),
            if (metadata.tickerCount > 0)
              Text("${metadata.tickerCount} tickers"),
          ],
        ),
      ),
    );
  }
}
