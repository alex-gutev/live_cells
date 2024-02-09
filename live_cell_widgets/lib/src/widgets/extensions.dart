import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live_cell_annotations/live_cell_annotations.dart';
import 'package:live_cells_core/live_cells_core.dart';

@GenerateValueExtensions([
  ExtensionSpec<Widget>(forSubclasses: true),
  ExtensionSpec<TextStyle>(),
  ExtensionSpec<StrutStyle>(),
  ExtensionSpec<Locale>(),
  ExtensionSpec<TextScaler>(),
  ExtensionSpec<TextHeightBehavior>(),
  ExtensionSpec<Color>(),
  ExtensionSpec<InputDecoration>(),
  ExtensionSpec<TextAlignVertical>(),
  ExtensionSpec<Radius>(),
  ExtensionSpec<EdgeInsets>(),
  ExtensionSpec<TextSelectionControls>(),
  ExtensionSpec<TextInputType>()
])
part 'extensions.g.dart';