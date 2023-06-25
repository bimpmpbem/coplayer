import 'package:flutter/widgets.dart';

extension RectNormalizeExtension on Rect {
  Rect denormalize(Size totalSize) => Rect.fromLTWH(
        left * totalSize.width,
        top * totalSize.height,
        width * totalSize.width,
        height * totalSize.height,
      );

  Rect normalize(Size totalSize) => Rect.fromLTWH(
        left / totalSize.width,
        top / totalSize.height,
        width / totalSize.width,
        height / totalSize.height,
      );
}

extension RectCornerExtension on Rect {
  Offset oppositeCorner(Offset point) => Offset(
        point.dx == left ? right : left,
        point.dy == top ? bottom : top,
      );
}

extension RectClampExtension on Rect {
  Rect clamp(Size minSize, Size maxSize) {
    final clampedWidth = width.clamp(minSize.width, maxSize.width);
    final clampedHeight = height.clamp(minSize.height, maxSize.height);
    return Rect.fromLTWH(
      left.clamp(0, maxSize.width - clampedWidth),
      top.clamp(0, maxSize.height - clampedHeight),
      clampedWidth,
      clampedHeight,
    );
  }
}

extension RectSnapExtension on Rect {
  Rect snap(Size cellSize) {
    return Rect.fromLTRB(
      cellSize.width == 0
          ? left
          : ((left + cellSize.width / 2) ~/ cellSize.width) * cellSize.width,
      cellSize.height == 0
          ? top
          : ((top + cellSize.height / 2) ~/ cellSize.height) * cellSize.height,
      cellSize.width == 0
          ? right
          : ((right + cellSize.width / 2) ~/ cellSize.width) * cellSize.width,
      cellSize.height == 0
          ? bottom
          : ((bottom + cellSize.height / 2) ~/ cellSize.height) *
              cellSize.height,
    );
  }
}
