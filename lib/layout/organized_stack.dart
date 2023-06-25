import 'package:flutter/material.dart';

import 'package:dartx/dartx.dart';

import '../debug_preview.dart';
import '../box_constraints_extensions.dart';
import '../rect_extensions.dart';

class GridDefinition {
  final int verticalTileCount;
  final int horizontalTileCount;

  const GridDefinition(this.verticalTileCount, this.horizontalTileCount);

  Size cellSize(Size totalSize) => Size(
        horizontalTileCount > 0 ? totalSize.width / horizontalTileCount : 0,
        verticalTileCount > 0 ? totalSize.height / horizontalTileCount : 0,
      );
}

typedef OrganizedWidgetBuilder = Widget Function(
    BuildContext context, int index, Rect rect);

class OrganizedStack extends StatefulWidget {
  const OrganizedStack({
    required this.children,
    this.feedbackWhenPreviewing,
    this.gridToSnap,
    this.onRectChanged,
    this.editMode = false,
    super.key,
  });

  /// Map of normalized positions (between 0 and 1) and their widgets.
  // TODO maybe use Alignment instead of Rect?
  // TODO order by circumference (small->big) for less conflicts when resizing?
  final Map<Rect, Widget> children;

  /// The widget to show under the pointer when an edit is under way.
  ///
  /// If null, nothing will be previewed.
  final Widget Function(Rect originalRect)? feedbackWhenPreviewing;

  /// Grid to use when snapping widgets to grid.
  ///
  /// If null, no snapping will occur.
  final GridDefinition? gridToSnap;

  /// Whether widgets can be reorganized manually.
  final bool editMode;

  /// Will get called when size/position of a rect/widget changes.
  final Function(Rect originalRect, Rect newRect)? onRectChanged;

  @override
  State<OrganizedStack> createState() => _OrganizedStackState();
}

class _OrganizedStackState extends State<OrganizedStack> {
  static const normalAnimationDuration = Duration(milliseconds: 200);
  static const shortAnimationDuration = Duration(milliseconds: 50);

  static const draggingOpacity = 0.3;
  static const resizeTargetSize = 24.0;

  /// Specified a (normalized) rect, defined in [widget.children].
  Rect? editOriginalNormalized;

  /// Specifies a potential (denormalized) rect after edit is performed.
  ///
  /// Not clamped or snapped.
  Rect? editModifiedDenormalized;

  void notifyRectChanged(Rect originalRect, Rect changedRect) {
    setState(() {
      widget.onRectChanged?.invoke(originalRect, changedRect);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final editAnimationDuration =
          widget.gridToSnap != null ? shortAnimationDuration : Duration.zero;

      final cellSize =
          widget.gridToSnap?.cellSize(constraints.maxSize) ?? Size.zero;

      final editModifiedDenormalized = this.editModifiedDenormalized;
      final editOriginalNormalized = this.editOriginalNormalized;

      final bodies = widget.children.entries.flatMap((entry) {
        final originalRect = entry.key;
        final denormalizedRect = originalRect.denormalize(constraints.maxSize);
        final child = entry.value;

        onEditEnd(Rect originalRect, Rect finalRect) => notifyRectChanged(
              originalRect,
              finalRect
                  .clamp(cellSize, constraints.maxSize)
                  .snap(cellSize)
                  .normalize(constraints.maxSize),
            );

        return [
          AnimatedPositioned.fromRect(
            rect: denormalizedRect,
            duration: normalAnimationDuration,
            child: AnimatedOpacity(
              duration: normalAnimationDuration,
              opacity:
                  originalRect == editOriginalNormalized ? draggingOpacity : 1,
              child: GestureDetector(
                onPanStart: widget.editMode
                    ? (details) =>
                        onPanStart(originalRect, details, constraints)
                    : null,
                onPanUpdate: widget.editMode
                    ? (details) => onBodyPanUpdate(originalRect, details)
                    : null,
                onPanEnd: widget.editMode
                    ? (details) =>
                        onPanEnd(originalRect, details, onEditEnd: onEditEnd)
                    : null,
                onPanCancel:
                    widget.editMode ? () => onPanCancel(originalRect) : null,
                child: child,
              ),
            ),
          ),
          _buildCorner(originalRect, denormalizedRect.topLeft, constraints,
              onEditEnd: onEditEnd),
          _buildCorner(originalRect, denormalizedRect.topRight, constraints,
              onEditEnd: onEditEnd),
          _buildCorner(originalRect, denormalizedRect.bottomLeft, constraints,
              onEditEnd: onEditEnd),
          _buildCorner(originalRect, denormalizedRect.bottomRight, constraints,
              onEditEnd: onEditEnd),
        ];
      });

      final previewWidget = editOriginalNormalized != null
          ? widget.feedbackWhenPreviewing?.invoke(editOriginalNormalized)
          : null;

      return Stack(
        children: [
          ...bodies,
          if (editModifiedDenormalized != null &&
              previewWidget != null &&
              widget.editMode)
            AnimatedPositioned.fromRect(
              rect: editModifiedDenormalized
                  .clamp(cellSize, constraints.maxSize)
                  .snap(cellSize),
              duration: editAnimationDuration,
              child: previewWidget,
            ),
        ],
      );
    });
  }

