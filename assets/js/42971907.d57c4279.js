"use strict";(self.webpackChunkmy_website_2=self.webpackChunkmy_website_2||[]).push([[664],{9922:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>a,contentTitle:()=>s,default:()=>h,frontMatter:()=>o,metadata:()=>r,toc:()=>d});var i=t(4848),l=t(8453);const o={title:"Why Live Cells?"},s="Why Live Cells?",r={type:"mdx",permalink:"/live_cells/why-live-cells",source:"@site/src/pages/why-live-cells.md",title:"Why Live Cells?",description:"There are plenty of similar libraries out there. So why should you use",frontMatter:{title:"Why Live Cells?"},unlisted:!1},a={},d=[{value:"Why not StatefulWidget?",id:"why-not-statefulwidget",level:2},{value:"Why not ValueNotifier?",id:"why-not-valuenotifier",level:2},{value:"Why not ChangeNotifier?",id:"why-not-changenotifier",level:2},{value:"Why not other libraries?",id:"why-not-other-libraries",level:2},{value:"Two-way data flow",id:"two-way-data-flow",level:3},{value:"Flexibility",id:"flexibility",level:3},{value:"Unobtrusive",id:"unobtrusive",level:3},{value:"Widgets library",id:"widgets-library",level:3}];function c(e){const n={a:"a",admonition:"admonition",code:"code",em:"em",h1:"h1",h2:"h2",h3:"h3",li:"li",ol:"ol",p:"p",pre:"pre",strong:"strong",...(0,l.R)(),...e.components};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)(n.h1,{id:"why-live-cells",children:"Why Live Cells?"}),"\n",(0,i.jsx)(n.p,{children:"There are plenty of similar libraries out there. So why should you use\nLive Cells in particular?"}),"\n",(0,i.jsx)(n.h2,{id:"why-not-statefulwidget",children:"Why not StatefulWidget?"}),"\n",(0,i.jsxs)(n.p,{children:[(0,i.jsx)(n.code,{children:"StatefulWidget"})," and ",(0,i.jsx)(n.code,{children:"setState"})," are excellent tools for managing state\nthat is local to a single widget, and passing that state down the\nwidget hierarchy. However ",(0,i.jsx)(n.code,{children:"StatefulWidget"})," is not a great tool for\nmanaging global application state, nor is it capable of passing data\nup the widget hierarchy. To pass data from a child widget to its\nparent, you have to pass callback functions."]}),"\n",(0,i.jsx)(n.p,{children:'For example to implement a "counter" widget that provides a button for\nincrementing a counter value, which is stored in the parent of the\n"counter" widget, you have to do something similar to the following:'}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class Counter extends StatelessWidget {\n    final int count;\n    \n    final void Function(int) onChanged;\n    \n    Counter({\n        required this.count,\n        required this.onChanged\n    });\n    \n    @override\n    Widget build(BuildContext context) {\n        return ElevatedButton(\n            child: Text(count.toString()),\n            onPressed: () => onChanged(count + 1) \n        );\n    }\n}\n"})}),"\n",(0,i.jsx)(n.p,{children:"To use this widget, you would do something similar to the following :"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class Parent extends StatefulWidget {\n    @override\n    State<Parent> createState() => _ParentState();\n}\n\nclass _ParentState extends State<Parent> {\n    var _count = 0;\n    \n    @override\n    Widget build(BuildContext context) => Column(\n      children: [\n        Text('Count is $_count'),\n        Counter(\n            count: _count,\n            onChanged: (count) => setState(() {\n                _count = count;\n            })\n        )\n      ]\n    );\n}\n"})}),"\n",(0,i.jsx)(n.p,{children:"Now let's compare this with an implementation using Live Cells:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class Counter extends CellWidget {\n    final MutableCell<int> count;\n    \n    Counter(this.count);\n    \n    @override\n    Widget build(BuildContext context) {\n        return ElevatedButton(\n            child: Text(count().toString()),\n            onPressed: () => count.value++\n        );\n    }\n}\n"})}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class Parent extends CellWidget {\n    @override\n    Widget build(BuildContext context) {\n        final count = MutableCell(0);\n        \n        return Column(\n          children: [\n            Text('Count is ${count()}'),\n            Counter(count)\n          ]\n        );\n    }\n}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["Notice the version using Live Cells version does not require an\n",(0,i.jsx)(n.code,{children:"onChanged"})," callback in the ",(0,i.jsx)(n.code,{children:"Counter"})," widget. Only the cell holding\nthe counter value is passed. The ",(0,i.jsx)(n.code,{children:"Counter"})," widget increments the\nvalue held in the cell directly, and the parent widget is\nautomatically rebuilt with the new counter value."]}),"\n",(0,i.jsx)(n.p,{children:"So what's the big deal with callbacks?"}),"\n",(0,i.jsxs)(n.ol,{children:["\n",(0,i.jsxs)(n.li,{children:["You're duplicating the state synchronization code wherever you use\nthe ",(0,i.jsx)(n.code,{children:"Counter"})," widget."]}),"\n",(0,i.jsxs)(n.li,{children:["If you have multiple counters with different values, there's more\nroom for mistakes by setting the wrong counter value, e.g. doing\n",(0,i.jsx)(n.code,{children:"_count1 = count"})," instead of ",(0,i.jsx)(n.code,{children:"_count2 = count"}),"."]}),"\n",(0,i.jsxs)(n.li,{children:["If the counter is stored in a widget that is even higher up the\nhierarchy, you have to prop-drill callbacks all the way down to the\n",(0,i.jsx)(n.code,{children:"Counter"})," widget. With cells you just pass the cell holding the\ncounter."]}),"\n"]}),"\n",(0,i.jsx)(n.h2,{id:"why-not-valuenotifier",children:"Why not ValueNotifier?"}),"\n",(0,i.jsxs)(n.p,{children:["Doesn't ",(0,i.jsx)(n.code,{children:"ValueNotifier"})," already perform the function of cells,\ndescribed above? Yes it does, but a cell can also be defined as a\nfunction of other cells. For example imagine you have two counters,\nyou can define a cell that evaluates to the sum of the counters,\nusing:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final sum = ValueCell.computed(() => count1() + count2());\n"})}),"\n",(0,i.jsxs)(n.p,{children:["The ",(0,i.jsx)(n.code,{children:"sum"})," cell defined above is automatically recomputed when either\none of ",(0,i.jsx)(n.code,{children:"count1"})," or ",(0,i.jsx)(n.code,{children:"count2"})," change. This cell can then be observed\njust like any other cell."]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class Parent extends CellWidget {\n    @override\n    Widget build(BuildContext context) {\n        final count1 = MutableCell(0);\n        final count2 = MutableCell(0);\n        \n        final sum = ValueCell.computed(() => count1() + count2());\n        \n        return Column(\n          children: [\n              Text('${count1()} + ${count2()} = ${sum()}'),\n              Counter(count1),\n              Counter(count2)\n          ]\n        );\n    }\n}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["This cannot be done easily with ",(0,i.jsx)(n.code,{children:"ValueNotifier"}),", you either have to\nsubclass it or implement your own ",(0,i.jsx)(n.code,{children:"ValueListenable"}),", or manually add\nand remove listeners to both ",(0,i.jsx)(n.code,{children:"ValueNotifier"}),"s in the widget."]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class _ParentState extends State<Parent> {\n    final count1 = ValueNotifier(0);\n    final count2 = ValueNotifier(0);\n    \n    final sum = 0;\n    \n    void _updateSum() {\n        setState(() {\n            sum = count1.value + count2.value;\n        });\n    }\n    \n    @override\n    void initState() {\n        super.initState();\n        \n        count1.addListener(_updateSum);\n        count2.addListener(_updateSum);\n    }\n    \n    @override\n    void dispose() {\n        count1.dispose();\n        count2.dispose();\n        \n        super.dispose();\n    }\n    \n    @override\n    Widget build(BuildContext context) {\n        return Column(\n          children: [\n              Text('${count1.value} + ${count2.value} = $sum'),\n              Counter(count1),\n              Counter(count2)\n          ]\n        );\n    }\n}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["Besides being more verbose, this is also more error prone. You could\neasily forget to add a listener, or forget to dispose a\n",(0,i.jsx)(n.code,{children:"ValueNotifier"}),". Live Cells takes care of all of that for you so you\ncan focus only on your application logic."]}),"\n",(0,i.jsx)(n.h2,{id:"why-not-changenotifier",children:"Why not ChangeNotifier?"}),"\n",(0,i.jsxs)(n.p,{children:["Why not just put both counters in a single ",(0,i.jsx)(n.code,{children:"ChangeNotifier"})," instead of\ntwo ",(0,i.jsx)(n.code,{children:"ValueNotifier"}),"s? Something similar to the following:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class SumNotifier extends ChangeNotifier {\n    final _count1 = 0;\n    final _count2 = 0;\n    \n    int get count1 => _count1;\n    \n    set count1(int value) {\n        _count1 = value;\n        notifyListeners();\n    }\n    \n    int get count2 => _count2;\n    \n    set count2(int value) {\n        _count2 = value;\n        notifyListeners();\n    }\n    \n    int get sum => _count1 + _count2;\n}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["What do you do if one of the counter values is stored in the ",(0,i.jsx)(n.code,{children:"Parent"}),"\nwidget, but the other needs to be stored even higher up the widget\nhierarchy, which means you cannot store both counters in a single\n",(0,i.jsx)(n.code,{children:"ChangeNotifier"}),"? You'll just run into the same problem."]}),"\n",(0,i.jsx)(n.p,{children:"With Live Cells this is as simple as:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class Parent extends CellWidget {\n    final MutableCell<int> count1;\n    \n    Parent(this.count1);\n    \n    @override\n    Widget build(BuildContext context) {\n        final count2 = MutableCell(0);\n        \n        final sum = ValueCell.computed(() => count1() + count2());\n        \n        return Column(\n          children: [\n              Text('${count1()} + ${count2()} = ${sum()}'),\n              Counter(count1),\n              Counter(count2)\n          ]\n        );  \n    }\n}\n"})}),"\n",(0,i.jsx)(n.h2,{id:"why-not-other-libraries",children:"Why not other libraries?"}),"\n",(0,i.jsxs)(n.p,{children:["Other libraries also provide equivalent functionality to\n",(0,i.jsx)(n.code,{children:"ValueCell.computed"}),", some of them even with the same syntax. So why\nshould you use Live Cells?"]}),"\n",(0,i.jsx)(n.h3,{id:"two-way-data-flow",children:"Two-way data flow"}),"\n",(0,i.jsxs)(n.p,{children:["There are plenty of libraries which provide equivalent functionality\nto ",(0,i.jsx)(n.code,{children:"ValueCell.computed"}),". However ",(0,i.jsx)(n.code,{children:"ValueCell.computed"})," has a\nfundamental limitation in that it only defines a unidirectional flow of\ndata."]}),"\n",(0,i.jsx)(n.p,{children:"For example in the following:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final n = MutableCell(0);\nfinal strN = ValueCell.computed(() => n().toString());\n"})}),"\n",(0,i.jsxs)(n.p,{children:["Data can flow from ",(0,i.jsx)(n.code,{children:"n"})," to ",(0,i.jsx)(n.code,{children:"strN"}),", which converts the integer held in\n",(0,i.jsx)(n.code,{children:"n"})," to a string, but data can never flow from ",(0,i.jsx)(n.code,{children:"strN"})," to ",(0,i.jsx)(n.code,{children:"n"}),"."]}),"\n",(0,i.jsxs)(n.p,{children:["Live Cells also provides ",(0,i.jsx)(n.code,{children:"MutableCell.computed"}),", which allows you to\ndefine the data flow in both directions:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final n = MutableCell(0);\nfinal strN = MutableCell.computed(() => n().toString(), (str) {\n    n.value = int.tryParse(str) ?? 0;\n});\n"})}),"\n",(0,i.jsxs)(n.p,{children:["In this example when an integer value is assigned to ",(0,i.jsx)(n.code,{children:"n"}),", ",(0,i.jsx)(n.code,{children:"strN"})," is\nautomatically updated to the string representation of the value that\nwas assigned:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"n.value = 0;\nprint(strN.value); // 0\n\nn.value = 5;\nprint(strN.value); // 5\n"})}),"\n",(0,i.jsxs)(n.p,{children:["A string value can also be assigned to ",(0,i.jsx)(n.code,{children:"strN"}),". In this case, an\ninteger is parsed from the value that was assigned, and is assigned to\n",(0,i.jsx)(n.code,{children:"n"}),"."]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"strN.value = '10';\nprint(n.value + 1); // 11\n\nstrN.value = '15';\nprint(n.value + 1); // 16\n"})}),"\n",(0,i.jsxs)(n.p,{children:["This is very useful for implementing data conversions while exchanging\ndata between a child and parent widget. In-fact this pattern is so\ncommon that Live Cells packages this definition of ",(0,i.jsx)(n.code,{children:"strN"})," in a\n",(0,i.jsx)(n.code,{children:".mutableString()"})," method. So ",(0,i.jsx)(n.code,{children:"strN"})," can be defined using:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final strN = n.mutableString();\n"})}),"\n",(0,i.jsxs)(n.p,{children:["Now let's put this to practical use. Imagine that instead of a button,\nthe ",(0,i.jsx)(n.code,{children:"Counter"})," widget should provide a text field for entering the\ncounter value directly."]}),"\n",(0,i.jsx)(n.p,{children:"With Live Cells this can be done easily using two-way data flow:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class Counter extends CellWidget {\n    final MutableCell<int> count;\n    \n    Counter(this.count);\n    \n    @override\n    Widget build(BuildContext context) {\n        return CellTextField(\n            content: count.mutableString()\n        );\n    }\n}\n"})}),"\n",(0,i.jsxs)(n.admonition,{type:"info",children:[(0,i.jsxs)(n.p,{children:[(0,i.jsx)(n.code,{children:"CellTextField"})," is a widget provided by the ",(0,i.jsx)(n.strong,{children:"Live Cell Widgets"})," library\nthat binds the content of a ",(0,i.jsx)(n.code,{children:"TextField"})," to the cell provided\nin the ",(0,i.jsx)(n.code,{children:"content"})," parameter of the constructor."]}),(0,i.jsx)(n.p,{children:"When the value of the cell changes, the content of the field is\nupdated, and similarly when the content changes, the value of the cell\nis updated."})]}),"\n",(0,i.jsx)(n.p,{children:"That's it, we were able to achieve that without callback functions or\nmanually adding listeners."}),"\n",(0,i.jsxs)(n.p,{children:["No other library (to the best of my knowledge) provides anything\nequivalent to ",(0,i.jsx)(n.code,{children:"MutableCell.computed"}),", and hence cannot implement the\nexample above as succinctly as Live Cells."]}),"\n",(0,i.jsxs)(n.p,{children:["If we were to rely only on ",(0,i.jsx)(n.code,{children:"ValueCell.computed"})," (An equivalent of\nwhich is provided by most other libraries), we would have to do\nsomething similar to the following:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final Counter extends StatefulWidget {\n    final MutableCell<int> count;\n    \n    Counter(this.count);\n    \n    @override\n    State<Counter> createState() => _CounterState();\n}\n\nclass _CounterState extends State<Counter> {\n    final _controller = TextEditingController();\n    \n    @override\n    void initState() {\n        super.initState();\n        _controller.text = widget.count.value.toString();\n    }\n    \n    @override\n    void dispose() {\n        _controller.dispose();\n        super.dispose();\n    }\n    \n    @override\n    Widget build(BuildContext context) {\n        return TextField(\n            controller: _controller,\n            onChanged: (str) {\n                count.value = int.tryParse(str) ?? 0;\n            }\n        );\n    }\n}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["Besides being verbose and error prone (this is becoming a common\ntheme), a bug could easily be introduced if your forget to initialize\nthe ",(0,i.jsx)(n.code,{children:"text"})," property of the ",(0,i.jsx)(n.code,{children:"TextEditingController"})," or you forget to\ndispose it, this definition is not even equivalent to the previous definition\nusing ",(0,i.jsx)(n.code,{children:"mutableString()"}),"."]}),"\n",(0,i.jsxs)(n.p,{children:["In the previous definition if the value of the ",(0,i.jsx)(n.code,{children:"count"})," cell is\nchanged, regardless of where it is changed from, the global state, a\nwidget higher up the hierarchy, or within the ",(0,i.jsx)(n.code,{children:"Counter"})," widget itself,\nthe content of the text field is updated to reflect the new counter\nvalue. With this implementation, the content of the text field is no\nlonger updated when the value of the counter is changed. We've lost\nreactivity and now the state of our widgets is no longer in sync with\nour application state."]}),"\n",(0,i.jsxs)(n.p,{children:["To fix this implementation we'd have to add a listener on the\n",(0,i.jsx)(n.code,{children:"count"})," cell, which we can do with ",(0,i.jsx)(n.code,{children:"ValueCell.watch"})," and manually\nsynchronize the state of the ",(0,i.jsx)(n.code,{children:"TextField"})," with our cell. Something\nsimilar to the following:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"late final CellWatcher _watcher;\n\nvar _suppressChanges = false;\n\n@override\nvoid initState() {\n    ...\n    _watcher = ValueCell.watch(() {\n        if (!_suppressChanges) {\n            _controller.text = count().toString();\n        }\n    });\n}\n\n@override\nvoid dispose() {\n    ...\n    _watcher.stop();\n}\n\n@overidde\nWidget build(BuildContext context) {\n    return TextField(\n        controller: _controller,\n        onChanged: (str) {\n            _suppressChanges = true;\n            count.value = int.tryParse(str) ?? 0;\n            _suppressChanges = false;\n        }\n    );\n}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["Wow, that's a lot of boilerplate and that's not even all of it. We had\nto add a listener on the ",(0,i.jsx)(n.code,{children:"count"})," cell in ",(0,i.jsx)(n.code,{children:"initState"})," to keep the\ncontent of the text field (the ",(0,i.jsx)(n.code,{children:"text"})," property of the\n",(0,i.jsx)(n.code,{children:"TextEditingController"}),") in sync with the value of the cell. We also\nhad to add a guard ",(0,i.jsx)(n.code,{children:"_suppressChanges"})," to prevent changes to the value\nof the ",(0,i.jsx)(n.code,{children:"count"})," cell, that are triggered by the ",(0,i.jsx)(n.code,{children:"onChanged"})," callback,\nfrom causing unnecessary updates to the ",(0,i.jsx)(n.code,{children:"TextEditingController"}),"."]}),"\n",(0,i.jsxs)(n.p,{children:["You can tell that the code is becoming unwieldy. In-fact, it's uglier\nthan a simpler implementation that forgoes cells, ",(0,i.jsx)(n.code,{children:"ValueNotifier"}),"s, or\nanother library's primitive in favour of ",(0,i.jsx)(n.code,{children:"setState"}),", callbacks and\n",(0,i.jsx)(n.code,{children:"didUpdateWidget"}),", and that's what many developers do. However, then\nyou end up with the issues outlined in ",(0,i.jsx)(n.a,{href:"#why-not-statefulwidget",children:"Why not\nStatefulWidget"}),". Without two-way data flow,\nreactive programming is essentially useless in situations such as these."]}),"\n",(0,i.jsxs)(n.p,{children:["Whilst we used the primitives of Live Cells (",(0,i.jsx)(n.code,{children:"ValueCell.computed"})," and\n",(0,i.jsx)(n.code,{children:"ValueCell.watch"}),"), since similar primitives are provided by other\nlibraries, every library that does not offer an equivalent to\n",(0,i.jsx)(n.code,{children:"MutableCell.computed"}),", which hardly any if any at all do, will suffer\nfrom the same limitations."]}),"\n",(0,i.jsx)(n.h3,{id:"flexibility",children:"Flexibility"}),"\n",(0,i.jsx)(n.p,{children:"Cells can be used both to manage global and widget state. Whilst this\nis not exclusive to Live Cells, I know of no other library where you\ncan define the widget state directly in the build method using exactly\nthe same definitions as you would for global state."}),"\n",(0,i.jsx)(n.p,{children:"For example this is widget local state (we've already seen this):"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class Counter extends CellWidget {\n    @override\n    Widget build(BuildContext context) {\n        final count = MutableCell(0);\n        \n        return ElevatedButton(\n            child: Text('${count()}'),\n            onPressed: () => count.value++\n        );\n    }\n}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["Let's say for some reason we want a global counter shared by all\n",(0,i.jsx)(n.code,{children:"Counter"})," widgets throughout our app. All we have to do is move the\ndefinition of ",(0,i.jsx)(n.code,{children:"count"})," outside the widget:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final count = MutableCell(0);\n\nclass Counter extends CellWidget {\n    @override\n    Widget build(BuildContext context) {\n        return ElevatedButton(\n            child: Text('${count()}'),\n            onPressed: () => count.value++\n        );\n    }\n}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["The code defining the ",(0,i.jsx)(n.code,{children:"count"})," cell is exactly the same in both case,\nthe only difference is where its placed."]}),"\n",(0,i.jsx)(n.h3,{id:"unobtrusive",children:"Unobtrusive"}),"\n",(0,i.jsx)(n.p,{children:"Cells are designed to be indistinguishable from the values they hold\nas much as possible. For example you can define cells directly as an\nexpression of other cells:"}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final sum = a + b;\n"})}),"\n",(0,i.jsxs)(n.p,{children:["This defines a cell (",(0,i.jsx)(n.code,{children:"sum"}),") that computes the sum of the values of\ncells ",(0,i.jsx)(n.code,{children:"a"})," and ",(0,i.jsx)(n.code,{children:"b"}),"."]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final elem = list[index];\n"})}),"\n",(0,i.jsxs)(n.p,{children:["This defines a cell (",(0,i.jsx)(n.code,{children:"elem"}),") that retrieves the element at the index\nheld in cell ",(0,i.jsx)(n.code,{children:"index"})," of the list held in cell ",(0,i.jsx)(n.code,{children:"list"}),"."]}),"\n",(0,i.jsxs)(n.p,{children:["With\n",(0,i.jsx)(n.a,{href:"https://pub.dev/packages/live_cell_extension",children:"live_cell_extension"}),",\n",(0,i.jsxs)(n.em,{children:["which you can read more about\n",(0,i.jsx)(n.a,{href:"/docs/basics/user-defined-types",children:"here"})]}),", you can access properties of\nyour own types using almost the same syntax as you would use if you\nwere dealing with the values directly:"]}),"\n",(0,i.jsxs)(n.p,{children:["For example consider the following ",(0,i.jsx)(n.code,{children:"Person"})," class:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"class Person {\n    final String name;\n    final int age;\n    \n    const Person({\n        this.name,\n        this.age\n    });\n}\n"})}),"\n",(0,i.jsxs)(n.p,{children:["With ",(0,i.jsx)(n.code,{children:"live_cell_extension"})," you can create a cell that access a\nproperty of a ",(0,i.jsx)(n.code,{children:"Person"})," held in another cell using the following:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final person = MutableCell(\n    Person(\n        name: 'John Smith',\n        age: 25\n    )\n);\n\n// Create a cell that accesses the `name` property\nfinal name = person.name;\n\n// Create a cell that accesses the `age` property\nfinal age = person.age\n"})}),"\n",(0,i.jsxs)(n.p,{children:["The code used is exactly the same as if you were accessing the\nproperties directly on a ",(0,i.jsx)(n.code,{children:"Person"})," value. Most other libraries require\nyou to define ",(0,i.jsx)(n.em,{children:"selectors"})," using something similar to the following:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final name = person.select((p) => p.name);\n"})}),"\n",(0,i.jsx)(n.p,{children:"Notice you didn't have to define custom subclasses, providers, or\nselectors, which a lot of other libraries require even for simple\nexamples such as these. Live Cells tries to make working with cells as\nclose as possible to working with raw values."}),"\n",(0,i.jsx)(n.h3,{id:"widgets-library",children:"Widgets library"}),"\n",(0,i.jsxs)(n.p,{children:["Live Cells also comes with a widgets library, ",(0,i.jsxs)(n.em,{children:["which you can read more\nabout ",(0,i.jsx)(n.a,{href:"/docs/basics/live-cell-widgets",children:"here"})]}),", that allows you to bind\ncells directly to widget properties. We've already seen one such\nexample ",(0,i.jsx)(n.code,{children:"CellTextField"}),":"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"final contentCell = MutableCell('');\n\nCellTextField(\n    content: contentCell\n)\n"})}),"\n",(0,i.jsxs)(n.p,{children:[(0,i.jsx)(n.code,{children:"CellTextField"})," is a the Live Cells equivalent of Flutter's\n",(0,i.jsx)(n.code,{children:"TextField"}),", which allows you to bind its properties directly to\ncells. In the example above, the content of the field is bound to\n",(0,i.jsx)(n.code,{children:"contentCell"}),". This means whenever the content of the field changes,\nthe value of ",(0,i.jsx)(n.code,{children:"contentCell"})," is updated. Likewise whenever the value of\n",(0,i.jsx)(n.code,{children:"contentCell"})," changes, the content of the field is updated."]}),"\n",(0,i.jsxs)(n.p,{children:["Besides ",(0,i.jsx)(n.code,{children:"CellTextField"}),", this library also provides ",(0,i.jsx)(n.code,{children:"CellSwitch"}),",\n",(0,i.jsx)(n.code,{children:"CellCheckbox"}),", ",(0,i.jsx)(n.code,{children:"CellRadio"})," and many other widgets. This is not\nlimited to widgets for acquiring user input but also widgets which are\nused purely for presenting data such as ",(0,i.jsx)(n.code,{children:"CellText"}),"."]}),"\n",(0,i.jsx)(n.admonition,{type:"info",children:(0,i.jsx)(n.p,{children:"These are not reimplementations of Flutter's widgets but wrappers over\nthem."})}),"\n",(0,i.jsxs)(n.p,{children:["For example the ",(0,i.jsx)(n.code,{children:"data"})," property of a ",(0,i.jsx)(n.code,{children:"CellText"})," (Live Cells equivalent\nof Flutter's ",(0,i.jsx)(n.code,{children:"Text"}),") can be bound to the same ",(0,i.jsx)(n.code,{children:"contentCell"})," from the\nprevious example:"]}),"\n",(0,i.jsx)(n.pre,{children:(0,i.jsx)(n.code,{className:"language-dart",children:"CellText(\n    data: contentCell\n)\n"})}),"\n",(0,i.jsxs)(n.p,{children:["The effect of this binding is that whatever text is entered in the\ntext field, from the previous example, will be echoed in the\n",(0,i.jsx)(n.code,{children:"CellText"})," widget."]}),"\n",(0,i.jsx)(n.p,{children:"No other library, to the best of my knowledge, offers anything\nremotely similar to this."})]})}function h(e={}){const{wrapper:n}={...(0,l.R)(),...e.components};return n?(0,i.jsx)(n,{...e,children:(0,i.jsx)(c,{...e})}):c(e)}},8453:(e,n,t)=>{t.d(n,{R:()=>s,x:()=>r});var i=t(6540);const l={},o=i.createContext(l);function s(e){const n=i.useContext(o);return i.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function r(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(l):e.components||l:s(e.components),i.createElement(o.Provider,{value:n},e.children)}}}]);