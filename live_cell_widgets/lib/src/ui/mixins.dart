part of 'live_widgets.dart';

/// Provides the onHover and onFocusChange cells.
mixin _HoverFocusChangeCellMixin on _WrapperInterface {
  /// Meta cell for on hover event
  MetaCell<bool>? get onHover;

  /// Meta cell for on focus change event
  MetaCell<bool>? get onFocusChange;

  /// Get the action cell representing the onHover event
  MutableCell<bool> _onHoverCell(BuildContext context) => MutableCell(false,
      key: _WidgetMixinCellKey(context, #onHover)
  );

  /// Get the action cell representing the onFocusChange event
  MutableCell<bool> _onFocusChangeCell(BuildContext context) => MutableCell(false,
      key: _WidgetMixinCellKey(context, #onFocusChange)
  );
  
  @override
  Widget build(BuildContext context) {
    if (onHover != null) {
      onHover!.setCell(_onHoverCell(context));
    }

    if (onFocusChange != null) {
      onFocusChange!.setCell(_onFocusChangeCell(context));
    }
    
    return _buildWrappedWidget(context);
  }
}

/// Key identifying a cell which represents an event.
class _WidgetMixinCellKey extends CellKey2<BuildContext, Symbol> {
  _WidgetMixinCellKey(super.value1, super.value2);
}