  Widget _buildCorner(
    Rect rect,
    Offset cornerPosition,
    BoxConstraints constraints, {
    required Function(Rect originalRect, Rect finalRect) onEditEnd,
  }) {
    final denormalizedRect = rect.denormalize(constraints.maxSize);
    return AnimatedPositioned.fromRect(
        duration: normalAnimationDuration,
        rect: Rect.fromCircle(
            center: cornerPosition, radius: resizeTargetSize / 2),
        child: GestureDetector(
          onPanStart: widget.editMode
              ? (details) => onPanStart(rect, details, constraints)
              : null,
          onPanUpdate: widget.editMode
              ? (details) => onCornerPanUpdate(rect,
                  denormalizedRect.oppositeCorner(cornerPosition), details)
              : null,
          onPanEnd: widget.editMode
              ? (details) => onPanEnd(
                    rect,
                    details,
                    onEditEnd: onEditEnd,
                  )
              : null,
          onPanCancel: widget.editMode ? () => onPanCancel(rect) : null,
          child: AnimatedOpacity(
            duration: normalAnimationDuration,
            opacity: widget.editMode ? 0.4 : 0,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey),
              width: resizeTargetSize,
              height: resizeTargetSize,
            ),
          ),
        ));
  }

  void onPanStart(
      Rect originalRect, DragStartDetails details, BoxConstraints constraints) {
    if (editOriginalNormalized != null) return;
    setState(() {
      editOriginalNormalized = originalRect;
      editModifiedDenormalized =
          editOriginalNormalized?.denormalize(constraints.maxSize);
    });
  }

  void onBodyPanUpdate(Rect originalRect, DragUpdateDetails details) {
    if (editOriginalNormalized != originalRect) return;
    setState(() {
      editModifiedDenormalized = editModifiedDenormalized?.shift(details.delta);
    });
  }

  void onCornerPanUpdate(
      Rect originalRect, Offset staticPoint, DragUpdateDetails details) {
    final editModifiedDenormalized = this.editModifiedDenormalized;
    if (editOriginalNormalized != originalRect ||
        editModifiedDenormalized == null) return;

    final movingPointX = (staticPoint.dx == editModifiedDenormalized.left)
        ? editModifiedDenormalized.right
        : editModifiedDenormalized.left;
    final movingPointY = (staticPoint.dy == editModifiedDenormalized.top)
        ? editModifiedDenormalized.bottom
        : editModifiedDenormalized.top;
    final movingPoint = Offset(movingPointX, movingPointY);

    setState(() {
      this.editModifiedDenormalized =
          Rect.fromPoints(staticPoint, movingPoint + details.delta);
    });
  }

  void onPanEnd(
    Rect originalRect,
    DragEndDetails details, {
    required Function(Rect originalRect, Rect finalRect) onEditEnd,
  }) {
    final editModifiedDenormalized = this.editModifiedDenormalized;
    if (editOriginalNormalized != originalRect ||
        editModifiedDenormalized == null) return;

    // TODO verify target position is valid (no conflicts, visible, etc.)

    setState(() {
      onEditEnd(originalRect, editModifiedDenormalized);
      editOriginalNormalized = null;
      this.editModifiedDenormalized = null;
    });
  }

  void onPanCancel(Rect originalRect) {
    if (editOriginalNormalized != originalRect) return;
    setState(() {
      editOriginalNormalized = null;
      editModifiedDenormalized = null;
    });
  }
}

void main() {
  runPreview(OrganizedStack(
    editMode: true,
    gridToSnap: const GridDefinition(10, 10),
    children: {
      const Rect.fromLTWH(0.1, 0.1, 0.1, 0.1): Container(color: Colors.red),
      const Rect.fromLTWH(0.0, 0.5, 0.3, 0.3): Container(color: Colors.green),
      const Rect.fromLTWH(0.2, 0.7, 0.5, 0.3): Container(color: Colors.blue),
    },
  ));
}
