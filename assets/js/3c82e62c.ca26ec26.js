"use strict";(self.webpackChunkmy_website_2=self.webpackChunkmy_website_2||[]).push([[775],{8372:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>a,contentTitle:()=>o,default:()=>h,frontMatter:()=>s,metadata:()=>r,toc:()=>d});var l=n(4848),i=n(8453);const s={title:"State Restoration",description:"How to save and restore the state of cells",sidebar_position:7},o="State Restoration",r={id:"basics/state-restoration",title:"State Restoration",description:"How to save and restore the state of cells",source:"@site/docs/basics/state-restoration.md",sourceDirName:"basics",slug:"/basics/state-restoration",permalink:"/live_cells/docs/basics/state-restoration",draft:!1,unlisted:!1,editUrl:"https://github.com/alex-gutev/live_cells/docs/basics/state-restoration.md",tags:[],version:"current",sidebarPosition:7,frontMatter:{title:"State Restoration",description:"How to save and restore the state of cells",sidebar_position:7},sidebar:"tutorialSidebar",previous:{title:"Error Handling",permalink:"/live_cells/docs/basics/error-handling"},next:{title:"User Defined Types",permalink:"/live_cells/docs/basics/user-defined-types"}},a={},d=[{value:"Restoration ID",id:"restoration-id",level:2},{value:"User-Defined Types",id:"user-defined-types",level:2},{value:"State Restoration in StaticWidget",id:"state-restoration-in-staticwidget",level:2},{value:"Recomputed Cell State",id:"recomputed-cell-state",level:2}];function c(e){const t={a:"a",admonition:"admonition",code:"code",em:"em",h1:"h1",h2:"h2",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,i.R)(),...e.components};return(0,l.jsxs)(l.Fragment,{children:[(0,l.jsx)(t.h1,{id:"state-restoration",children:"State Restoration"}),"\n",(0,l.jsx)(t.p,{children:"A mobile application may be terminated at any point when the user is\nnot interacting with it. When it is resumed, due to the user\nnavigating back to it, it should restore its state to the point where\nit was when terminated."}),"\n",(0,l.jsx)(t.h2,{id:"restoration-id",children:"Restoration ID"}),"\n",(0,l.jsxs)(t.p,{children:["For the most part all you need to do to restore the state of your\ncells is to provide a ",(0,l.jsx)(t.code,{children:"restorationId"})," when creating the ",(0,l.jsx)(t.code,{children:"CellWidget"}),"\nor ",(0,l.jsx)(t.code,{children:"StaticWidget"}),". The ",(0,l.jsx)(t.code,{children:"restorationId"})," associates the saved state with\nthe widget, See\n",(0,l.jsx)(t.a,{href:"https://api.flutter.dev/flutter/widgets/RestorationMixin/restorationId.html",children:(0,l.jsx)(t.code,{children:"RestorationMixin.restorationId"})}),",\nfor more information."]}),"\n",(0,l.jsxs)(t.p,{children:["When a ",(0,l.jsx)(t.code,{children:"restorationId"})," is given to ",(0,l.jsx)(t.code,{children:"CellWidget.builder"}),", the state of\nthe cells created using ",(0,l.jsx)(t.code,{children:"BuildContext.cell"})," will be saved and restored\nautomatically."]}),"\n",(0,l.jsx)(t.p,{children:"Here is a simple example:"}),"\n",(0,l.jsx)(t.pre,{children:(0,l.jsx)(t.code,{className:"language-dart",metastring:'title="Cell state restoration using CellWidget"',children:"Widget example() => CellWidget.builder((ctx) {\n    final sliderValue = ctx.cell(() => MutableCell(0.0));\n    final switchValue = ctx.cell(() => MutableCell(false));\n    final checkboxValue = ctx.cell(() => MutableCell(true));\n\n    final textValue = ctx.cell(() => MutableCell(''));\n\n    return Column(\n      children: [\n        Text('A Slider'),\n        Row(\n          children: [\n            CellWidget.builder((context) => Text(sliderValue().toStringAsFixed(2))),\n            Expanded(\n              child: CellSlider(\n                 min: 0.0.cell,\n                 max: 10.cell,\n                 value: sliderValue\n              ),\n            )\n          ],\n        ),\n        CellSwitchListTile(\n          value: switchValue,\n          title: Text('A Switch').cell,\n        ),\n        CellCheckboxListTile(\n          value: checkboxValue,\n          title: Text('A checkbox').cell,\n        ),\n        const Text('Enter some text:'),\n        CellTextField(content: textValue),\n        CellWidget.builder((context) => Text('You wrote: ${textValue()}')),\n      ],\n    );\n  },\n  \n  restorationId: 'cell_restoration_example'\n);\n"})}),"\n",(0,l.jsxs)(t.p,{children:["Notice the ",(0,l.jsx)(t.code,{children:"restorationId"})," argument, provided after the widget builder\nfunction."]}),"\n",(0,l.jsx)(t.admonition,{type:"tip",children:(0,l.jsxs)(t.p,{children:["If you're subclassing ",(0,l.jsx)(t.code,{children:"CellWidget"}),", provide the ",(0,l.jsx)(t.code,{children:"restorationId"})," in the\ncall to the super class constructor."]})}),"\n",(0,l.jsxs)(t.p,{children:["The ",(0,l.jsx)(t.code,{children:"build"})," method defines four widgets, a slider, a switch, a\ncheckbox and a text field as well as four cells, creating using ",(0,l.jsx)(t.code,{children:"cell"}),"\nfor holding the state of the widgets. The code defining the cells is\nexactly the same as it would be without state restoration, however\nwhen the app is resumed the state of the cells, and likewise the\nwidgets which are dependent on the cells, is restored."]}),"\n",(0,l.jsx)(t.admonition,{type:"info",children:(0,l.jsxs)(t.ul,{children:["\n",(0,l.jsxs)(t.li,{children:[(0,l.jsx)(t.code,{children:"CellSlider"}),", ",(0,l.jsx)(t.code,{children:"CellSwitchListTile"})," and ",(0,l.jsx)(t.code,{children:"CellCheckboxListTile"})," are\nthe live cell equivalents, provided by ",(0,l.jsx)(t.code,{children:"live_cell_widgets"}),", of\n",(0,l.jsx)(t.code,{children:"Slider"}),", ",(0,l.jsx)(t.code,{children:"SwitchListTile"})," and ",(0,l.jsx)(t.code,{children:"CheckboxListTile"})," which allow their\nstate to be controlled by a ",(0,l.jsx)(t.code,{children:"ValueCell"}),"."]}),"\n",(0,l.jsxs)(t.li,{children:["You can use any widgets not just those provided by\n",(0,l.jsx)(t.code,{children:"live_cell_widgets"}),". The state of the cells defined by\n",(0,l.jsx)(t.code,{children:"RestorableCellWidget.cell"})," will be restored regardless of the\nwidgets you use."]}),"\n"]})}),"\n",(0,l.jsx)(t.p,{children:"In order for cell state restoration to be successful, the following has to be taken into account:"}),"\n",(0,l.jsxs)(t.ul,{children:["\n",(0,l.jsxs)(t.li,{children:["Only cells implementing the ",(0,l.jsx)(t.code,{children:"RestorableCell"})," interface can have\ntheir state restored. All cells provided by ",(0,l.jsx)(t.strong,{children:"Live Cells"})," implement\nthis interface except:","\n",(0,l.jsxs)(t.ul,{children:["\n",(0,l.jsxs)(t.li,{children:[(0,l.jsx)(t.em,{children:"Lightweight computed cells"}),", which do not have a state"]}),"\n",(0,l.jsx)(t.li,{children:(0,l.jsx)(t.code,{children:"DelayCell"})}),"\n"]}),"\n"]}),"\n",(0,l.jsxs)(t.li,{children:["The values of the cells to be restored must be encodable by\n",(0,l.jsx)(t.code,{children:"StandardMessageCodec"}),". This means that only cells holding primitive\nvalues (",(0,l.jsx)(t.code,{children:"num"}),", ",(0,l.jsx)(t.code,{children:"bool"}),", ",(0,l.jsx)(t.code,{children:"null"}),", ",(0,l.jsx)(t.code,{children:"String"}),", ",(0,l.jsx)(t.code,{children:"List"}),", ",(0,l.jsx)(t.code,{children:"Map"}),") can have\ntheir state saved and restored."]}),"\n",(0,l.jsxs)(t.li,{children:["To support state restoration of cells holding values not supported\nby ",(0,l.jsx)(t.code,{children:"StandardMessageCodec"}),", a ",(0,l.jsx)(t.code,{children:"CellValueCoder"})," has to be provided."]}),"\n"]}),"\n",(0,l.jsx)(t.admonition,{type:"important",children:(0,l.jsxs)(t.p,{children:["If a cell holds a non-restorable value pass ",(0,l.jsx)(t.code,{children:"restorable: false"})," to\n",(0,l.jsx)(t.code,{children:".cell(...)"}),". This prevents the cell's state from being saved and restored."]})}),"\n",(0,l.jsx)(t.h2,{id:"user-defined-types",children:"User-Defined Types"}),"\n",(0,l.jsxs)(t.p,{children:[(0,l.jsx)(t.code,{children:"CellValueCoder"})," is an interface for encoding (and decoding) a value to a primitive value\nrepresentation that is supported by ",(0,l.jsx)(t.code,{children:"StandardMessageCodec"}),". Two methods have to be implemented:"]}),"\n",(0,l.jsxs)(t.ul,{children:["\n",(0,l.jsxs)(t.li,{children:[(0,l.jsx)(t.code,{children:"encode()"})," which takes a value and encodes it to a primitive value representation"]}),"\n",(0,l.jsxs)(t.li,{children:[(0,l.jsx)(t.code,{children:"decode()"})," which decodes a value from its primitive value representation"]}),"\n"]}),"\n",(0,l.jsxs)(t.p,{children:["The following example demonstrates state restoration of a radio button\ngroup using a ",(0,l.jsx)(t.code,{children:"CellValueCoder"})," to encode the ",(0,l.jsx)(t.em,{children:"group value"})," which is an\n",(0,l.jsx)(t.code,{children:"enum"}),"."]}),"\n",(0,l.jsx)(t.pre,{children:(0,l.jsx)(t.code,{className:"language-dart",metastring:'title="CellValueCoder example"',children:"enum RadioValue {\n  value1,\n  value2,\n  value3\n}\n\nclass RadioValueCoder implements CellValueCoder {\n  @override\n  RadioValue? decode(Object? primitive) {\n    if (primitive != null) {\n      final name = primitive as String;\n      return RadioValue.values.byName(name);\n    }\n\n    return null;\n  }\n\n  @override\n  Object? encode(covariant RadioValue? value) {\n    return value?.name;\n  }\n}\n\nWidget example() => CellWidget.builder((ctx) => {\n    final radioValue = cell(\n       () => MutableCell<RadioValue?>(RadioValue.value1),\n       coder: RadioValueCoder.new\n    );\n\n    return Column(\n      children: [\n        const Text('Radio Buttons:',),\n        CellWidget.builder((context) => Text('Selected option: ${radioValue()?.name}')),\n        Column(\n          children: [\n            CellRadioListTile(\n              groupValue: radioValue,\n              value: RadioValue.value1.cell,\n              title: Text('value1').cell,\n            ),\n            CellRadioListTile(\n              groupValue: radioValue,\n              value: RadioValue.value2.cell,\n              title: Text('value2').cell,\n            ),\n            CellRadioListTile(\n              groupValue: radioValue,\n              value: RadioValue.value3.cell,\n              title: Text('value3').cell,\n            ),\n          ],\n        ),\n      ],\n    );\n  },\n  \n  restorationId: 'cell_restoration_example'\n);\n"})}),"\n",(0,l.jsxs)(t.p,{children:[(0,l.jsx)(t.code,{children:"RadioValueCoder"})," is a ",(0,l.jsx)(t.code,{children:"CellValueCoder"})," subclass which encodes the\n",(0,l.jsx)(t.code,{children:"RadioValue"})," enum class to a string. In the definition of the\n",(0,l.jsx)(t.code,{children:"radioValue"})," cell, the constructor of ",(0,l.jsx)(t.code,{children:"RadioValueCoder"}),"\n(",(0,l.jsx)(t.code,{children:"RadioValueCoder.new"}),") is provided to ",(0,l.jsx)(t.code,{children:"cell()"})," in the ",(0,l.jsx)(t.code,{children:"coder"}),"\nargument."]}),"\n",(0,l.jsx)(t.h2,{id:"state-restoration-in-staticwidget",children:"State Restoration in StaticWidget"}),"\n",(0,l.jsxs)(t.p,{children:["Like with ",(0,l.jsx)(t.code,{children:"CellWidget"}),", to achieve cell state restoration inside a\n",(0,l.jsx)(t.code,{children:"StaticWidget"})," a ",(0,l.jsx)(t.code,{children:"restorationId"})," has to be provided when creating the\nwidget. Unlike ",(0,l.jsx)(t.code,{children:"CellWidget"}),", where cells are created using the ",(0,l.jsx)(t.code,{children:"cell"}),"\nmethod, the ",(0,l.jsx)(t.code,{children:"restore"})," method has to be called on all cells which need\nto have their state restored."]}),"\n",(0,l.jsxs)(t.p,{children:["The ",(0,l.jsx)(t.code,{children:"CellRadio"})," example using ",(0,l.jsx)(t.code,{children:"StaticWidget"}),":"]}),"\n",(0,l.jsx)(t.pre,{children:(0,l.jsx)(t.code,{className:"language-dart",metastring:'title="State Restoration using StaticWidget"',children:"Widget example() => StaticWidget.builder((_) => {\n    final radioValue = MutableCell<RadioValue?>(RadioValue.value1)\n        .restore(coder: RadioValueCoder());\n\n    return Column(\n      children: [\n        const Text('Radio Buttons:',),\n        CellWidget.builder((context) => Text('Selected option: ${radioValue()?.name}')),\n        Column(\n          children: [\n            CellRadioListTile(\n              groupValue: radioValue,\n              value: RadioValue.value1.cell,\n              title: Text('value1').cell,\n            ),\n            CellRadioListTile(\n              groupValue: radioValue,\n              value: RadioValue.value2.cell,\n              title: Text('value2').cell,\n            ),\n            CellRadioListTile(\n              groupValue: radioValue,\n              value: RadioValue.value3.cell,\n              title: Text('value3').cell,\n            ),\n          ],\n        ),\n      ],\n    );\n  },\n  \n  restorationId: 'cell_restoration_example'\n);\n"})}),"\n",(0,l.jsx)(t.admonition,{type:"tip",children:(0,l.jsxs)(t.p,{children:["If you're subclassing ",(0,l.jsx)(t.code,{children:"StaticWidget"}),", provide the ",(0,l.jsx)(t.code,{children:"restorationId"})," in the\ncall to the super class constructor."]})}),"\n",(0,l.jsx)(t.admonition,{title:"Important",type:"danger",children:(0,l.jsxs)(t.p,{children:["The ",(0,l.jsx)(t.code,{children:"restore()"})," method should only be called directly within a\n",(0,l.jsx)(t.code,{children:"CellWidget"})," or ",(0,l.jsx)(t.code,{children:"StaticWidget"})," with a non-null ",(0,l.jsx)(t.code,{children:"restorationId"}),"."]})}),"\n",(0,l.jsx)(t.h2,{id:"recomputed-cell-state",children:"Recomputed Cell State"}),"\n",(0,l.jsx)(t.p,{children:"If a cell's value is not restored, its value is recomputed. As a\nresult, it is not necessary to save the value of a cell, if it can be\nrecomputed."}),"\n",(0,l.jsx)(t.p,{children:"Example:"}),"\n",(0,l.jsx)(t.pre,{children:(0,l.jsx)(t.code,{className:"language-dart",metastring:'title="Recomputed Cell State"',children:"Widget example() => StaticWidget.builder((_) {\n    final numValue = MutableCell<num>(1).restore();\n    final numMaybe = numValue.maybe();\n    final numError = numMaybe.error;\n\n    final numStr = numMaybe.mutableString()\n        .restore();\n\n    return Column(\n      children: [\n        const Text('Text field for numeric input:'),\n        CellTextField(\n          content: numStr,\n          decoration: ValueCell.computed(() => InputDecoration(\n            errorText: numError() != null\n               ? 'Not a valid number'\n               : null\n          )),\n        ),\n        const SizedBox(height: 10),\n        CellWidget.builder((context) {\n          final a1 = context.cell(() => numValue + 1.cell);\n          return Text('${numValue()} + 1 = ${a1()}');\n        }),\n        ElevatedButton(\n          child: const Text('Reset'),\n          onPressed: () => numValue.value = 1\n        )\n      ],\n    );\n  },\n  \n  restorationId: 'cell_restoration_example'\n);\n"})}),"\n",(0,l.jsxs)(t.p,{children:["The above is an example of a text field for numeric input with error\nhandling. The only cells in the above example which have their state\nrestored are ",(0,l.jsx)(t.code,{children:"numValue"}),", the cell holding the numeric value that was\nentered in the field, and ",(0,l.jsx)(t.code,{children:"numMaybe.mutableString()"})," which is the\n",(0,l.jsx)(t.em,{children:"content"})," cell for the text field. When the state of the app is\nrestored the values of the remaining cells are recomputed, which\nin-effect restores their state without it actually being saved."]}),"\n",(0,l.jsx)(t.p,{children:"When you leave the app and return to it, you'll see the exact same\nstate, including erroneous input and the associated error message, as\nwhen you left."}),"\n",(0,l.jsx)(t.p,{children:"Some points to note from this example:"}),"\n",(0,l.jsxs)(t.ul,{children:["\n",(0,l.jsxs)(t.li,{children:["\n",(0,l.jsxs)(t.p,{children:["The ",(0,l.jsx)(t.code,{children:"restore"})," method is called only on those cells we want to have\ntheir state restored."]}),"\n"]}),"\n",(0,l.jsxs)(t.li,{children:["\n",(0,l.jsxs)(t.p,{children:["Computed cells don't require their state to be saved, e.g. the state\nof the ",(0,l.jsx)(t.code,{children:"a1"})," cell is not saved, however it is ",(0,l.jsx)(t.em,{children:"restored"})," (the same\nstate is recomputed on launch) nevertheless."]}),"\n"]}),"\n"]}),"\n",(0,l.jsxs)(t.p,{children:["As a general rule of thumb only mutable cells which are either set\ndirectly, such as ",(0,l.jsx)(t.code,{children:"numValue"}),' which has its value set in the "Reset"\nbutton, or hold user input from widgets, such as the content cells of\ntext fields, are required to have their state saved.']})]})}function h(e={}){const{wrapper:t}={...(0,i.R)(),...e.components};return t?(0,l.jsx)(t,{...e,children:(0,l.jsx)(c,{...e})}):c(e)}},8453:(e,t,n)=>{n.d(t,{R:()=>o,x:()=>r});var l=n(6540);const i={},s=l.createContext(i);function o(e){const t=l.useContext(s);return l.useMemo((function(){return"function"==typeof e?e(t):{...t,...e}}),[t,e])}function r(e){let t;return t=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:o(e.components),l.createElement(s.Provider,{value:t},e.children)}}}]);