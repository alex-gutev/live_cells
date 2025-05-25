part of 'live_widgets.dart';

abstract class _InkInterface extends _WrapperInterface {
  /// Is the widget enabled for user interaction?
  ValueCell<bool> get enabled;

  /// Action cell triggered when the widget is tapped
  ActionCell? get tap;

  /// Action cell triggered on a double tap
  ActionCell? get doubleTap;

  /// Action cell triggered when the widget is long pressed
  ActionCell? get longPress;

  /// Meta cell holding the details of the last tap down event
  MetaCell<TapDownDetails?>? get tapDown;

  /// Meta cell holding the details of the last tap up event
  MetaCell<TapUpDetails?>? get tapUp;

  /// Action cell triggered when a tap is cancelled
  ActionCell? get tapCancel;

  /// Action cell triggered on a secondary tap event
  ActionCell? get secondaryTap;

  /// Meta cell holding the details of the last secondary tap up event
  MetaCell<TapUpDetails?>? get secondaryTapUp;

  /// Meta cell holding the details of the last secondary tap down event
  MetaCell<TapDownDetails?>? get secondaryTapDown;

  /// Action cell triggered when a secondary tap is cancelled
  ActionCell? get secondaryTapCancel;

  /// Meta cell that is true when the widget is highlighted.
  MetaCell<bool>? get highlighted;

  /// Meta cell that is true when hovering over the widget.
  MetaCell<bool>? get hovered;

  /// Meta cell that is true when the widget is in focus.
  MetaCell<bool>? get focussed;
  
  const _InkInterface({super.key});
  
  @override
  Widget build(BuildContext context) {
    if (tapDown != null) {
      tapDown!.inject(_tapDownCell(context));
    }

    if (tapUp != null) {
      tapUp!.inject(_tapUpCell(context));
    }

    if (secondaryTapDown != null) {
      secondaryTapDown!.inject(_secondaryTapDownCell(context));
    }

    if (secondaryTapUp != null) {
      secondaryTapUp!.inject(_secondaryTapUpCell(context));
    }

    if (highlighted != null) {
      highlighted!.inject(_highlightedCell(context));
    }

    if (hovered != null) {
      hovered!.inject(_hoveredCell(context));
    }

    if (focussed != null) {
      focussed!.inject(_focussedCell(context));
    }

    return _buildWrappedWidget(context);
  }
  
  MutableCell<TapDownDetails?> _tapDownCell(BuildContext context) =>
      MutableCell(
        null,
        key: _InkInterfaceCellKey(context, #tapDown)
      );

  MutableCell<TapUpDetails?> _tapUpCell(BuildContext context) =>
      MutableCell(
          null,
          key: _InkInterfaceCellKey(context, #tapUp)
      );

  MutableCell<TapDownDetails?> _secondaryTapDownCell(BuildContext context) =>
      MutableCell(
          null,
          key: _InkInterfaceCellKey(context, #secondaryTapDown)
      );

  MutableCell<TapUpDetails?> _secondaryTapUpCell(BuildContext context) =>
      MutableCell(
          null,
          key: _InkInterfaceCellKey(context, #secondaryTapUp)
      );

  MutableCell<bool> _highlightedCell(BuildContext context) =>
      MutableCell(
        false,
        key: _InkInterfaceCellKey(context, #highlighted)
      );

  MutableCell<bool> _hoveredCell(BuildContext context) =>
      MutableCell(
          false,
          key: _InkInterfaceCellKey(context, #hovered)
      );

  MutableCell<bool> _focussedCell(BuildContext context) =>
      MutableCell(
          false,
          key: _InkInterfaceCellKey(context, #focused)
      );
}

class _InkInterfaceCellKey extends CellKey2<BuildContext, Symbol> {
  _InkInterfaceCellKey(super.value1, super.value2);
}