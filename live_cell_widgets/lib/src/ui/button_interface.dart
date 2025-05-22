part of 'live_widgets.dart';

/// Defines the interface for a button widget controlled by [ValueCell]s.
abstract class _ButtonInterface extends _WrapperInterface {
  /// [ActionCell] to trigger when the button is pressed.
  ActionCell? get press;

  /// [ActionCell] to trigger when the button is long pressed.
  ActionCell? get longPress;

  /// Is the button enabled for user input?
  ValueCell<bool> get enabled;

  /// Meta cell that is updated whenever the hover state of the button changes.
  ///
  /// The value of the cell is true when hovering over the button and false
  /// otherwise.
  MetaCell<bool>? get onHover;

  const _ButtonInterface({super.key});

  @override
  Widget build(BuildContext context) {
    if (onHover != null) {
      onHover!.setCell(_onHoverCell(context));
    }

    return _buildWrappedWidget(context);
  }

  /// Get the action cell representing the onHover event
  MutableCell<bool> _onHoverCell(BuildContext context) => MutableCell(false,
      key: _ButtonInterfaceCellKey(context, #onHover)
  );
}

abstract class _FocusButtonInterface extends _ButtonInterface {
  /// MetaCell that is updated whenever the focus state of the button changes.
  ///
  /// The value of the cell is true when the button is focussed and false
  /// otherwise.
  MetaCell<bool>? get onFocusChange;

  const _FocusButtonInterface({super.key});

  @override
  Widget build(BuildContext context) {
    if (onFocusChange != null) {
      onFocusChange!.setCell(_onFocusChangeCell(context));
    }

    return super.build(context);
  }

  /// Get the action cell representing the onFocusChange event
  MutableCell<bool> _onFocusChangeCell(BuildContext context) => MutableCell(false,
      key: _ButtonInterfaceCellKey(context, #onFocusChange)
  );
}

class _ButtonInterfaceCellKey extends CellKey2<BuildContext, Symbol> {
  _ButtonInterfaceCellKey(super.value1, super.value2);
}