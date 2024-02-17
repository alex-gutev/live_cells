"use strict";(self.webpackChunkmy_website_2=self.webpackChunkmy_website_2||[]).push([[180],{3389:(e,n,l)=>{l.r(n),l.d(n,{assets:()=>o,contentTitle:()=>c,default:()=>h,frontMatter:()=>i,metadata:()=>a,toc:()=>r});var t=l(4848),s=l(8453);const i={title:"Cells",description:"Introduction to the cell -- the basic building block of Live Cells.",sidebar_position:1},c="Cells",a={id:"basics/cells",title:"Cells",description:"Introduction to the cell -- the basic building block of Live Cells.",source:"@site/docs/basics/cells.md",sourceDirName:"basics",slug:"/basics/cells",permalink:"/docs/basics/cells",draft:!1,unlisted:!1,editUrl:"https://github.com/alex-gutev/live_cells/docs/basics/cells.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{title:"Cells",description:"Introduction to the cell -- the basic building block of Live Cells.",sidebar_position:1},sidebar:"tutorialSidebar",previous:{title:"Basics",permalink:"/docs/category/basics"},next:{title:"Cells in Widgets",permalink:"/docs/basics/cell-widgets"}},o={},r=[{value:"Mutable Cells",id:"mutable-cells",level:2},{value:"Observing Cells",id:"observing-cells",level:2},{value:"Computed Cells",id:"computed-cells",level:2},{value:"Batch Updates",id:"batch-updates",level:2}];function d(e){const n={admonition:"admonition",code:"code",em:"em",h1:"h1",h2:"h2",li:"li",ol:"ol",p:"p",pre:"pre",strong:"strong",...(0,s.R)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(n.h1,{id:"cells",children:"Cells"}),"\n",(0,t.jsxs)(n.p,{children:["A cell, denoted by the base type ",(0,t.jsx)(n.code,{children:"ValueCell"}),", is an object with a\nvalue and a set of observers that react to changes in its value,\nyou'll see exactly what that means in a moment."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Creating cells"',children:"final a = 1.cell;\nfinal b = 'hello world'.cell;\nfinal c = ValueCell.value(someValue);\n"})}),"\n",(0,t.jsxs)(n.p,{children:["The above is an example of ",(0,t.jsx)(n.em,{children:"constant cells"}),", which can be created\neither using the ",(0,t.jsx)(n.code,{children:".cell"})," property, which is added to the value types\nbuilt into Dart, or the ",(0,t.jsx)(n.code,{children:"ValueCell.value"})," constructor which takes a\nvalue and wraps it in a ",(0,t.jsx)(n.code,{children:"ValueCell"}),". A constant cell has a value that\ndoes not change throughout its lifetime."]}),"\n",(0,t.jsxs)(n.p,{children:["The value of a cell is accessed using the ",(0,t.jsx)(n.code,{children:"value"})," property."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Accessing cell values"',children:"print(a.value); // Prints: 1\nprint(b.value); // Prints: 'hello world'\nprint(c.value); // Prints the value of `someValue`\n"})}),"\n",(0,t.jsx)(n.h2,{id:"mutable-cells",children:"Mutable Cells"}),"\n",(0,t.jsxs)(n.p,{children:["Mutable cells, created with the ",(0,t.jsx)(n.code,{children:"MutableCell"})," constructor, hold a\nvalue that can be set directly, by assigning a value to the ",(0,t.jsx)(n.code,{children:"value"}),"\nproperty."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Creating mutable cells"',children:"final a = MutableCell(0);\n\nprint(a.value); // Prints: 0\n\na.value = 3;\nprint(a.value); // Prints: 3\n"})}),"\n",(0,t.jsx)(n.h2,{id:"observing-cells",children:"Observing Cells"}),"\n",(0,t.jsxs)(n.p,{children:["When the value of a cell changes, its observers are notified of the\nchange. The simplest way to demonstrate this is to set up a ",(0,t.jsx)(n.em,{children:"watch\nfunction"})," using ",(0,t.jsx)(n.code,{children:"ValueCell.watch"}),":"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Observing cells"',children:"final a = MutableCell(0);\nfinal b = MutableCell(1);\n\n// Set up a watch function observing cells `a` and `b`\nfinal watcher = ValueCell.watch(() {\n\tprint('${a()} + ${b()} = ${a() + b()}');\n});\n\na.value = 5;  // Prints: 5 + 1 = 6\nb.value = 10; // Prints: 5 + 10 = 15\n"})}),"\n",(0,t.jsxs)(n.p,{children:["In the example above, a watch function that prints the values of cells\n",(0,t.jsx)(n.code,{children:"a"})," and ",(0,t.jsx)(n.code,{children:"b"})," to the console, along with their sum, is defined. This\nfunction is called automatically when the value of either ",(0,t.jsx)(n.code,{children:"a"})," or ",(0,t.jsx)(n.code,{children:"b"}),"\nchange."]}),"\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.strong,{children:"Note"}),", the value of a cell is referenced using the function call\nsyntax, within a watch function, rather than accessing the value\nproperty directly."]}),"\n",(0,t.jsxs)(n.p,{children:["Every call to ",(0,t.jsx)(n.code,{children:"ValueCell.watch"})," adds a new watch function, for\nexample:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Multiple watch functions"',children:"final watcher2 = ValueCell.watch(() => print('A = ${a()}'));\n\n// Prints: 20 + 10 = 30\n// Also prints: A = 20\na.value = 20;\n\n// Prints: 20 + 1 = 21\nb.value = 1;\n"})}),"\n",(0,t.jsxs)(n.p,{children:["The watch function defined above, ",(0,t.jsx)(n.code,{children:"watcher2"}),", observes the value of\n",(0,t.jsx)(n.code,{children:"a"})," only. Changing the value of ",(0,t.jsx)(n.code,{children:"a"})," results in both watch functions\nbeing called. Changing the value of ",(0,t.jsx)(n.code,{children:"b"})," only results in the first\nwatch function being called, since the second watch function is not\nobserving ",(0,t.jsx)(n.code,{children:"b"}),"."]}),"\n",(0,t.jsx)(n.admonition,{type:"tip",children:(0,t.jsxs)(n.p,{children:["When you no longer need the watch function to be called, call ",(0,t.jsx)(n.code,{children:"stop"}),"\non the ",(0,t.jsx)(n.code,{children:"CellWatcher"})," object returned by ",(0,t.jsx)(n.code,{children:"ValueCell.watch"}),"."]})}),"\n",(0,t.jsx)(n.h2,{id:"computed-cells",children:"Computed Cells"}),"\n",(0,t.jsxs)(n.p,{children:["A ",(0,t.jsx)(n.em,{children:"computed cell"}),", defined using ",(0,t.jsx)(n.code,{children:"ValueCell.computed"}),", is a cell\nwith a value that is defined as a function of the values of one or\nmore argument cells. Whenever the value of an argument cell changes,\nthe value of the computed cell is recomputed."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Computed cells"',children:"final a = MutableCell(1);\nfinal b = MutableCell(2);\nfinal sum = ValueCell.computed(() => a() + b());\n"})}),"\n",(0,t.jsxs)(n.p,{children:["In the above example, ",(0,t.jsx)(n.code,{children:"sum"})," is a computed cell with the value defined\nas the sum of cells ",(0,t.jsx)(n.code,{children:"a"})," and ",(0,t.jsx)(n.code,{children:"b"}),". The value of ",(0,t.jsx)(n.code,{children:"sum"})," is recomputed\nwhenever the values of either ",(0,t.jsx)(n.code,{children:"a"})," or ",(0,t.jsx)(n.code,{children:"b"})," change. This is demonstrated\nbelow:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Computed cells"',children:"final watcher = ValueCell.watch(() {\n\tprint('The sum is ${sum()}');\n});\n\na.value = 3; // Prints: The sum is 5\nb.value = 4; // Prints: The sum is 7\n"})}),"\n",(0,t.jsx)(n.p,{children:"In this example:"}),"\n",(0,t.jsxs)(n.ol,{children:["\n",(0,t.jsxs)(n.li,{children:["A watch function observing the ",(0,t.jsx)(n.code,{children:"sum"})," cell is defined."]}),"\n",(0,t.jsxs)(n.li,{children:["The value of ",(0,t.jsx)(n.code,{children:"a"})," is set to ",(0,t.jsx)(n.code,{children:"3"}),", which:","\n",(0,t.jsxs)(n.ol,{children:["\n",(0,t.jsxs)(n.li,{children:["Causes the value of ",(0,t.jsx)(n.code,{children:"sum"})," to be recomputed"]}),"\n",(0,t.jsx)(n.li,{children:"Calls the watch function defined in 1."}),"\n"]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["The value of ",(0,t.jsx)(n.code,{children:"b"})," is set to ",(0,t.jsx)(n.code,{children:"4"}),", which likewise also results in the\nsum being recomputed and the watch function being called."]}),"\n"]}),"\n",(0,t.jsx)(n.h2,{id:"batch-updates",children:"Batch Updates"}),"\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:"MutableCell.batch"})," function allows the values of multiple mutable\ncells to be set simultaneously. The effect of this is that while the\nvalues of the cells are changed as soon as their ",(0,t.jsx)(n.code,{children:"value"})," properties\nare set, the observers of the cells are only notified after all the\ncell values have been set."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Batch updates"',children:"final a = MutableCell(0);\nfinal b = MutableCell(1);\n\nfinal watcher = ValueCell.watch(() {\n\tprint('a = ${a()}, b = ${b()}');\n});\n\n// This only prints: a = 15, b = 3\nMutableCell.batch(() {\n\ta.value = 15;\n\tb.value = 3;\n});\n"})}),"\n",(0,t.jsxs)(n.p,{children:["In the example above, the values of ",(0,t.jsx)(n.code,{children:"a"})," and ",(0,t.jsx)(n.code,{children:"b"})," are set to ",(0,t.jsx)(n.code,{children:"15"})," and\n",(0,t.jsx)(n.code,{children:"3"})," respectively, within a ",(0,t.jsx)(n.code,{children:"MutableCell.batch"}),". The watch function,\nwhich observes both ",(0,t.jsx)(n.code,{children:"a"})," and ",(0,t.jsx)(n.code,{children:"b"}),", is only called once after the value\nof both ",(0,t.jsx)(n.code,{children:"a"})," and ",(0,t.jsx)(n.code,{children:"b"})," is set within ",(0,t.jsx)(n.code,{children:"MutableCell.batch"}),"."]}),"\n",(0,t.jsx)(n.p,{children:"As a result the following is printed to the console:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{children:"a = 0, b = 1\na = 15, b = 3\n"})}),"\n",(0,t.jsxs)(n.ol,{children:["\n",(0,t.jsxs)(n.li,{children:[(0,t.jsx)(n.code,{children:"a = 0, b = 1"})," is printed when the watch function is first defined."]}),"\n",(0,t.jsxs)(n.li,{children:[(0,t.jsx)(n.code,{children:"a = 15, b = 3"})," is printed when ",(0,t.jsx)(n.code,{children:"MutableCell.batch"})," returns."]}),"\n"]}),"\n",(0,t.jsx)(n.admonition,{type:"info",children:(0,t.jsx)(n.p,{children:"A watch function is always called once immediately after it is set\nup. This is necessary to determine, which cells the watch function is\nobserving."})})]})}function h(e={}){const{wrapper:n}={...(0,s.R)(),...e.components};return n?(0,t.jsx)(n,{...e,children:(0,t.jsx)(d,{...e})}):d(e)}},8453:(e,n,l)=>{l.d(n,{R:()=>c,x:()=>a});var t=l(6540);const s={},i=t.createContext(s);function c(e){const n=t.useContext(i);return t.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function a(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:c(e.components),t.createElement(i.Provider,{value:n},e.children)}}}]);