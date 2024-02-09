/// Provides wrappers over Flutter widgets which allow their properties to be controlled by [ValueCell]'s.

library live_cell_widgets;

export 'src/widgets/widgets.dart'
    show
        CellText,
        CellCheckbox,
        CellCheckboxListTile,
        CellSlider,
        CellRadio,
        CellRadioListTile,
        CellSwitch,
        CellSwitchListTile;

export 'src/widgets/cell_text_field.dart' show CellTextField;

export 'src/widgets/extensions.dart'
    show
        WidgetCellValueExtension,
        TextStyleCellValueExtension,
        StrutStyleCellValueExtension,
        LocaleCellValueExtension,
        TextScalerCellValueExtension,
        TextHeightBehaviorCellValueExtension,
        ColorCellValueExtension,
        InputDecorationCellValueExtension,
        TextAlignVerticalCellValueExtension,
        RadiusCellValueExtension,
        EdgeInsetsCellValueExtension,
        TextSelectionControlsCellValueExtension,
        TextInputTypeCellValueExtension;
