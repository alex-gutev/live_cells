/// Provides annotations to use with the live_cell_extensions package.
library live_cell_annotations;

export 'src/annotations/annotations.dart'
    show CellExtension, DataClass, DataField;

export 'src/annotations/generator_annotations.dart'
    show
        GenerateCellWidgets,
        WidgetSpec,
        WidgetPropertySpec,
        GenerateValueExtensions,
        ExtensionSpec;
