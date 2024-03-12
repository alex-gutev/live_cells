"use strict";(self.webpackChunkmy_website_2=self.webpackChunkmy_website_2||[]).push([[775],{8372:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>a,contentTitle:()=>r,default:()=>h,frontMatter:()=>s,metadata:()=>o,toc:()=>d});var l=t(4848),i=t(8453);const s={title:"State Restoration",description:"How to save and restore the state of cells",sidebar_position:7},r="State Restoration",o={id:"basics/state-restoration",title:"State Restoration",description:"How to save and restore the state of cells",source:"@site/docs/basics/state-restoration.md",sourceDirName:"basics",slug:"/basics/state-restoration",permalink:"/docs/basics/state-restoration",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:7,frontMatter:{title:"State Restoration",description:"How to save and restore the state of cells",sidebar_position:7},sidebar:"tutorialSidebar",previous:{title:"Error Handling",permalink:"/docs/basics/error-handling"},next:{title:"User Defined Types",permalink:"/docs/basics/user-defined-types"}},a={},d=[{value:"Restoration ID",id:"restoration-id",level:2},{value:"User-Defined Types",id:"user-defined-types",level:2},{value:"Recomputed Cell State",id:"recomputed-cell-state",level:2}];function c(e){const n={a:"a",admonition:"admonition",code:"code",em:"em",h1:"h1",h2:"h2",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,i.R)(),...e.components};return(0,l.jsxs)(l.Fragment,{children:[(0,l.jsx)(n.h1,{id:"state-restoration",children:"State Restoration"}),"\n",(0,l.jsx)(n.p,{children:"A mobile application may be terminated at any point when the user is\nnot interacting with it. When it is resumed, due to the user\nnavigating back to it, it should restore its state to the point where\nit was when terminated."}),"\n",(0,l.jsx)(n.h2,{id:"restoration-id",children:"Restoration ID"}),"\n",(0,l.jsxs)(n.p,{children:["For the most part all you need to do to restore the state of your\ncells is to provide a ",(0,l.jsx)(n.code,{children:"restorationId"})," when creating the ",(0,l.jsx)(n.code,{children:"CellWidget"}),",\nand call ",(0,l.jsx)(n.code,{children:".restore()"})," on your cells. The ",(0,l.jsx)(n.code,{children:"restorationId"})," associates\nthe saved state with the widget, See\n",(0,l.jsx)(n.a,{href:"https://api.flutter.dev/flutter/widgets/RestorationMixin/restorationId.html",children:(0,l.jsx)(n.code,{children:"RestorationMixin.restorationId"})}),",\nfor more information."]}),"\n",(0,l.jsxs)(n.p,{children:["When a ",(0,l.jsx)(n.code,{children:"restorationId"})," is given to ",(0,l.jsx)(n.code,{children:"CellWidget.builder"}),", the state of\nthe cells created within the build function will be saved and restored\nautomatically."]}),"\n",(0,l.jsx)(n.p,{children:"Here is a simple example:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",metastring:'title="Cell state restoration using CellWidget"',children:"CellWidget.builder((ctx) {\n  final sliderValue = MutableCell(0.0).restore();\n  final switchValue = MutableCell(false).restore();\n  final checkboxValue = MutableCell(true).restore();\n\n  final textValue = MutableCell('').restore();\n\n  return Column(\n    children: [\n      Text('A Slider'),\n      Row(\n        children: [\n          CellWidget.builder((context) => Text(sliderValue().toStringAsFixed(2))),\n          Expanded(\n            child: CellSlider(\n               min: 0.0.cell,\n               max: 10.cell,\n               value: sliderValue\n            ),\n          )\n        ],\n      ),\n      CellSwitchListTile(\n        value: switchValue,\n        title: Text('A Switch').cell,\n      ),\n      CellCheckboxListTile(\n        value: checkboxValue,\n        title: Text('A checkbox').cell,\n      ),\n      const Text('Enter some text:'),\n      CellTextField(content: textValue),\n      CellWidget.builder((context) => Text('You wrote: ${textValue()}')),\n    ],\n  );\n}, restorationId: 'cell_restoration_example');\n"})}),"\n",(0,l.jsxs)(n.p,{children:["Notice the ",(0,l.jsx)(n.code,{children:"restorationId"})," argument, provided after the widget builder\nfunction."]}),"\n",(0,l.jsx)(n.admonition,{type:"tip",children:(0,l.jsxs)(n.p,{children:["When subclassing ",(0,l.jsx)(n.code,{children:"CellWidget"}),", provide the ",(0,l.jsx)(n.code,{children:"restorationId"})," in the\ncall to the super class constructor."]})}),"\n",(0,l.jsxs)(n.p,{children:["The ",(0,l.jsx)(n.code,{children:"build"})," method defines four widgets, a slider, a switch, a\ncheckbox and a text field as well as four cells, created using ",(0,l.jsx)(n.code,{children:"cell"}),"\nfor holding the state of the widgets. The code defining the cells is\nalmost the same as it would be without state restoration, however\nwhen the app is resumed the state of the cells, and likewise the\nwidgets which are dependent on the cells, is restored."]}),"\n",(0,l.jsx)(n.admonition,{type:"info",children:(0,l.jsxs)(n.ul,{children:["\n",(0,l.jsxs)(n.li,{children:[(0,l.jsx)(n.code,{children:"CellSlider"}),", ",(0,l.jsx)(n.code,{children:"CellSwitchListTile"})," and ",(0,l.jsx)(n.code,{children:"CellCheckboxListTile"})," are\nthe live cell equivalents, provided by ",(0,l.jsx)(n.code,{children:"live_cell_widgets"}),", of\n",(0,l.jsx)(n.code,{children:"Slider"}),", ",(0,l.jsx)(n.code,{children:"SwitchListTile"})," and ",(0,l.jsx)(n.code,{children:"CheckboxListTile"})," which allow their\nstate to be controlled by a ",(0,l.jsx)(n.code,{children:"ValueCell"}),"."]}),"\n",(0,l.jsxs)(n.li,{children:["You can use any widgets not just those provided by\n",(0,l.jsx)(n.code,{children:"live_cell_widgets"}),". The state of the cells within ",(0,l.jsx)(n.code,{children:"CellWidget"})," on\nwhich ",(0,l.jsx)(n.code,{children:"restore()"})," is called will be restored regardless of the widgets\nyou use."]}),"\n"]})}),"\n",(0,l.jsx)(n.p,{children:"In order for cell state restoration to be successful, the following has to be taken into account:"}),"\n",(0,l.jsxs)(n.ul,{children:["\n",(0,l.jsxs)(n.li,{children:["Only cells implementing the ",(0,l.jsx)(n.code,{children:"RestorableCell"})," interface can have\ntheir state restored. All cells provided by ",(0,l.jsx)(n.strong,{children:"Live Cells"})," implement\nthis interface except:","\n",(0,l.jsxs)(n.ul,{children:["\n",(0,l.jsxs)(n.li,{children:[(0,l.jsx)(n.em,{children:"Lightweight computed cells"}),", which do not have a state"]}),"\n",(0,l.jsx)(n.li,{children:"Asynchronous cells"}),"\n"]}),"\n"]}),"\n",(0,l.jsxs)(n.li,{children:["The values of the cells must be encodable by\n",(0,l.jsx)(n.code,{children:"StandardMessageCodec"}),". This means that only cells holding primitive\nvalues (",(0,l.jsx)(n.code,{children:"num"}),", ",(0,l.jsx)(n.code,{children:"bool"}),", ",(0,l.jsx)(n.code,{children:"null"}),", ",(0,l.jsx)(n.code,{children:"String"}),", ",(0,l.jsx)(n.code,{children:"List"}),", ",(0,l.jsx)(n.code,{children:"Map"}),") can have\ntheir state saved and restored."]}),"\n",(0,l.jsxs)(n.li,{children:["To support state restoration of cells holding values not supported\nby ",(0,l.jsx)(n.code,{children:"StandardMessageCodec"}),", a ",(0,l.jsx)(n.code,{children:"CellValueCoder"})," has to be provided."]}),"\n"]}),"\n",(0,l.jsx)(n.h2,{id:"user-defined-types",children:"User-Defined Types"}),"\n",(0,l.jsxs)(n.p,{children:[(0,l.jsx)(n.code,{children:"CellValueCoder"})," is an interface for encoding (and decoding) a value to a primitive value\nrepresentation that is supported by ",(0,l.jsx)(n.code,{children:"StandardMessageCodec"}),". Two methods have to be implemented:"]}),"\n",(0,l.jsxs)(n.ul,{children:["\n",(0,l.jsxs)(n.li,{children:[(0,l.jsx)(n.code,{children:"encode()"})," which takes a value and encodes it to a primitive value representation"]}),"\n",(0,l.jsxs)(n.li,{children:[(0,l.jsx)(n.code,{children:"decode()"})," which decodes a value from its primitive value representation"]}),"\n"]}),"\n",(0,l.jsxs)(n.p,{children:["The following example demonstrates state restoration of a radio button\ngroup using a ",(0,l.jsx)(n.code,{children:"CellValueCoder"})," to encode the ",(0,l.jsx)(n.em,{children:"group value"})," which is an\n",(0,l.jsx)(n.code,{children:"enum"}),"."]}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",metastring:'title="Example of a CellValueCoder definition"',children:"enum RadioValue {\n  value1,\n  value2,\n  value3\n}\n\nclass RadioValueCoder implements CellValueCoder {\n  @override\n  RadioValue? decode(Object? primitive) {\n    if (primitive != null) {\n      final name = primitive as String;\n      return RadioValue.values.byName(name);\n    }\n\n    return null;\n  }\n\n  @override\n  Object? encode(covariant RadioValue? value) {\n    return value?.name;\n  }\n}\n"})}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",metastring:'title="Example of state restoration with user-defined CellValueCode"',children:"\nCellWidget.builder((ctx) => {\n  final radioValue = MutableCell<RadioValue?>(RadioValue.value1)\n\t.restore(coder: RadioValueCoder.new);\n\n  return Column(\n    children: [\n      const Text('Radio Buttons:',),\n      CellWidget.builder((context) => Text('Selected option: ${radioValue()?.name}')),\n      Column(\n        children: [\n          CellRadioListTile(\n            groupValue: radioValue,\n            value: RadioValue.value1.cell,\n            title: Text('value1').cell,\n          ),\n          CellRadioListTile(\n            groupValue: radioValue,\n            value: RadioValue.value2.cell,\n            title: Text('value2').cell,\n          ),\n          CellRadioListTile(\n            groupValue: radioValue,\n            value: RadioValue.value3.cell,\n            title: Text('value3').cell,\n          ),\n        ],\n      ),\n    ],\n  );\n}, restorationId: 'cell_restoration_example');\n"})}),"\n",(0,l.jsxs)(n.p,{children:[(0,l.jsx)(n.code,{children:"RadioValueCoder"})," is a ",(0,l.jsx)(n.code,{children:"CellValueCoder"})," subclass which encodes the\n",(0,l.jsx)(n.code,{children:"RadioValue"})," enum class to a string. In the definition of the\n",(0,l.jsx)(n.code,{children:"radioValue"})," cell, the constructor of ",(0,l.jsx)(n.code,{children:"RadioValueCoder"}),"\n(",(0,l.jsx)(n.code,{children:"RadioValueCoder.new"}),") is provided to ",(0,l.jsx)(n.code,{children:"restore()"})," in the ",(0,l.jsx)(n.code,{children:"coder"}),"\nargument."]}),"\n",(0,l.jsx)(n.admonition,{title:"Important",type:"danger",children:(0,l.jsxs)(n.p,{children:["The ",(0,l.jsx)(n.code,{children:"restore()"})," method should only be called directly within a\n",(0,l.jsx)(n.code,{children:"CellWidget"})," with a non-null ",(0,l.jsx)(n.code,{children:"restorationId"}),"."]})}),"\n",(0,l.jsx)(n.h2,{id:"recomputed-cell-state",children:"Recomputed Cell State"}),"\n",(0,l.jsx)(n.p,{children:"If a cell's value is not restored, its value is recomputed. As a\nresult, it is not necessary to save the value of a cell, if it can be\nrecomputed."}),"\n",(0,l.jsx)(n.p,{children:"Example:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",metastring:'title="Recomputed Cell State"',children:"CellWidget.builder((_) {\n  final numValue = MutableCell<num>(1).restore();\n  final numMaybe = numValue.maybe();\n  final numError = numMaybe.error;\n\n  final numStr = numMaybe.mutableString()\n      .restore();\n\n  return Column(\n    children: [\n      const Text('Text field for numeric input:'),\n      CellTextField(\n        content: numStr,\n        decoration: ValueCell.computed(() => InputDecoration(\n            errorText: numError() != null\n               ? 'Not a valid number'\n               : null\n        )),\n      ),\n      const SizedBox(height: 10),\n      CellWidget.builder((context) {\n        final a1 = context.cell(() => numValue + 1.cell);\n        return Text('${numValue()} + 1 = ${a1()}');\n      }),\n      ElevatedButton(\n        child: const Text('Reset'),\n        onPressed: () => numValue.value = 1\n      )\n    ],\n  );\n}, restorationId: 'cell_restoration_example');\n"})}),"\n",(0,l.jsxs)(n.p,{children:["The above is an example of a text field for numeric input with error\nhandling. The only cells which have their state saved are\n",(0,l.jsx)(n.code,{children:"numValue"}),", the cell holding the numeric value that was entered in the\nfield, and ",(0,l.jsx)(n.code,{children:"numMaybe.mutableString()"})," which is the ",(0,l.jsx)(n.em,{children:"content"})," cell for\nthe text field. When the state of the app is restored the values of\nthe remaining cells are recomputed, which in-effect restores their\nstate without it actually being saved."]}),"\n",(0,l.jsx)(n.p,{children:"When you leave the app and return to it, you'll see the exact same\nstate, including erroneous input and the associated error message, as\nwhen you left."}),"\n",(0,l.jsx)(n.p,{children:"Some points to note from this example:"}),"\n",(0,l.jsxs)(n.ul,{children:["\n",(0,l.jsxs)(n.li,{children:["\n",(0,l.jsxs)(n.p,{children:["The ",(0,l.jsx)(n.code,{children:"restore"})," method is called only on those cells which should (and\ncan) have their state saved."]}),"\n"]}),"\n",(0,l.jsxs)(n.li,{children:["\n",(0,l.jsxs)(n.p,{children:["Computed cells don't require their state to be saved, e.g. the state\nof the ",(0,l.jsx)(n.code,{children:"a1"})," cell is not saved, however it is ",(0,l.jsx)(n.em,{children:"restored"})," (the same\nstate is recomputed on launch) nevertheless."]}),"\n"]}),"\n"]}),"\n",(0,l.jsxs)(n.p,{children:["As a general rule of thumb only mutable cells which are either set\ndirectly, such as ",(0,l.jsx)(n.code,{children:"numValue"}),' which has its value set in the "Reset"\nbutton, or hold user input from widgets, such as the content cells of\ntext fields, are required to have their state saved.']})]})}function h(e={}){const{wrapper:n}={...(0,i.R)(),...e.components};return n?(0,l.jsx)(n,{...e,children:(0,l.jsx)(c,{...e})}):c(e)}},8453:(e,n,t)=>{t.d(n,{R:()=>r,x:()=>o});var l=t(6540);const i={},s=l.createContext(i);function r(e){const n=l.useContext(s);return l.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function o(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:r(e.components),l.createElement(s.Provider,{value:n},e.children)}}}]);