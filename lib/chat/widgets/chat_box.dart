import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../duration_extensions.dart';
import '../../generic_player_state.dart';
import '../chat_controller.dart';
import '../data/chat_item_values.dart';
import '../data/chat_ticker_value.dart';
import '../youtube_theme.dart';
import 'chat_ticker.dart';
import 'items/chat_item.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key, required this.controller});

  final ChatController controller;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final _scrollController = ScrollController();
  final _pagingController =
      PagingController<int, ChatItemValue>(firstPageKey: 0);

  int get _pageSize => widget.controller.cachedItemCount;

  List<ChatItemValue> lastItems = [];
  List<ChatTickerValue> ongoingTickers = [];

  double? _draggingProgressValue;

  void _updateItems() {
    widget.controller
        .getLastItems(limit: _pageSize, offset: 0)
        .then((newLastItems) {
      if (lastItems == newLastItems) return;
      setState(() {
        lastItems = newLastItems;
        _pagingController.refresh();
      });
    });

    widget.controller.getOngoingTickers().then((newOngoingTickers) {
      if (ongoingTickers == newOngoingTickers) return;
      setState(() {
        ongoingTickers = newOngoingTickers;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.initialize().then((_) => setState);
    widget.controller.addListener(_updateItems);
    _pagingController.addPageRequestListener((offset) async {
      final items = (offset == 0)
          ? lastItems
          : await widget.controller.getLastItems(
              limit: _pageSize,
              offset: offset,
            );
      if (items.length < _pageSize) {
        _pagingController.appendLastPage(items.toList());
      } else {
        _pagingController.appendPage(
          items.toList(),
          offset + _pageSize,
        );
      }
    });
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.loadingFirstPage &&
          _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
    _updateItems();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_updateItems);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        // allow dragging on desktop, etc.
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      child: Column(
        children: [
          _buildTickers(),
          Expanded(child: _buildItems(context)),
          _buildPanel(),
        ],
      ),
    );
  }

  Stack _buildItems(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      fit: StackFit.expand,
      children: [
        NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              if (notification.scrollDelta == 0) return false;
              widget.controller.pause();
              return false;
            },
            child: PagedListView(
                pagingController: _pagingController,
                scrollController: _scrollController,
                reverse: true,
                builderDelegate: PagedChildBuilderDelegate<ChatItemValue>(
                  itemBuilder: (context, item, offset) {
                    return _buildItem(item, offset);
                  },
                  newPageProgressIndicatorBuilder: (context) =>
                      const Center(child: Text("Loading..")),
                ))),
        Positioned(
          bottom: 0,
          top: 0,
          right: 0,
          child: _buildProgressBar(context),
        ),
      ],
    );
  }

  Widget _buildItem(ChatItemValue item, int offset) {
    final itemWidget = Padding(
      key: (item is AuthoredChatItemValue) ? ValueKey(item.id) : null,
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 24.0,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ChatItem(value: item),
      ),
    );

    // add highlight to latest item
    if (offset == 0) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 16,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Colors.white.withOpacity(0),
                ],
              ),
            ),
          ),
          itemWidget,
        ],
      );
    } else {
      return itemWidget;
    }
  }

  Widget _buildTickers() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.6), width: 1),
      ),
      child: ongoingTickers.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: ongoingTickers.length,
              itemBuilder: (context, index) {
                final ticker = ongoingTickers.reversed.elementAtOrNull(index);
                if (ticker == null) return null;

                final current = widget.controller.currentEstimatedTimestamp;
                final start = ticker.timestamp;
                final end = ticker.endTimestamp;
                final percent = (current - start) / (end - start);

                return ChatTicker(value: ticker, completionPercentage: percent);
              },
              separatorBuilder: (context, index) => const SizedBox(width: 8),
            )
          : const Center(child: Text("No tickers")),
    );
  }

  SizedBox _buildProgressBar(BuildContext context) {
    return SizedBox(
      width: 35,
      child: FlutterSlider(
        axis: Axis.vertical,
        handlerWidth: 25,
        tooltip: FlutterSliderTooltip(
          direction: FlutterSliderTooltipDirection.left,
          custom: (value) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      Duration(microseconds: value.toInt()).toStringCompact()),
                ),
              ),
            );
          },
        ),
        handler: FlutterSliderHandler(
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    spreadRadius: 0.2,
                    offset: Offset(0, 1))
              ],
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle),
          child: widget.controller.value.playState.value == PlayState.paused
              ? const Icon(Icons.pause, size: 16)
              : const Icon(Icons.expand_more),
        ),
        values: [
          _draggingProgressValue ??
              widget.controller.value.position.value.inMicroseconds.toDouble()
        ],
        onDragging: (handlerIndex, lowerValue, upperValue) {
          _draggingProgressValue = lowerValue;
        },
        onDragCompleted: (handlerIndex, lowerValue, upperValue) {
          _draggingProgressValue = null;
          widget.controller
              .setPosition(Duration(microseconds: lowerValue.toInt()));
        },
        min: widget.controller.value.positionRange.value.start.inMicroseconds
            .toDouble(),
        max: widget
            .controller.value.positionRange.value.endInclusive.inMicroseconds
            .toDouble(),
      ),
    );
  }

  Widget _buildPanel() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.6), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 16),
        child: Row(
          children: [
            const Icon(
              Icons.lock_outline,
              color: YoutubeTheme.secondaryTextColor,
            ),
            IconButton(
              icon: const Icon(
                Icons.fast_rewind,
                color: YoutubeTheme.secondaryTextColor,
              ),
              onPressed: () => widget.controller.setPosition(
                widget.controller.value.position.value -
                    const Duration(seconds: 3),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.fast_forward,
                color: YoutubeTheme.secondaryTextColor,
              ),
              onPressed: () => widget.controller.setPosition(
                widget.controller.value.position.value +
                    const Duration(seconds: 3),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "${widget.controller.value.position.value.toStringCompact()}"
                  " / "
                  "${widget.controller.value.positionRange.value.endInclusive.toStringCompact()}",
                  style: YoutubeTheme.messageAuthorStyle,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                if (widget.controller.value.playState.value ==
                    PlayState.paused) {
                  widget.controller.play();
                } else {
                  widget.controller.pause();
                }
              },
              icon: Icon(
                widget.controller.value.playState.value == PlayState.paused
                    ? Icons.play_arrow
                    : Icons.pause,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
