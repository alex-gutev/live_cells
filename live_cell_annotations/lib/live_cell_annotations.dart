/// Provides annotations to use with the live_cell_extensions package.
library live_cell_annotations;

export 'src/annotations/annotations.dart' show CellExtension;

export 'src/annotations/generate_cell_widget.dart'
    show
        GenerateCellWidgets,
        WidgetSpec,
        WidgetPropertySpec,
        GenerateValueExtensions,
        ExtensionSpec;
