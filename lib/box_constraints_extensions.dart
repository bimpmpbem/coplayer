import 'package:flutter/widgets.dart';

extension BoxConstraintsRect on BoxConstraints {
  Size get maxSize => Size(maxWidth, maxHeight);
}
