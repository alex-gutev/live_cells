"use strict";(self.webpackChunkmy_website_2=self.webpackChunkmy_website_2||[]).push([[541],{7613:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>o,contentTitle:()=>c,default:()=>h,frontMatter:()=>a,metadata:()=>i,toc:()=>d});var l=t(4848),s=t(8453);const a={title:"Lightweight Computed Cells",description:"What are lightweight computed cells and how to create them?",sidebar_position:2},c="Lightweight Computed Cells",i={id:"advanced/lightweight-cells",title:"Lightweight Computed Cells",description:"What are lightweight computed cells and how to create them?",source:"@site/docs/advanced/lightweight-cells.md",sourceDirName:"advanced",slug:"/advanced/lightweight-cells",permalink:"/live_cells/docs/advanced/lightweight-cells",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:2,frontMatter:{title:"Lightweight Computed Cells",description:"What are lightweight computed cells and how to create them?",sidebar_position:2},sidebar:"tutorialSidebar",previous:{title:"Cell Keys",permalink:"/live_cells/docs/advanced/cell-keys"}},o={},d=[{value:"Stateful and Stateless Cells",id:"stateful-and-stateless-cells",level:2},{value:"Stateless Computed Cells",id:"stateless-computed-cells",level:2},{value:"Stateless to Stateful",id:"stateless-to-stateful",level:2},{value:"Stateless Mutable Computed Cells",id:"stateless-mutable-computed-cells",level:2},{value:"When to use Stateless Cells?",id:"when-to-use-stateless-cells",level:2}];function r(e){const n={a:"a",admonition:"admonition",code:"code",em:"em",h1:"h1",h2:"h2",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,s.R)(),...e.components};return(0,l.jsxs)(l.Fragment,{children:[(0,l.jsx)(n.h1,{id:"lightweight-computed-cells",children:"Lightweight Computed Cells"}),"\n",(0,l.jsxs)(n.p,{children:["To understand what a lightweight computed cell is, we first have to go\nover the difference between ",(0,l.jsx)(n.strong,{children:"stateful cells"})," and ",(0,l.jsx)(n.strong,{children:"stateless\ncells"}),"."]}),"\n",(0,l.jsx)(n.h2,{id:"stateful-and-stateless-cells",children:"Stateful and Stateless Cells"}),"\n",(0,l.jsxs)(n.p,{children:["Till this point, we've mostly been using stateful cells. A stateful\ncell maintains a state in memory, which consists of the cell's value\nand the set of observers that are observing the cell. ",(0,l.jsx)(n.code,{children:"MutableCell"}),"\nand ",(0,l.jsx)(n.code,{children:"ValueCell.computed(...)"})," both create stateful cells."]}),"\n",(0,l.jsxs)(n.p,{children:["Stateless cells do not maintain a state. This means they do not store\na value, nor do they maintain a set of observers. An example of\nstateless cells that we've used frequently throughout this\ndocumentation is the constant cell, e.g. ",(0,l.jsx)(n.code,{children:"1.cell"}),",\n",(0,l.jsx)(n.code,{children:"'hello'.cell"}),'. These cells are stateless because they do not actually\nstore a value but merely return a "hardcoded" constant.']}),"\n",(0,l.jsx)(n.h2,{id:"stateless-computed-cells",children:"Stateless Computed Cells"}),"\n",(0,l.jsx)(n.p,{children:"A lightweight computed cell is a stateless cell that rather than\nreturning a constant, computes a value as a function of the values of\nother cells."}),"\n",(0,l.jsxs)(n.p,{children:["Unlike a stateful cell created with ",(0,l.jsx)(n.code,{children:"ValueCell.computed"}),", a stateless\ncomputed cell does not cache its value. Instead it is computed on\ndemand whenever the value property is accessed. Stateless computed\ncells do not keep track of their own observers. Instead, all observers\nadded to a stateless computed cell, are added directly to the argument\ncells."]}),"\n",(0,l.jsxs)(n.p,{children:["Stateless computed cells can be created using the ",(0,l.jsx)(n.code,{children:"apply"})," method\nprovided by all cells. ",(0,l.jsx)(n.code,{children:"apply"})," takes a compute function, that is\napplied on the value of the cell, and returns a new stateless computed\ncell. The compute function is called whenever the value of the cell is\naccessed."]}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",metastring:'title="Creating a stateless computed cell with .apply()"',children:"final inc = n.apply((n) => n + 1);\nfinal dec = n.apply((n) => n - 1);\n"})}),"\n",(0,l.jsxs)(n.p,{children:["This example shows two definitions of stateless computed cells,\nderived from cell ",(0,l.jsx)(n.code,{children:"n"}),":"]}),"\n",(0,l.jsxs)(n.ul,{children:["\n",(0,l.jsxs)(n.li,{children:[(0,l.jsx)(n.code,{children:"inc"}),", which evaluates to ",(0,l.jsx)(n.code,{children:"n + 1"})]}),"\n",(0,l.jsxs)(n.li,{children:[(0,l.jsx)(n.code,{children:"dec"}),", which evaluates to ",(0,l.jsx)(n.code,{children:"n - 1"})]}),"\n"]}),"\n",(0,l.jsxs)(n.p,{children:["A stateless computed cell with multiple argument cells, can be created\nusing the ",(0,l.jsx)(n.code,{children:"apply"})," method on a record of the argument cells. The\ncompute function is applied with the value of each argument cell\npassed as an argument."]}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",metastring:'title="Multi-argument stateless computed cells"',children:"final sum = (a, b).apply((a, b) => a + b);\n"})}),"\n",(0,l.jsxs)(n.p,{children:["In this example a stateless computed cell ",(0,l.jsx)(n.code,{children:"sum"})," is defined, which\nevaluates to the sum of cells ",(0,l.jsx)(n.code,{children:"a"})," and ",(0,l.jsx)(n.code,{children:"b"}),"."]}),"\n",(0,l.jsxs)(n.p,{children:[(0,l.jsx)(n.code,{children:"apply"})," also takes an optional key argument, by which the returned\ncell is identified:"]}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",metastring:'title="apply() with key argument"',children:"final sum = (a, b).apply((a, b) => a + b,\n    key: SumKey(a, b)\n);\n"})}),"\n",(0,l.jsxs)(n.p,{children:["The purpose of the key in stateless computed cells, is to prevent the\nsame observer from being added to multiple but functionally equivalent\ncell objects. ",(0,l.jsxs)(n.em,{children:["See ",(0,l.jsx)(n.a,{href:"cell-keys",children:"Cell Keys"})," for more information."]})]}),"\n",(0,l.jsxs)(n.p,{children:["If you want to control when the value properties of each argument are\nreferenced, you can define a lightweight computed cell using the\n",(0,l.jsx)(n.a,{href:"https://pub.dev/documentation/live_cells/latest/live_cells/ComputeCell/ComputeCell.html",children:(0,l.jsx)(n.code,{children:"ComputeCell"})}),"\nconstructor. The constructor takes the ",(0,l.jsx)(n.code,{children:"compute"})," function, set of\nargument cells (",(0,l.jsx)(n.code,{children:"arguments"}),") and an optional ",(0,l.jsx)(n.code,{children:"key"}),":"]}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",metastring:'title="ComputeCell constructor"',children:"final logand = ComputeCell(\n    arguments: {a, b},\n    compute: () => a.value && b.value\n);\n"})}),"\n",(0,l.jsxs)(n.p,{children:["Notice the argument set has to be specified manually, and the compute\nfunction does not take any arguments. Instead, the values of the\nargument cells have to be referenced manually using the ",(0,l.jsx)(n.code,{children:"value"}),"\nproperty. Because they are referenced manually, we can control when\neach value property is accessed, which is not possible with\n",(0,l.jsx)(n.code,{children:"apply(...)"}),". In this case ",(0,l.jsx)(n.code,{children:"b.value"})," is only referenced if ",(0,l.jsx)(n.code,{children:"a.value"}),"\nis true, which would not be the case if the cell was defined with ",(0,l.jsx)(n.code,{children:"apply"}),"."]}),"\n",(0,l.jsx)(n.admonition,{type:"important",children:(0,l.jsxs)(n.p,{children:["When defining a stateless compute cell, the values of the argument\ncells are referenced directly using the ",(0,l.jsx)(n.code,{children:"value"})," property rather than\nthe function call syntax used with ",(0,l.jsx)(n.code,{children:"ValueCell.computed"}),". The\ndifference between the two is that ",(0,l.jsx)(n.code,{children:"value"}),' simply accesses the value\nof the cell, whereas calling the cell registers it as a\ndependency. Stateless computed cells don\'t track dependencies,\ntherefore there is no need to "call" the cell, and its value can be\naccessed directly.']})}),"\n",(0,l.jsx)(n.h2,{id:"stateless-to-stateful",children:"Stateless to Stateful"}),"\n",(0,l.jsxs)(n.p,{children:["Occasionally you may want to convert a stateless (lightweight)\ncomputed cell to a stateful cell that caches its value on only\nrecomputes it when the values of the arguments have changed. You can\ndo that with the ",(0,l.jsx)(n.code,{children:".store()"})," method."]}),"\n",(0,l.jsxs)(n.p,{children:["The ",(0,l.jsx)(n.code,{children:".store()"})," method creates a cell that evaluates to the same value\nas the cell, on which the method is called, but caches its value so\nthat it is only recomputed when the arguments have changed."]}),"\n",(0,l.jsx)(n.admonition,{type:"tip",children:(0,l.jsxs)(n.p,{children:[(0,l.jsx)(n.code,{children:".store()"})," returns a keyed cell that is unique for the cell on which\nthe method is called."]})}),"\n",(0,l.jsxs)(n.p,{children:["Consider the following definition of ",(0,l.jsx)(n.code,{children:"sum"})," using a stateless computed\ncell:"]}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"final a = MutableCell(0);\nfinal b = MutableCell(1);\n\nfinal sum = (a, b).apply((a, b) {\n    print('Computing sum');\n    return a + b;\n});\n\nfinal sumStore = sum.store();\n"})}),"\n",(0,l.jsxs)(n.p,{children:[(0,l.jsx)(n.code,{children:"sumStore"})," is the ",(0,l.jsx)(n.code,{children:"sum"})," cell converted to a stateful cell, using\n",(0,l.jsx)(n.code,{children:".store()"}),"."]}),"\n",(0,l.jsx)(n.p,{children:"When the following is evaluated:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"ValuCell(() {\n    print('sum1: ${sum()}');\n    print('sum2: ${sum()}');\n});\n\na.value = 1;\n"})}),"\n",(0,l.jsxs)(n.p,{children:["The value computation function for ",(0,l.jsx)(n.code,{children:"sum"}),' is called twice, when its\nvalue is referenced twice in the watch function. As a result\n"Computing sum" is printed to the console twice.']}),"\n",(0,l.jsx)(n.p,{children:"However when the following is evaluated:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"ValuCell(() {\n    print('sum1: ${sumStore()}');\n    print('sum2: ${sumStore()}');\n});\n\na.value = 1;\n"})}),"\n",(0,l.jsxs)(n.p,{children:["The value computation function for ",(0,l.jsx)(n.code,{children:"sum"}),' is only called once, and\nhence "Computing sum" is only printed to the console once.']}),"\n",(0,l.jsx)(n.admonition,{title:"Important",type:"warning",children:(0,l.jsxs)(n.p,{children:[(0,l.jsx)(n.code,{children:".store()"})," only has an affect when the value of the cell is referenced\nthrough the cell returned by ",(0,l.jsx)(n.code,{children:".store()"}),". Referencing the value of the\noriginal cell will still result in its value being recomputed."]})}),"\n",(0,l.jsxs)(n.p,{children:[(0,l.jsx)(n.code,{children:".store()"})," also takes an optional ",(0,l.jsx)(n.code,{children:"changesOnly"})," argument. When\n",(0,l.jsx)(n.code,{children:"changsOnly"})," is true, the returned cell only notifies its observers\nwhen the new value of the cell is not equal (by ",(0,l.jsx)(n.code,{children:"=="}),") to its previous\nvalue. This is useful to prevent potentially expensive recomputations\n(and side effects such as rebuilding a widget hierarchy) when the\nactual value of the cell hasn't changed."]}),"\n",(0,l.jsx)(n.p,{children:"This can be demonstrated with the following example:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"final a = MutableCell(2);\n\nfinal c1 = a.apply((a) => a % 2).store();\nfinal c2 = a.apply((a) => a % 2)\n    .store(changesOnly: true);\n    \nValueCell.watch(() => print('C1: ${c1()}');\nValueCell.watch(() => print('C2: ${c2()}');\n"})}),"\n",(0,l.jsx)(n.p,{children:"When the following is evaluated:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"a.value = 4;\na.value = 6;\n"})}),"\n",(0,l.jsx)(n.p,{children:"The following is printed to the console:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{children:"C1: 0\nC1: 0\n"})}),"\n",(0,l.jsxs)(n.p,{children:["Notice the second watch function, which observers ",(0,l.jsx)(n.code,{children:"c2"})," which is\ndefined using ",(0,l.jsx)(n.code,{children:".store(changesOnly: true)"})," is not called. This is\nbecause the computed value of the cell has not changed, even though\nthe value of its argument cell has."]}),"\n",(0,l.jsx)(n.p,{children:"When evaluating the following:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"a.value = 7;\n"})}),"\n",(0,l.jsx)(n.p,{children:"The following is printed:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{children:"C1: 1\nC2: 1\n"})}),"\n",(0,l.jsxs)(n.p,{children:["Now both watch functions are called, because the computed value has\nchanged from ",(0,l.jsx)(n.code,{children:"0"})," to ",(0,l.jsx)(n.code,{children:"1"}),"."]}),"\n",(0,l.jsxs)(n.admonition,{type:"caution",children:[(0,l.jsxs)(n.p,{children:["Only one value can be provided for ",(0,l.jsx)(n.code,{children:"changesOnly"})," for a given cell. For\nexample:"]}),(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"final store1 = a.store(changesOnly: true);\nfinal store2 = a.store();\n"})}),(0,l.jsxs)(n.p,{children:["will only result in one of the values for changesOnly (",(0,l.jsx)(n.code,{children:"true"})," or\n",(0,l.jsx)(n.code,{children:"false"})," which is the default) taking effect for both ",(0,l.jsx)(n.code,{children:"store1"})," and\n",(0,l.jsx)(n.code,{children:"store2"}),". Treat ",(0,l.jsx)(n.code,{children:"changesOnly"})," as a performance optimization but don't\ndepend on the difference between ",(0,l.jsx)(n.code,{children:"changesOnly: true"})," and ",(0,l.jsx)(n.code,{children:"changesOnly: false"})," for correctness."]})]}),"\n",(0,l.jsx)(n.admonition,{type:"info",children:(0,l.jsxs)(n.p,{children:[(0,l.jsx)(n.code,{children:"changesOnly: true"})," changes the evaluation semantics of the cell on\nwhich it is applied from lazy to eager. This will be explained in more\ndetail in the next section of the documentation."]})}),"\n",(0,l.jsx)(n.h2,{id:"stateless-mutable-computed-cells",children:"Stateless Mutable Computed Cells"}),"\n",(0,l.jsxs)(n.p,{children:["A stateless variant of a mutable computed cell can be defined using\n",(0,l.jsx)(n.code,{children:".mutableApply()"}),". Like ",(0,l.jsx)(n.code,{children:"apply"})," this function can either be applied on\nthe cell, or a record of cells, and takes the value computation\nfunction as an argument. ",(0,l.jsx)(n.code,{children:".mutableApply()"})," also takes a second\nargument which is the reverse computation function, as in\n",(0,l.jsx)(n.code,{children:"MutableCell.computed()"}),"."]}),"\n",(0,l.jsxs)(n.p,{children:["It is important to note that by default ",(0,l.jsx)(n.code,{children:"mutableApply"})," does not create\na stateless cell, but a stateful mutable computed cell with a static\nargument cell set. In order for a stateless cell to be created, a\nnon-null value for the ",(0,l.jsx)(n.code,{children:"key"})," argument has to be given."]}),"\n",(0,l.jsx)(n.p,{children:"Example:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"final a = MutableCell<num>(0);\nfinal b = MutableCell<num>(1);\n\nfinal sum = (a, b).mutableApply((a, b) => a + b, (sum) {\n    final half = sum / 2;\n    \n    a.value = b.value = half;\n}, key: MyKey(a, b));\n"})}),"\n",(0,l.jsxs)(n.p,{children:["In this example the ",(0,l.jsx)(n.code,{children:"sum"})," cell from ",(0,l.jsx)(n.a,{href:"/docs/basics/two-way-data-flow#fun-with-mutable-computed-cells",children:"Fun with Mutable Computed\nCells"}),"\nhas been implemented using a stateless mutable computed cell. The\nbehaviour of the cell is equivalent to the previous definition. It's\ncomputed value is the sum of cells ",(0,l.jsx)(n.code,{children:"a"})," and ",(0,l.jsx)(n.code,{children:"b"}),", while setting its\nvalue results in its value divided by 2 being assigned to both ",(0,l.jsx)(n.code,{children:"a"})," and\n",(0,l.jsx)(n.code,{children:"b"})," However, with this definition the ",(0,l.jsx)(n.code,{children:"sum"})," cell is entirely\nstateless. It doesn't keep track of its value, neither its computed\nvalue nor that assigned to it. It's value is recomputed whenever\n",(0,l.jsx)(n.code,{children:"sum.value"})," is accessed. The cell also does not keep track of which\ncells are observing it. Adding an observer to ",(0,l.jsx)(n.code,{children:"sum"})," results in the\nobserver being added directly to cells ",(0,l.jsx)(n.code,{children:"a"})," and ",(0,l.jsx)(n.code,{children:"b"}),"."]}),"\n",(0,l.jsxs)(n.p,{children:["A stateless mutable computed cell can also be defined with the\n",(0,l.jsx)(n.a,{href:"https://pub.dev/documentation/live_cells/latest/live_cells/MutableCellView/MutableCellView.html",children:(0,l.jsx)(n.code,{children:"MutableCellView"})}),"\nconstructor. The constructor takes the set of argument cells, the\ncompute value function and the reverse computed functions as\narguments, with an optional ",(0,l.jsx)(n.code,{children:"key"})," argument. Like ",(0,l.jsx)(n.code,{children:"ComputeCell"})," the\ncompute value function is not called with any arguments, which allows\nyou to control when the values of the argument cells are referenced,\nusing ",(0,l.jsx)(n.code,{children:".value"}),"."]}),"\n",(0,l.jsxs)(n.p,{children:["The above definition using the ",(0,l.jsx)(n.code,{children:"MutableCellView"})," constructor."]}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"final sum = MutableCellView(\n    arguments: {a, b}\n    compute: () => a.value + b.value,\n    reverse: (sum) {\n        final half = sum / 2;\n    \n        a.value = b.value = half;\n    },\n    \n    key: MyKey(a, b)\n);\n"})}),"\n",(0,l.jsx)(n.p,{children:"Stateless mutable computed cells differ in their semantics from their\nstateful counterparts. Stateful mutable computed cells keep track of\nthe value assigned to them whereas the stateless variants do not. This\nbecomes apparent if the values assigned to the argument cells do not\nresult in the same value being computed as the value that was assigned\nto the mutable computed cell."}),"\n",(0,l.jsx)(n.p,{children:"For example consider the following cell:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"final sum = MutableCell.computed(() => a() + b(), (sum) {\n    a.value = sum;\n    b.value = sum\n});\n"})}),"\n",(0,l.jsxs)(n.p,{children:["The values assigned to the argument cells, in the reverse computation\nfunction, will not result in the same value being computed as the\nvalue that was assigned to sum. However the ",(0,l.jsx)(n.code,{children:"sum"})," cell will remember\nwhat value it was assigned:"]}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"sum.value = 10;\n\nprint(sum.value);         // 10\nprint(a.value + b.value); // 20\n"})}),"\n",(0,l.jsx)(n.p,{children:"A stateless mutable computed cell on the other hand will not remember\nwhat value it was assigned. Instead it will recompute its value which\nis now different from the value it was assigned:"}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"final sum = (a, b).mutableApply((a, b) => a + b, (sum) {\n    a.value = sum;\n    b.value = sum\n});\n"})}),"\n",(0,l.jsx)(n.pre,{children:(0,l.jsx)(n.code,{className:"language-dart",children:"sum.value = 10;\n\nprint(sum.value);         // 20\nprint(a.value + b.value); // 20\n"})}),"\n",(0,l.jsx)(n.p,{children:"Therefore it's important to ensure that the values assigned to the\nargument cells are such that when the value computation function is\nrun, an equivalent value will be produced as the value that was\nassigned. If this condition cannot be met, then you should use a\nnormal stateful mutable computed cell."}),"\n",(0,l.jsx)(n.h2,{id:"when-to-use-stateless-cells",children:"When to use Stateless Cells?"}),"\n",(0,l.jsxs)(n.p,{children:["Stateless computed cells are useful for lightweight computations, such\nas basic arithmetic and numeric comparisons, where recomputing the\ncell's value every time it is accessed is likely to be faster than\ncaching it, due to the overhead of maintaining a state. For expensive\ncomputations, it's preferable to cache the value and only recompute it\nwhen necessary. If in doubt, you're better off sticking to\n",(0,l.jsx)(n.code,{children:"ValueCell.computed"})," and ",(0,l.jsx)(n.code,{children:"MutableCell.computed"}),"."]})]})}function h(e={}){const{wrapper:n}={...(0,s.R)(),...e.components};return n?(0,l.jsx)(n,{...e,children:(0,l.jsx)(r,{...e})}):r(e)}},8453:(e,n,t)=>{t.d(n,{R:()=>c,x:()=>i});var l=t(6540);const s={},a=l.createContext(s);function c(e){const n=l.useContext(a);return l.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function i(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:c(e.components),l.createElement(a.Provider,{value:n},e.children)}}}]);