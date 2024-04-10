"use strict";(self.webpackChunkmy_website_2=self.webpackChunkmy_website_2||[]).push([[319],{1064:(e,n,l)=>{l.r(n),l.d(n,{assets:()=>r,contentTitle:()=>a,default:()=>h,frontMatter:()=>s,metadata:()=>c,toc:()=>d});var t=l(4848),i=l(8453);const s={title:"Asynchronous Cells",description:"Handling asynchronous data using cells",sidebar_position:10},a="Asynchronous Cells",c={id:"basics/async-cells",title:"Asynchronous Cells",description:"Handling asynchronous data using cells",source:"@site/docs/basics/async-cells.md",sourceDirName:"basics",slug:"/basics/async-cells",permalink:"/docs/basics/async-cells",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:10,frontMatter:{title:"Asynchronous Cells",description:"Handling asynchronous data using cells",sidebar_position:10},sidebar:"tutorialSidebar",previous:{title:"Lists, Maps and Sets",permalink:"/docs/basics/lists-maps-sets"},next:{title:"Action Cells",permalink:"/docs/basics/action-cells"}},r={},d=[{value:"Futures in Cells",id:"futures-in-cells",level:2},{value:"Multiple Arguments",id:"multiple-arguments",level:3},{value:"Wait Cells",id:"wait-cells",level:2},{value:"Order of Updates",id:"order-of-updates",level:3},{value:"Multiple Arguments",id:"multiple-arguments-1",level:3},{value:"Latest Futures Only",id:"latest-futures-only",level:2},{value:"Checking if Complete",id:"checking-if-complete",level:2},{value:"Async State",id:"async-state",level:2},{value:"Delays and Debouncing",id:"delays-and-debouncing",level:2}];function o(e){const n={a:"a",admonition:"admonition",code:"code",em:"em",h1:"h1",h2:"h2",h3:"h3",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,i.R)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(n.h1,{id:"asynchronous-cells",children:"Asynchronous Cells"}),"\n",(0,t.jsx)(n.p,{children:"Live Cells provides a number of tools for handling data that is\nfetched / computed asynchronously."}),"\n",(0,t.jsx)(n.h2,{id:"futures-in-cells",children:"Futures in Cells"}),"\n",(0,t.jsxs)(n.p,{children:["A cell can hold and perform computations on a ",(0,t.jsx)(n.code,{children:"Future"}),", which\nrepresents an asynchronously computed value in Dart, just like any\nother value. Thus, to perform a computation on asynchronous data,\nsimply define a computed cell with an ",(0,t.jsx)(n.code,{children:"async"})," computation function and\nuse ",(0,t.jsx)(n.code,{children:"await"})," to wait for the values in the argument cells to be\ncomputed."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Example of an asynchronous cell"',children:"final n = MutableCell(Future.value(1));\n\nfinal next = ValueCell.computed(() async => await n() + 1);\n"})}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:[(0,t.jsx)(n.code,{children:"n"})," is a mutable cell holding a ",(0,t.jsx)(n.code,{children:"Future"})]}),"\n",(0,t.jsxs)(n.li,{children:[(0,t.jsx)(n.code,{children:"next"})," is a computed cell that returns a ",(0,t.jsx)(n.code,{children:"Future"}),", which applies a\ncomputation on the ",(0,t.jsx)(n.code,{children:"Future"})," value held in ",(0,t.jsx)(n.code,{children:"n"}),"."]}),"\n"]}),"\n",(0,t.jsxs)(n.p,{children:["When a ",(0,t.jsx)(n.code,{children:"Future"})," is assigned to the value of ",(0,t.jsx)(n.code,{children:"n"}),", the value of ",(0,t.jsx)(n.code,{children:"next"}),"\nis updated with the new ",(0,t.jsx)(n.code,{children:"Future"})," held in ",(0,t.jsx)(n.code,{children:"n"}),"."]}),"\n",(0,t.jsxs)(n.p,{children:["It's important to note that the values of asynchronous cells, which\nremember are ",(0,t.jsx)(n.code,{children:"Future"}),"s, are updated synchronously as soon as a value\nis assigned to a mutable cell. It's only the computations represented\nby the ",(0,t.jsx)(n.code,{children:"Future"}),"s that are asynchronous. This is best explained by the\nfollowing example:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"n.value = Future.delayed(Duration(seconds: 5), () => 2);\nn.value = Future.value(3);\n\nprint(await next.value); // Prints 3\n"})}),"\n",(0,t.jsx)(n.h3,{id:"multiple-arguments",children:"Multiple Arguments"}),"\n",(0,t.jsxs)(n.p,{children:["An asynchronous cell can reference multiple argument cells, however\nthe argument cells should all be referenced before the first ",(0,t.jsx)(n.code,{children:"await"}),"\nexpression. Argument cells that are only referenced after the first\n",(0,t.jsx)(n.code,{children:"await"})," expression will not be observed by the computed cell."]}),"\n",(0,t.jsx)(n.p,{children:"Multiple asynchronous argument cells should either be referenced first\nand then awaited, such as in the following example:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="An asynchronous computed cell with multiple arguments"',children:"final arg1 = MutableCell(Future.value(0));\nfinal arg2 = MutableCell(Future.value(1));\n\nfinal sum = ValueCell.computed(() async {\n    final a = arg1();\n    final b = arg2();\n    \n    return (await a) + (await b);\n});\n"})}),"\n",(0,t.jsx)(n.p,{children:"Or awaited at once using the following:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final arg1 = MutableCell(Future.value(0));\nfinal arg2 = MutableCell(Future.value(1));\n\nfinal sum = ValueCell.computed(() async {\n    final (a, b) = await (arg1(), arg2()).wait;\n    \n    return a + b;\n});\n"})}),"\n",(0,t.jsxs)(n.admonition,{type:"danger",children:[(0,t.jsxs)(n.p,{children:["The following is wrong as it will result in ",(0,t.jsx)(n.code,{children:"arg2"})," not being observed\nby ",(0,t.jsx)(n.code,{children:"sum"}),", since it is only referenced after the first ",(0,t.jsx)(n.code,{children:"await"}),"\nexpression:"]}),(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final arg1 = MutableCell(Future.value(0));\nfinal arg2 = MutableCell(Future.value(1));\n\nfinal sum = ValueCell.computed(() async {\n    final a = await arg1();\n    \n    // This wont be observed by `sum`\n    final b = await arg2();\n    \n    return a + b;\n});\n"})})]}),"\n",(0,t.jsx)(n.h2,{id:"wait-cells",children:"Wait Cells"}),"\n",(0,t.jsxs)(n.p,{children:["What we've seen till this point is cells taking in a ",(0,t.jsx)(n.code,{children:"Future"}),", from\none or more argument cells, ",(0,t.jsx)(n.code,{children:"await"}),"ing the ",(0,t.jsx)(n.code,{children:"Future"}),", applying a\ncomputation on the value and producing another ",(0,t.jsx)(n.code,{children:"Future"}),". However there\nis no way for a cell to take in a ",(0,t.jsx)(n.code,{children:"Future"})," from an argument cell,\n",(0,t.jsx)(n.code,{children:"await"})," that ",(0,t.jsx)(n.code,{children:"Future"})," and produce an immediate (non-future)\nvalue. That's where ",(0,t.jsx)(n.em,{children:"wait cells"})," come in."]}),"\n",(0,t.jsxs)(n.p,{children:["A ",(0,t.jsx)(n.em,{children:"wait cell"})," waits for a ",(0,t.jsx)(n.code,{children:"Future"}),", held in another cell, to complete\nbefore notifying its observers. Once the ",(0,t.jsx)(n.code,{children:"Future"})," completes, the value\nof the ",(0,t.jsx)(n.em,{children:"wait cell"})," is updated to the completed value of the\n",(0,t.jsx)(n.code,{children:"Future"}),". A wait cell is created from a cell holding a ",(0,t.jsx)(n.code,{children:"Future"})," using\nthe ",(0,t.jsx)(n.code,{children:".wait"})," property:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Using .wait cells"',children:"final asyncN = MutableCell(Future.value(1));\nfinal n = asyncN.wait;\n\nfinal next = ValueCell.computed(() => n() + 1);\n"})}),"\n",(0,t.jsxs)(n.p,{children:["Notice in this definition of ",(0,t.jsx)(n.code,{children:"next"}),", the computation function is not\nan ",(0,t.jsx)(n.code,{children:"async"})," function and the value of ",(0,t.jsx)(n.code,{children:"n"})," is not ",(0,t.jsx)(n.code,{children:"awaited"}),". Since\n",(0,t.jsx)(n.code,{children:"wait"})," is a property it returns a keyed cell, like all properties\nthat return cells. This means the ",(0,t.jsx)(n.code,{children:"n"})," variable above can be omitted\nand the above example can be simplified to the following:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final n = MutableCell(Future.value(1));\n\nfinal next = ValueCell.computed(() => n.wait() + 1);\n"})}),"\n",(0,t.jsx)(n.admonition,{type:"note",children:(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"asyncN"})," has been renamed to ",(0,t.jsx)(n.code,{children:"n"}),"."]})}),"\n",(0,t.jsxs)(n.p,{children:["When a value is assigned to ",(0,t.jsx)(n.code,{children:"n"}),", the value of ",(0,t.jsx)(n.code,{children:"next"})," is not updated\nimmediately. Instead it is only updated when the ",(0,t.jsx)(n.code,{children:"Future"})," held in ",(0,t.jsx)(n.code,{children:"n"}),"\ncompletes. That's the effect of the ",(0,t.jsx)(n.code,{children:"n.wait"})," cell."]}),"\n",(0,t.jsxs)(n.p,{children:["Until the ",(0,t.jsx)(n.code,{children:"Future"})," awaited by a ",(0,t.jsx)(n.code,{children:".wait"})," cell completes, accessing the\ncell's value will result in a ",(0,t.jsx)(n.code,{children:"PendingAsyncValueError"})," exception\nbeing thrown. Once the ",(0,t.jsx)(n.code,{children:"Future"})," completes, it will retain its value\nuntil the next ",(0,t.jsx)(n.code,{children:"Future"})," completes."]}),"\n",(0,t.jsxs)(n.p,{children:["For example accessing the value of ",(0,t.jsx)(n.code,{children:"next"})," above before the first value\nupdate of ",(0,t.jsx)(n.code,{children:"n.wait"}),", will result in a ",(0,t.jsx)(n.code,{children:"PendingAsyncValueError"}),"\nexception being thrown. This can be handled with ",(0,t.jsx)(n.code,{children:"onError"})," to give an\ninitial value to a wait cell:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final waitN = n.wait.onError<PendingAsyncValueError(0.cell);\nprint(waitN.value); // Prints: 0\n\nfinal next = ValueCell.computed(() => waitN() + 1);\n"})}),"\n",(0,t.jsx)(n.admonition,{type:"important",children:(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:".wait"})," cell only ",(0,t.jsx)(n.em,{children:"awaits"})," ",(0,t.jsx)(n.code,{children:"Future"}),"s when it has at least one\nobserver."]})}),"\n",(0,t.jsx)(n.h3,{id:"order-of-updates",children:"Order of Updates"}),"\n",(0,t.jsxs)(n.p,{children:["The value of ",(0,t.jsx)(n.code,{children:".wait"})," is updated whenever a ",(0,t.jsx)(n.code,{children:"Future"})," that is assigned\nto the cell completes. The value updates are delivered in the same\norder as the ",(0,t.jsx)(n.code,{children:"Future"}),"s are assigned to the cell, and not the order in\nwhich the ",(0,t.jsx)(n.code,{children:"Future"}),"s actually complete. This means that if a ",(0,t.jsx)(n.code,{children:"Future"}),"\n",(0,t.jsx)(n.strong,{children:"a"})," is assigned to a cell followed by a ",(0,t.jsx)(n.code,{children:"Future"})," ",(0,t.jsx)(n.strong,{children:"b"}),", the value of\nthe ",(0,t.jsx)(n.code,{children:".wait"})," cell is always first set to the completed value of ",(0,t.jsx)(n.strong,{children:"a"}),"\nand then the completed value of ",(0,t.jsx)(n.strong,{children:"b"}),", even if ",(0,t.jsx)(n.strong,{children:"b"})," completes before\n",(0,t.jsx)(n.strong,{children:"a"}),"."]}),"\n",(0,t.jsx)(n.p,{children:"For example with the following:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Ordering of .wait cell updates"',children:"final n = MutableCell(Future.value(1));\n\nValueCell.watch(() => print('${n.wait()}'));\n\n// This future completes after 30 seconds\nn.value = Future.delayed(Duration(seconds: 30), () => 2);\n\n// This future completes before the previous future\n// that was assigned to `n`\nn.value = Future.value(3);\n"})}),"\n",(0,t.jsx)(n.p,{children:"The following will be printed to the console:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{children:"1\n2\n3\n"})}),"\n",(0,t.jsxs)(n.p,{children:["The second and third lines will both be printed after the second\n",(0,t.jsx)(n.code,{children:"Future"})," that was assigned to ",(0,t.jsx)(n.code,{children:"n"})," completes, which is after a delay of\n30 seconds. If the updates were delivered in the order of completion,\n",(0,t.jsx)(n.code,{children:"3"})," would have been printed to the console before ",(0,t.jsx)(n.code,{children:"2"}),"."]}),"\n",(0,t.jsx)(n.admonition,{type:"caution",children:(0,t.jsxs)(n.p,{children:["If a ",(0,t.jsx)(n.code,{children:"Future"})," that never completes is assigned to a cell, the value of\nthe ",(0,t.jsx)(n.code,{children:".wait"})," cell will never be updated again. If there's a chance of\nthat happening, add a ",(0,t.jsx)(n.em,{children:"timeout"})," on the ",(0,t.jsx)(n.code,{children:"Future"})," before assigning it to\na cell or use ",(0,t.jsx)(n.code,{children:".waitLast"}),", more on this later."]})}),"\n",(0,t.jsx)(n.h3,{id:"multiple-arguments-1",children:"Multiple Arguments"}),"\n",(0,t.jsxs)(n.p,{children:["The correct way to reference multiple wait cells in a computed cell is\nusing the ",(0,t.jsx)(n.code,{children:".wait"})," property on a record holding all the argument cells:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Multiple argument wait cells"',children:"final arg1 = MutableCell(Future.value(1));\nfinal arg2 = MutableCell(Future.value(2));\n\nfinal sum = ValueCell.compute(() {\n    final (a, b) = (arg1, arg2).wait();\n    \n    return a + b;\n});\n"})}),"\n",(0,t.jsx)(n.admonition,{type:"note",children:(0,t.jsxs)(n.p,{children:["The function call syntax is used on ",(0,t.jsx)(n.code,{children:".wait"})," and not on ",(0,t.jsx)(n.code,{children:"arg1"})," and\n",(0,t.jsx)(n.code,{children:"arg2"}),". Also there is no ",(0,t.jsx)(n.code,{children:"await"}),". This is intentional."]})}),"\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:".wait"})," property of the record ",(0,t.jsx)(n.code,{children:"(arg1, arg2)"})," returns a cell that\nholds a record of the completed values of the ",(0,t.jsx)(n.code,{children:"Futures"})," held in cells\n",(0,t.jsx)(n.code,{children:"arg1"})," and ",(0,t.jsx)(n.code,{children:"arg2"}),". In the example above the elements of the record are\nimmediately assigned to the local variables ",(0,t.jsx)(n.code,{children:"a"})," and ",(0,t.jsx)(n.code,{children:"b"}),"."]}),"\n",(0,t.jsx)(n.p,{children:"You might be asking why not just do this:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final arg1 = MutableCell(Future.value(1));\nfinal arg2 = MutableCell(Future.value(2));\n\nfinal sum = ValueCell.compute(() => arg1.wait() + arg2.wait());\n"})}),"\n",(0,t.jsxs)(n.p,{children:["There is an issue with this approach. If the ",(0,t.jsx)(n.code,{children:"Future"}),"s held in ",(0,t.jsx)(n.code,{children:"arg1"}),"\nand ",(0,t.jsx)(n.code,{children:"arg2"})," complete at different times (which they most certainly\nwill), the value of ",(0,t.jsx)(n.code,{children:"sum"})," will be recomputed twice, once when the\nfirst future completes, and again when the second future\ncompletes. This is probably not what you want especially if the values\nof ",(0,t.jsx)(n.code,{children:"arg1"})," and ",(0,t.jsx)(n.code,{children:"arg2"})," are set at the same time."]}),"\n",(0,t.jsx)(n.p,{children:"To demonstrate the difference, consider the following watch function:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"ValueCell.watch(() {\n    print('${sum()}');\n});\n"})}),"\n",(0,t.jsxs)(n.p,{children:["And consider the following ",(0,t.jsx)(n.code,{children:"Future"}),"s assigned to ",(0,t.jsx)(n.code,{children:"arg1"})," and ",(0,t.jsx)(n.code,{children:"arg2"})," in a batch:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"MutableCell.batch(() {\n    arg1.value = Future.delayed(Duration(seconds: 5), () => 20);\n    arg2.value = Future.delayed(Duration(seconds: 10), () => 30);\n});\n"})}),"\n",(0,t.jsxs)(n.p,{children:["With the first (correct) definition of ",(0,t.jsx)(n.code,{children:"sum"})," the following will be\nprinted to the console, by the watch function, after the values are\nassigned to ",(0,t.jsx)(n.code,{children:"arg1"})," and ",(0,t.jsx)(n.code,{children:"arg2"}),":"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{children:"50\n"})}),"\n",(0,t.jsx)(n.p,{children:"This is probably what you expect."}),"\n",(0,t.jsx)(n.p,{children:"With the first definition the following will be printed:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{children:"22\n50\n"})}),"\n",(0,t.jsxs)(n.p,{children:["The first line is printed when the ",(0,t.jsx)(n.code,{children:"Future"})," held in ",(0,t.jsx)(n.code,{children:"arg1"})," completes\nafter five seconds. The second line is printed when the ",(0,t.jsx)(n.code,{children:"Future"})," held\nin ",(0,t.jsx)(n.code,{children:"arg2"})," completes after ten seconds."]}),"\n",(0,t.jsx)(n.p,{children:"If this isn't an issue for your application logic then you can go\nahead and use the second definition."}),"\n",(0,t.jsxs)(n.admonition,{type:"caution",children:[(0,t.jsxs)(n.p,{children:["Avoid mixing ",(0,t.jsx)(n.code,{children:".wait"})," with cells holding immediate values:"]}),(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final sum = ValueCell.computed(() => a.wait() + b());\n"})}),(0,t.jsxs)(n.p,{children:["The value of ",(0,t.jsx)(n.code,{children:"a.wait"})," is only updated when the ",(0,t.jsx)(n.code,{children:"Future"})," held in ",(0,t.jsx)(n.code,{children:"a"}),"\ncompletes. Whilst not strictly wrong, this can lead to some surprising\nbehaviour if ",(0,t.jsx)(n.code,{children:"a"})," and ",(0,t.jsx)(n.code,{children:"b"})," both update their values at the same time."]}),(0,t.jsx)(n.p,{children:"The following is recommended instead:"}),(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final sum = ValueCell.computed(() async => await a() + b).wait;\n"})})]}),"\n",(0,t.jsx)(n.h2,{id:"latest-futures-only",children:"Latest Futures Only"}),"\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:".waitLast"})," property is like ",(0,t.jsx)(n.code,{children:".wait"})," however with one important\ndifference. If the value of the cell is updated before the ",(0,t.jsx)(n.code,{children:"Future"}),"\nthat was previously held in the cell completes, the previous ",(0,t.jsx)(n.code,{children:"Future"}),"\nis ignored and the value of ",(0,t.jsx)(n.code,{children:".waitLast"})," is not updated when it\ncompletes."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Example of .waitLast"',children:"\nfinal n = MutableCell(Future.value(1));\n\nValueCell.watch(() {\n    print('${n.waitLast()}');\n});\n\nn.value = Future.delayed(Duration(seconds: 30), () => 2);\nn.value = Future.value(3);\nn.value = Future.delayed(Duration(seconds: 10), () => 4);\n"})}),"\n",(0,t.jsx)(n.p,{children:"The only value printed to the console is:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{children:"4\n"})}),"\n",(0,t.jsxs)(n.p,{children:["This is because it was the last value that was assigned to ",(0,t.jsx)(n.code,{children:"n"})," and it\nwas assigned before any of the preceding ",(0,t.jsx)(n.code,{children:"Future"}),"s had a chance to\ncomplete. Even when the second ",(0,t.jsx)(n.code,{children:"Future"})," completes after thirty\nseconds, the value of ",(0,t.jsx)(n.code,{children:"n.waitLast"})," will not be updated to ",(0,t.jsx)(n.code,{children:"2"}),"."]}),"\n",(0,t.jsx)(n.p,{children:"This is useful in two scenarios:"}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:['To "cancel" a ',(0,t.jsx)(n.code,{children:"Future"})," that is taking too long to complete, by\nassigning a new ",(0,t.jsx)(n.code,{children:"Future"})," to the cell."]}),"\n",(0,t.jsx)(n.li,{children:"Debouncing (we'll see how to do this in the next section)."}),"\n"]}),"\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:".awaited"})," cell is similar to ",(0,t.jsx)(n.code,{children:".waitLast"}),", however it does not\nretain the completed value of the previous ",(0,t.jsx)(n.code,{children:"Future"}),". If the current\n",(0,t.jsx)(n.code,{children:"Future"})," has completed, the value of the ",(0,t.jsx)(n.code,{children:".awaited"})," cell is the\ncompleted value of the ",(0,t.jsx)(n.code,{children:"Future"}),". If the ",(0,t.jsx)(n.code,{children:"Future"})," has not completed, an\n",(0,t.jsx)(n.code,{children:"PendingAsyncValueError"})," exception is thrown when accessing the value\nof ",(0,t.jsx)(n.code,{children:".awaited"}),"."]}),"\n",(0,t.jsxs)(n.admonition,{type:"tip",children:[(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:".initialValue(...)"})," method, on all cells can be used to handle\n",(0,t.jsx)(n.code,{children:"UninitializedCellError"})," and ",(0,t.jsx)(n.code,{children:"PendingAsyncValueError"}),", by returning\nthe value of another cell:"]}),(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final f = Future.delayed(Duration(seconds: 10), 1)\n    .cell\n    .awaited\n    .initialValue(0.cell);\n    \n// The value of f is `0` until its value is initialized,\n// which happens when the Future completes.\nprint(f.value) // Prints: 0\n"})}),(0,t.jsxs)(n.p,{children:["If you only want to handle ",(0,t.jsx)(n.code,{children:"PendingAsyncValueError"}),", use\n",(0,t.jsx)(n.code,{children:"loadingValue"})," instead."]})]}),"\n",(0,t.jsx)(n.admonition,{type:"caution",children:(0,t.jsxs)(n.p,{children:["Both ",(0,t.jsx)(n.code,{children:"initialValue"})," and ",(0,t.jsx)(n.code,{children:"loadingValue"})," return keyed cells, which means\nthe returned cells can be used within ",(0,t.jsx)(n.code,{children:"ValueCell.computed"})," without\nassigning them to a local variable first. ",(0,t.jsx)(n.strong,{children:"However"}),", this only works\nif the initial value cell, provided to ",(0,t.jsx)(n.code,{children:"initialValue"}),"/",(0,t.jsx)(n.code,{children:"loadingValue"}),",\nis also a keyed cell. For constant cells this is the case when the\nconstant value type defines ",(0,t.jsx)(n.code,{children:"=="})," and ",(0,t.jsx)(n.code,{children:"hashCode"})," such that different\nobjects representing the same value compare equal under ",(0,t.jsx)(n.code,{children:"=="}),". ",(0,t.jsx)(n.code,{children:"List"}),"s\nand ",(0,t.jsx)(n.code,{children:"Map"}),"s do not satisfy this requirement."]})}),"\n",(0,t.jsxs)(n.p,{children:["Here's an example demonstrating the difference between ",(0,t.jsx)(n.code,{children:".waitLast"})," and\n",(0,t.jsx)(n.code,{children:".awaited"}),":"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'example="Difference between .waitLast and .awaited"',children:"final f = MutableCell(Future.value(1));\n\nfinal waitLast = f.waitLast.initialValue(0.cell);\nfinal awaited = f.awaited.initialValue(0.cell);\n\nValueCell.watch(() {\n    print('.waitLast: ${waitLast()}');\n});\n\nValueCell.watch(() {\n    print('.awaited: ${awaited()}');\n});\n\nawait Future.delayed(Duration(seconds: 1));\n\n"})}),"\n",(0,t.jsxs)(n.p,{children:["This will result in the following values being printed to the console,\nwhich is the initial value provided with ",(0,t.jsx)(n.code,{children:"initialValue(0.cell)"}),":"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{children:".waitLast: 0\n.awaited: 0\n"})}),"\n",(0,t.jsx)(n.admonition,{type:"note",children:(0,t.jsx)(n.p,{children:"The exact order in which the lines are printed may vary, since they\nare printed from different watch functions."})}),"\n",(0,t.jsx)(n.p,{children:"When the initial future completes, the following is printed:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{children:".waitLast: 1\n.awaited: 1\n"})}),"\n",(0,t.jsxs)(n.p,{children:["So far the two are identical, however when a new ",(0,t.jsx)(n.code,{children:"Future"})," is assigned\nto ",(0,t.jsx)(n.code,{children:"f"}),":"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"f.value = Future.value(2);\n"})}),"\n",(0,t.jsxs)(n.p,{children:["The following is printed immediately when setting ",(0,t.jsx)(n.code,{children:"f.value"}),":"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:".awaited: 0\n"})}),"\n",(0,t.jsxs)(n.p,{children:["The value of ",(0,t.jsx)(n.code,{children:".awaited"})," is reset to the initial value, given with\n",(0,t.jsx)(n.code,{children:"initialValue(0.cell)"}),", whereas the current value of ",(0,t.jsx)(n.code,{children:".waitLast"})," is\nretained."]}),"\n",(0,t.jsxs)(n.p,{children:["When the ",(0,t.jsx)(n.code,{children:"Future"})," completes, the following is printed:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:".awaited: 2\n.waitLast: 2\n"})}),"\n",(0,t.jsx)(n.h2,{id:"checking-if-complete",children:"Checking if Complete"}),"\n",(0,t.jsxs)(n.p,{children:["All cells holding a ",(0,t.jsx)(n.code,{children:"Future"})," provide an ",(0,t.jsx)(n.code,{children:"isCompleted"})," property which\nreturns a cell that is ",(0,t.jsx)(n.code,{children:"true"})," when the ",(0,t.jsx)(n.code,{children:"Future"})," is complete, and\n",(0,t.jsx)(n.code,{children:"false"})," while it is still pending."]}),"\n",(0,t.jsx)(n.p,{children:"This allows other cells to check if, and be notified of, an\nasynchronous operation has completed or whether its still in\nprogress."}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final complete = Future.delayed(Duration(seconds: 10))\n    .cell\n    .isCompleted\n    \nValueCell.watch(() {\n    if (complete()) {\n        print('Complete');\n    }\n    else {\n        print('Loading...');\n    }\n});\n"})}),"\n",(0,t.jsxs)(n.p,{children:['Initially "Loading..." is printed to the console. When the ',(0,t.jsx)(n.code,{children:"Future"}),'\ncompletes, after ten seconds, "Complete" is printed.']}),"\n",(0,t.jsxs)(n.p,{children:["When the cell holding the ",(0,t.jsx)(n.code,{children:"Future"})," is updated, the value of\n",(0,t.jsx)(n.code,{children:"isCompleted"})," is also updated to reflect the state of the new\n",(0,t.jsx)(n.code,{children:"Future"}),"."]}),"\n",(0,t.jsx)(n.h2,{id:"async-state",children:"Async State"}),"\n",(0,t.jsxs)(n.p,{children:["The\n",(0,t.jsx)(n.a,{href:"https://pub.dev/documentation/live_cells/latest/live_cells/WaitCellExtension/asyncState.html",children:(0,t.jsx)(n.code,{children:".asyncState"})}),"\nproperty of cells holding ",(0,t.jsx)(n.code,{children:"Future"}),"s returns a cell that evaluates to\nan\n",(0,t.jsx)(n.a,{href:"https://pub.dev/documentation/live_cells/latest/live_cells/AsyncState-class.html",children:(0,t.jsx)(n.code,{children:"AsyncState"})}),"\ndescribing the state of the ",(0,t.jsx)(n.code,{children:"Future"}),". This class a sealed union of the\nfollowing classes, each of which represents a different state of the\n",(0,t.jsx)(n.code,{children:"Future"}),":"]}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsx)(n.p,{children:(0,t.jsx)(n.a,{href:"https://pub.dev/documentation/live_cells/latest/live_cells/AsyncStateLoading-class.html",children:(0,t.jsx)(n.code,{children:"AsyncStateLoading"})})}),"\n",(0,t.jsxs)(n.p,{children:["This represents the state of a ",(0,t.jsx)(n.code,{children:"Future"})," that is still pending."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsx)(n.p,{children:(0,t.jsx)(n.a,{href:"https://pub.dev/documentation/live_cells/latest/live_cells/AsyncStateData-class.html",children:(0,t.jsx)(n.code,{children:"AsyncStateData"})})}),"\n",(0,t.jsxs)(n.p,{children:["This represents the state of a ",(0,t.jsx)(n.code,{children:"Future"})," that has successfully\ncompleted with a value, accessible via the ",(0,t.jsx)(n.code,{children:".value"})," property."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsx)(n.p,{children:(0,t.jsx)(n.a,{href:"https://pub.dev/documentation/live_cells/latest/live_cells/AsyncStateError-class.html",children:(0,t.jsx)(n.code,{children:"AsyncStateError"})})}),"\n",(0,t.jsxs)(n.p,{children:["This represents the state of a ",(0,t.jsx)(n.code,{children:"Future"})," that has completed with an\nerror. The exception thrown is accessible via the ",(0,t.jsx)(n.code,{children:".error"})," property."]}),"\n"]}),"\n"]}),"\n",(0,t.jsxs)(n.p,{children:["This allows you to handle the different states using a ",(0,t.jsx)(n.code,{children:"switch"})," state\nand pattern matching."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"CellWidget.builder((_) {\n    FutureCell<String> futureCell;\n    ...\n    \n    return switch(futureCell.asyncState()) {\n      AsyncStateLoading() => Text('Loading...'),\n      AsyncStateData(:final value) => Text(value),\n      AsyncStateError(:final error) => Text('Error: $error')\n    };\n});\n"})}),"\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:"AsyncState"})," class also provides the following properties:"]}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsx)(n.p,{children:(0,t.jsx)(n.code,{children:"isData"})}),"\n",(0,t.jsxs)(n.p,{children:["Does the state represent a ",(0,t.jsx)(n.code,{children:"Future"})," which has completed to a ",(0,t.jsx)(n.code,{children:"value"}),"."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsx)(n.p,{children:(0,t.jsx)(n.code,{children:"isError"})}),"\n",(0,t.jsxs)(n.p,{children:["Does the state represent a ",(0,t.jsx)(n.code,{children:"Future"})," which completed with an ",(0,t.jsx)(n.code,{children:"error"}),"."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsx)(n.p,{children:(0,t.jsx)(n.code,{children:"isLoading"})}),"\n",(0,t.jsxs)(n.p,{children:["Does the state represent a ",(0,t.jsx)(n.code,{children:"Future"})," that is still pending."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsx)(n.p,{children:(0,t.jsx)(n.code,{children:"lastValue"})}),"\n",(0,t.jsx)(n.p,{children:"The last value that was loaded successfully."}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:["If the state is an ",(0,t.jsx)(n.code,{children:"AsyncStateData"})," this is identical to the\n",(0,t.jsx)(n.code,{children:"value"})," property."]}),"\n",(0,t.jsxs)(n.li,{children:["If the state is an ",(0,t.jsx)(n.code,{children:"AsyncStateLoading"})," or ",(0,t.jsx)(n.code,{children:"AsyncStateError"}),", this\nis the ",(0,t.jsx)(n.code,{children:"value"})," of the last ",(0,t.jsx)(n.code,{children:"AsyncStateData"})," to be held in the cell."]}),"\n"]}),"\n",(0,t.jsxs)(n.p,{children:["If a value hasn't been loaded successfully yet, the value of this\nproperty is ",(0,t.jsx)(n.code,{children:"null"}),"."]}),"\n",(0,t.jsx)(n.admonition,{type:"important",children:(0,t.jsxs)(n.p,{children:["If you replace a ",(0,t.jsx)(n.code,{children:"Future"})," ",(0,t.jsx)(n.code,{children:"a"})," held in the cell with another ",(0,t.jsx)(n.code,{children:"Future"}),"\n",(0,t.jsx)(n.code,{children:"b"})," while ",(0,t.jsx)(n.code,{children:"a"})," is still pending, ",(0,t.jsx)(n.code,{children:"lastValue"})," will never be equal to\nthe completed value of ",(0,t.jsx)(n.code,{children:"a"})," even if it completes successfully and ",(0,t.jsx)(n.code,{children:"b"}),"\ncompletes with an error."]})}),"\n"]}),"\n"]}),"\n",(0,t.jsx)(n.h2,{id:"delays-and-debouncing",children:"Delays and Debouncing"}),"\n",(0,t.jsxs)(n.p,{children:["Live Cells provides a ",(0,t.jsx)(n.code,{children:"delayed(...)"})," method on cells. This method\nreturns a cell that holds a ",(0,t.jsx)(n.code,{children:"Future"})," that completes with the same\nvalue as the value of the cell, on which ",(0,t.jsx)(n.code,{children:"delayed"})," was called, but\nafter a given delay."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Example of .delayed(...)"',children:"final n = MutableCell(0);\n\nValueCell.watch(() {\n    final value = n.delayed(Duration(seconds: 3)).wait;\n    print('$value');\n});\n\nn.value = 1;\nn.value = 2;\nn.value = 3;\n"})}),"\n",(0,t.jsx)(n.p,{children:"This will result in the following being printed to the console after a delay of three seconds:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{children:"1\n2\n3\n"})}),"\n",(0,t.jsx)(n.admonition,{type:"important",children:(0,t.jsxs)(n.p,{children:["The delay is from the time the value is assigned to the cell, and not\nsince the last time the ",(0,t.jsx)(n.code,{children:"delayed"})," cell was updated. This means that in\nthe above example all three values are printed at once, since they are\nassigned to the cell at approximately the same time."]})}),"\n",(0,t.jsx)(n.admonition,{type:"tip",children:(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"delayed(...)"})," returns a keyed cell which is why we were able to use\nit directly in the watch function without assigning the returned cell\nto a local variable first."]})}),"\n",(0,t.jsxs)(n.p,{children:["When ",(0,t.jsx)(n.code,{children:"delayed(...)"})," is used with ",(0,t.jsx)(n.code,{children:".waitLast"}),", the result is\neffectively a ",(0,t.jsx)(n.em,{children:"debouncing"}),' of the cell\'s value. Debouncing is a\ntechnique for preventing a task, in this case updating the value of a\ncell, from running too frequently. This is especially useful for\nimplementing a "search as you type" functionality.']}),"\n",(0,t.jsxs)(n.p,{children:["We can demonstrate the effect of ",(0,t.jsx)(n.code,{children:"delayed(...)"})," followed by ",(0,t.jsx)(n.code,{children:"waitLast"}),"\nwith the following widget:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"CellWidget.builder((_) {\n  final content = MutableCell('');\n  final debounced = content\n      .delayed(Duration(seconds: 3)\n      .waitLast\n      .initialValue(''.cell);\n    \n  return Column(\n    children: [\n      CellTextField(\n        content: content\n      ),\n      Text('You wrote:'),\n      CellText(\n        data: debounced\n      )\n    ]\n  );\n});\n"})}),"\n",(0,t.jsxs)(n.p,{children:["In this example, we've bound a cell to the content of a\n",(0,t.jsx)(n.code,{children:"CellTextField"}),". We've ",(0,t.jsx)(n.em,{children:"debounced"})," the cell with\n",(0,t.jsx)(n.code,{children:"delayed(...).waitLast"})," and bound the debounced cell to the data of a\n",(0,t.jsx)(n.code,{children:"CellText"}),". Whatever you write in the text field is echoed in the\n",(0,t.jsx)(n.code,{children:"CellText"})," below it but only after a three second delay after you\nstop typing."]}),"\n",(0,t.jsxs)(n.p,{children:["Practically, to implement a search as you type functionality, you'd\nreference the ",(0,t.jsx)(n.code,{children:"debounced"})," cell in an asynchronous computed cell which\nloads the search results from a backend server:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final search = MutableCell('');\nfinal debounced = search\n    .delayed(Duration(seconds: 3))\n    .waitLast;\n    \nfinal results = ValueCell.computed(() async {\n    // A hypothetical searchItems function which\n    // performs the HTTP request\n    return await searchItems(debounced());\n});\n"})}),"\n",(0,t.jsx)(n.p,{children:"This would be used with a UI definition similar to the following:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"Column(\n  children: [\n    // A text field for the search term\n    CellTextField(content: search),\n    \n    // Display results\n    CellWidget.builder((_) {\n      items = results.waitLast\n            .initialValue(const [].cell);\n            \n      Column(\n        children: items()\n            .map((e) => ItemWidget(e))\n            .toList()\n      );\n    });\n  ]\n);\n"})})]})}function h(e={}){const{wrapper:n}={...(0,i.R)(),...e.components};return n?(0,t.jsx)(n,{...e,children:(0,t.jsx)(o,{...e})}):o(e)}},8453:(e,n,l)=>{l.d(n,{R:()=>a,x:()=>c});var t=l(6540);const i={},s=t.createContext(i);function a(e){const n=t.useContext(s);return t.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function c(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(i):e.components||i:a(e.components),t.createElement(s.Provider,{value:n},e.children)}}}]);