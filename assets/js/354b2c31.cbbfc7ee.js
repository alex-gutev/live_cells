"use strict";(self.webpackChunkmy_website_2=self.webpackChunkmy_website_2||[]).push([[800],{2851:(e,l,n)=>{n.r(l),n.d(l,{assets:()=>r,contentTitle:()=>d,default:()=>a,frontMatter:()=>t,metadata:()=>c,toc:()=>h});var i=n(4848),s=n(8453);const t={title:"Lists, Maps and Sets",description:"Working with cells holding lists, maps and sets",sidebar_position:9},d="Lists, Maps and Sets",c={id:"basics/lists-maps-sets",title:"Lists, Maps and Sets",description:"Working with cells holding lists, maps and sets",source:"@site/docs/basics/lists-maps-sets.md",sourceDirName:"basics",slug:"/basics/lists-maps-sets",permalink:"/docs/basics/lists-maps-sets",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:9,frontMatter:{title:"Lists, Maps and Sets",description:"Working with cells holding lists, maps and sets",sidebar_position:9},sidebar:"tutorialSidebar",previous:{title:"User Defined Types",permalink:"/docs/basics/user-defined-types"},next:{title:"Asynchronous Cells",permalink:"/docs/basics/async-cells"}},r={},h=[{value:"Indexing",id:"indexing",level:2},{value:"Iterable Properties",id:"iterable-properties",level:2},{value:"cellList Property",id:"celllist-property",level:2},{value:"Map and Set Properties",id:"map-and-set-properties",level:2}];function o(e){const l={admonition:"admonition",code:"code",h1:"h1",h2:"h2",li:"li",ol:"ol",p:"p",pre:"pre",ul:"ul",...(0,s.R)(),...e.components};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(l.h1,{id:"lists-maps-and-sets",children:"Lists, Maps and Sets"}),"\n",(0,i.jsxs)(l.p,{children:["Live Cells provides extensions for cells holding ",(0,i.jsx)(l.code,{children:"List"}),"s, ",(0,i.jsx)(l.code,{children:"Map"}),"s and\n",(0,i.jsx)(l.code,{children:"Set"}),"s, which allow the properties of the ",(0,i.jsx)(l.code,{children:"List"}),", ",(0,i.jsx)(l.code,{children:"Map"})," and ",(0,i.jsx)(l.code,{children:"Set"}),"\ninterfaces to be accessed directly on cells."]}),"\n",(0,i.jsx)(l.h2,{id:"indexing",children:"Indexing"}),"\n",(0,i.jsxs)(l.p,{children:["For example the ",(0,i.jsx)(l.code,{children:"[]"})," operator is overloaded for cells holding ",(0,i.jsx)(l.code,{children:"Lists"}),",\nwhich allows a list element to be retrieved."]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",metastring:'title="List cell operator[] example"',children:"final list = MutableCell([1, 2, 3, 4]);\nfinal index = MutableCell(0);\n\n/// A cell which accesses the element at `index`\nfinal element = list[index];\n"})}),"\n",(0,i.jsxs)(l.p,{children:["The ",(0,i.jsx)(l.code,{children:"element"})," cell retrieves the value of the element at ",(0,i.jsx)(l.code,{children:"index"}),"\nwithin ",(0,i.jsx)(l.code,{children:"list"}),". You'll notice that the definition of the ",(0,i.jsx)(l.code,{children:"element"})," cell\nlooks exactly like retrieving the value of an element from an ordinary\n",(0,i.jsx)(l.code,{children:"List"}),". However, unlike an ordinarily ",(0,i.jsx)(l.code,{children:"List"})," element access, ",(0,i.jsx)(l.code,{children:"element"}),"\nis a cell and its value will be recomputed whenever the ",(0,i.jsx)(l.code,{children:"list"})," and\n",(0,i.jsx)(l.code,{children:"index"}),", which is also a cell, change:"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",metastring:'title="Reactive list element access"',children:"print(element.value); // 1\n\nelement.value = 2;\nprint(element.value); // 3\n\nlist.value = [3, 9, 27];\nprint(element.value); // 27\n"})}),"\n",(0,i.jsxs)(l.p,{children:["The ",(0,i.jsx)(l.code,{children:"element"})," cell is also a mutable cell which when set, updates the\nvalue of the ",(0,i.jsx)(l.code,{children:"list"})," element at ",(0,i.jsx)(l.code,{children:"index"}),"."]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",metastring:'title="Modifying list through an element access cell"',children:"final list = MutableCell([1, 2, 3, 4]);\nfinal index = MutableCell(0);\n\nfinal element = list[index];\n\nindex.value = 1;\nelement.value = 100;\n\nprint(list); // 1, 100, 3, 4\n"})}),"\n",(0,i.jsx)(l.admonition,{type:"note",children:(0,i.jsxs)(l.p,{children:["The underlying ",(0,i.jsx)(l.code,{children:"List"})," is not modified but a new ",(0,i.jsx)(l.code,{children:"List"})," is created and\nassigned to the ",(0,i.jsx)(l.code,{children:"list"})," cell."]})}),"\n",(0,i.jsxs)(l.p,{children:["You can also update the ",(0,i.jsx)(l.code,{children:"list"})," element directly using ",(0,i.jsx)(l.code,{children:"[]="}),":"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"list[1] = 100;\n"})}),"\n",(0,i.jsx)(l.admonition,{type:"note",children:(0,i.jsxs)(l.p,{children:["Unlike the ",(0,i.jsx)(l.code,{children:"[]"})," operator, the index provided to the ",(0,i.jsx)(l.code,{children:"[]="})," operator is\na value not a cell."]})}),"\n",(0,i.jsx)(l.h2,{id:"iterable-properties",children:"Iterable Properties"}),"\n",(0,i.jsxs)(l.p,{children:["Cells holding ",(0,i.jsx)(l.code,{children:"Iterable"})," values provide the following properties and\nmethods:"]}),"\n",(0,i.jsxs)(l.ul,{children:["\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"first"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"last"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"isEmpty"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"isNotEmpty"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"length"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"single"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"toList()"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"toSet()"})}),"\n"]}),"\n",(0,i.jsxs)(l.p,{children:["Each property/method returns a cell which applies the property\ngetter/method on the ",(0,i.jsx)(l.code,{children:"Iterable"})," held in the cell. This allows you, for\nexample, to retrieve the first value in an ",(0,i.jsx)(l.code,{children:"Iterable"}),", be it a ",(0,i.jsx)(l.code,{children:"List"}),",\n",(0,i.jsx)(l.code,{children:"Set"}),", etc., held in a cell, using:"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"ValueCell<Iterable> seq;\n...\nfinal first = seq.first\n"})}),"\n",(0,i.jsx)(l.p,{children:"This is roughly equivalent to:"}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"final first = ValueCell.computed(() => seq().first);\n"})}),"\n",(0,i.jsx)(l.h2,{id:"celllist-property",children:"cellList Property"}),"\n",(0,i.jsxs)(l.p,{children:["The ",(0,i.jsx)(l.code,{children:"cellList"})," property, of cells holding ",(0,i.jsx)(l.code,{children:"Lists"}),", returns a cell\nwhich evaluates to an ",(0,i.jsx)(l.code,{children:"Iterable"})," of cells, with each cell accessing\nthe value of an element in the original ",(0,i.jsx)(l.code,{children:"List"}),":"]}),"\n",(0,i.jsx)(l.p,{children:"For example, consider the following cell:"}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"// A list with four elements\nfinal list = MutableCell([1, 2, 3, 4]);\n"})}),"\n",(0,i.jsxs)(l.p,{children:[(0,i.jsx)(l.code,{children:"list.cellList"})," returns a cell which holds the following list of cells:"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"final cellList = list.cellList;\n\n// cellList.value is equivalent to the following:\n[list[0], list[1], list[2], list[3]]\n"})}),"\n",(0,i.jsxs)(l.p,{children:[(0,i.jsx)(l.code,{children:"cellList"})," is reactive, like any other cell, and its value will\nlikewise change whenever the value of ",(0,i.jsx)(l.code,{children:"list"})," changes. So what's the\npoint? Unlike ",(0,i.jsx)(l.code,{children:"list"}),", ",(0,i.jsx)(l.code,{children:"cellList"})," only reacts to changes in the\n",(0,i.jsx)(l.code,{children:"length"})," of the list, i.e. when the number of elements in the list\nchange, and not the values of the elements themselves."]}),"\n",(0,i.jsxs)(l.p,{children:["You can test this out using ",(0,i.jsx)(l.code,{children:"ValueCell.watch"}),":"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"ValueCell.watch(() {\n    print('${cellList().length} elements');\n});\n"})}),"\n",(0,i.jsxs)(l.p,{children:["The following will not cause ",(0,i.jsx)(l.code,{children:"cellList"})," to be recomputed:"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"// Doesn't print anything since the \n// number of elements hasn't changed\nlist.value = [5, 6, 7, 8];\n\nlist[0] = 100;\nlist[2] = -1;\n"})}),"\n",(0,i.jsxs)(l.p,{children:["However the following will cause ",(0,i.jsx)(l.code,{children:"cellList"})," to be recomputed:"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"// Prints: 3 elements\nlist.value = [1, 2, 3]\n\n// Prints: 0 elements\nlist.value = [];\n\n// Prints: 7 elements\nlist.value = [1, 2, 3, 4, 5, 6, 7];\n"})}),"\n",(0,i.jsxs)(l.p,{children:["This is particularly useful for constructing a ",(0,i.jsx)(l.code,{children:"Column"})," or ",(0,i.jsx)(l.code,{children:"Row"}),"\nwidget using a list of child widgets held in a cell:"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"ValueCell<List<Widget>> children;\n\nCellWidget.builder((_) => Column(\n  children: children.cellList()\n      .map((c) => c.widget())\n      .toList()\n);\n"})}),"\n",(0,i.jsx)(l.admonition,{type:"info",children:(0,i.jsxs)(l.p,{children:["The ",(0,i.jsx)(l.code,{children:"ValueCell.widget()"}),", available on cells holding ",(0,i.jsx)(l.code,{children:"Widget"}),"s,\nreturns the ",(0,i.jsx)(l.code,{children:"Widget"})," held in the cell. Unlike retrieving the ",(0,i.jsx)(l.code,{children:"Widget"}),"\ndirectly with ",(0,i.jsx)(l.code,{children:".value"}),", the returned widget is rebuilt whenever the\nvalue of the cell changes."]})}),"\n",(0,i.jsx)(l.p,{children:"Here's what's going on in the example above:"}),"\n",(0,i.jsxs)(l.ol,{children:["\n",(0,i.jsxs)(l.li,{children:[(0,i.jsx)(l.code,{children:"children"})," is a cell holding the list of child ",(0,i.jsx)(l.code,{children:"Widgets"})]}),"\n",(0,i.jsxs)(l.li,{children:[(0,i.jsx)(l.code,{children:"cellList"})," is used to retrieve a cell that is only recomputed when\nthe ",(0,i.jsx)(l.code,{children:"length"})," of ",(0,i.jsx)(l.code,{children:"children"}),"."]}),"\n",(0,i.jsxs)(l.li,{children:["As a result the ",(0,i.jsx)(l.code,{children:"CellWidget"}),", holding the ",(0,i.jsx)(l.code,{children:"Column"}),", is only\nrebuilt, when the size of ",(0,i.jsx)(l.code,{children:"children"})," changes."]}),"\n",(0,i.jsxs)(l.li,{children:["The list (",(0,i.jsx)(l.code,{children:"Iterable"}),") of cells held in ",(0,i.jsx)(l.code,{children:"cellList"})," is converted to a\nlist of ",(0,i.jsx)(l.code,{children:"Widgets"})," by applying the ",(0,i.jsx)(l.code,{children:"widget()"})," method on each cell in the\nlist."]}),"\n"]}),"\n",(0,i.jsxs)(l.p,{children:["As a result modifying an element of the ",(0,i.jsx)(l.code,{children:"children"})," list, will only\nresult in that child widget of the ",(0,i.jsx)(l.code,{children:"Column"})," being rebuilt and not the\nentire widget hierarchy rooted at the ",(0,i.jsx)(l.code,{children:"Column"}),"."]}),"\n",(0,i.jsxs)(l.p,{children:["You wont need ",(0,i.jsx)(l.code,{children:"cellList"})," for this as Live Cells already provides a\n",(0,i.jsx)(l.code,{children:"CellColumn"})," and a ",(0,i.jsx)(l.code,{children:"CellRow"}),", which is implemented exactly as\ndescribed above, but its still useful to be aware of this pattern so\nyou can potentially apply it in other parts of your app which deal\nwith lists."]}),"\n",(0,i.jsxs)(l.p,{children:["This makes surgical updates to a complex widget hierarchy simple and\nintuitive. For example consider the following widget definition, using\n",(0,i.jsx)(l.code,{children:"CellColumn"}),":"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",metastring:'title="CellColumn example"',children:"final children = MutableCell(<Widget>[\n    Text('Child 1'),\n    Text('Child 2'),\n    Text('Child 3')\n]);\n\nreturn CellColumn(\n    children: children\n);\n"})}),"\n",(0,i.jsx)(l.p,{children:"Changing the second child widget is as simple as:"}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"children[1] = Text('Updated Child 2');\n"})}),"\n",(0,i.jsxs)(l.p,{children:["With this only the second child widget of the ",(0,i.jsx)(l.code,{children:"Column"})," is rebuilt."]}),"\n",(0,i.jsx)(l.h2,{id:"map-and-set-properties",children:"Map and Set Properties"}),"\n",(0,i.jsxs)(l.p,{children:["The following properties and methods are provided by cells holding\n",(0,i.jsx)(l.code,{children:"Map"})," values:"]}),"\n",(0,i.jsxs)(l.ul,{children:["\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"entries"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"keys"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"values"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"isEmpty"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"isNotEmpty"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"length"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"containsKey()"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"containsValue()"})}),"\n"]}),"\n",(0,i.jsxs)(l.p,{children:["Much like the with cells holding ",(0,i.jsx)(l.code,{children:"List"})," values, these properties and\nmethods return cells which apply the property getter/method on the\n",(0,i.jsx)(l.code,{children:"List"})," held in the cell."]}),"\n",(0,i.jsxs)(l.p,{children:["The indexing operator ",(0,i.jsx)(l.code,{children:"[]"})," is also provided, which takes a cell for the key:"]}),"\n",(0,i.jsx)(l.pre,{children:(0,i.jsx)(l.code,{className:"language-dart",children:"final map = MutableCell({\n    'k1': 1,\n    'k2': 2,\n    'k3': 3\n});\n\nfinal key = MutableCell('k1');\nfinal element = map[key];\n\nprint(element.value); // 1\n\nelement.value = 100;\nprint(map.value['k1']); // 100\n\nkey.value = 'k3';\nprint(element.value); // 3\n\nkey.value = 'not in map';\nprint(element.value); // null\n"})}),"\n",(0,i.jsxs)(l.p,{children:["Setting the value of a cell created by ",(0,i.jsx)(l.code,{children:"[]"}),", updates the value of the\nentry in the ",(0,i.jsx)(l.code,{children:"Map"})," cell. Like with cells holding ",(0,i.jsx)(l.code,{children:"List"}),"s, the actual\n",(0,i.jsx)(l.code,{children:"Map"})," instance is not modified, but a new ",(0,i.jsx)(l.code,{children:"Map"}),", with the updated\nentry, is created and assigned to the ",(0,i.jsx)(l.code,{children:"Map"})," cell."]}),"\n",(0,i.jsxs)(l.p,{children:["The following methods are provided by cells holding ",(0,i.jsx)(l.code,{children:"Set"})," values:"]}),"\n",(0,i.jsxs)(l.ul,{children:["\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"contains"})}),"\n",(0,i.jsx)(l.li,{children:(0,i.jsx)(l.code,{children:"containsAll"})}),"\n"]}),"\n",(0,i.jsxs)(l.p,{children:["Given that a ",(0,i.jsx)(l.code,{children:"Set"})," is an ",(0,i.jsx)(l.code,{children:"Iterable"}),", all the properties provided by\ncells holding ",(0,i.jsx)(l.code,{children:"Iterables"})," are also provided by cells holding ",(0,i.jsx)(l.code,{children:"Sets"}),"."]})]})}function a(e={}){const{wrapper:l}={...(0,s.R)(),...e.components};return l?(0,i.jsx)(l,{...e,children:(0,i.jsx)(o,{...e})}):o(e)}},8453:(e,l,n)=>{n.d(l,{R:()=>d,x:()=>c});var i=n(6540);const s={},t=i.createContext(s);function d(e){const l=i.useContext(t);return i.useMemo((function(){return"function"==typeof e?e(l):{...l,...e}}),[l,e])}function c(e){let l;return l=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:d(e.components),i.createElement(t.Provider,{value:l},e.children)}}}]);