import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';

import '../data/chat_data.dart';
import '../../duration_extensions.dart';

class ChatLoadProgress extends StatelessWidget {
  const ChatLoadProgress({
    super.key,
    required this.chatLoadedBytes,
    required this.chatTotalBytes,
    required this.chatLoadMetadata,
  });

  final int chatLoadedBytes;
  final int? chatTotalBytes;
  final ChatMetadata? chatLoadMetadata;

  @override
  Widget build(BuildContext context) {
    final chatLoadMetadata = this.chatLoadMetadata;

    if (chatLoadMetadata == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final range = chatLoadMetadata.timestampRange;

    final duration = DateTime.fromMicrosecondsSinceEpoch(range.endInclusive)
        .difference(DateTime.fromMicrosecondsSinceEpoch(range.start));

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${filesize(chatLoadedBytes)} / ${filesize(chatTotalBytes)}"),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (chatTotalBytes != null && chatTotalBytes! > 0)
                  ? chatLoadedBytes / chatTotalBytes!
                  : null,
            ),
            const SizedBox(height: 16),
            Text(duration.toStringCompact()),
            Text("${chatLoadMetadata.itemCount} items"),
            Text("${chatLoadMetadata.tickerCount} tickers"),
          ],
        ),
      ),
    );
  }
}
