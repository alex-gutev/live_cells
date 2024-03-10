"use strict";(self.webpackChunkmy_website_2=self.webpackChunkmy_website_2||[]).push([[314],{2268:(e,n,i)=>{i.r(n),i.d(n,{assets:()=>o,contentTitle:()=>r,default:()=>h,frontMatter:()=>l,metadata:()=>c,toc:()=>a});var t=i(4848),s=i(8453);const l={title:"Action Cells",description:"Representing actions and events using cells",sidebar_position:11},r="Action Cells",c={id:"basics/action-cells",title:"Action Cells",description:"Representing actions and events using cells",source:"@site/docs/basics/action-cells.md",sourceDirName:"basics",slug:"/basics/action-cells",permalink:"/live_cells/docs/basics/action-cells",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:11,frontMatter:{title:"Action Cells",description:"Representing actions and events using cells",sidebar_position:11},sidebar:"tutorialSidebar",previous:{title:"Asynchronous Cells",permalink:"/live_cells/docs/basics/async-cells"},next:{title:"Advanced",permalink:"/live_cells/docs/category/advanced"}},o={},a=[{value:"Triggering Actions",id:"triggering-actions",level:2},{value:"Practical Example",id:"practical-example",level:2}];function d(e){const n={a:"a",admonition:"admonition",code:"code",em:"em",h1:"h1",h2:"h2",li:"li",ol:"ol",p:"p",pre:"pre",ul:"ul",...(0,s.R)(),...e.components};return(0,t.jsxs)(t.Fragment,{children:[(0,t.jsx)(n.h1,{id:"action-cells",children:"Action Cells"}),"\n",(0,t.jsxs)(n.p,{children:["An action cell is a cell that does not hold a value. In-fact, the cell\ntype of an action cell is ",(0,t.jsx)(n.code,{children:"ValueCell<void>"}),". The purpose of an action\ncell is to notify its observers when an event, such as a button press,\nhas taken place."]}),"\n",(0,t.jsxs)(n.p,{children:["Action cells are created using the ",(0,t.jsx)(n.code,{children:"ActionCell"})," constructor, and the\nobservers of the cell are notified with the ",(0,t.jsx)(n.code,{children:".trigger()"})," method."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final action = ActionCell();\n\nValueCell.watch(() {\n    action();\n    print('Action triggered');\n});\n\n// Prints: Action triggered\naction.trigger();\n"})}),"\n",(0,t.jsxs)(n.p,{children:["Notice that the action cell is observed, in the watch function, just\nlike a regular cell. The only difference is that calling the cell does\nnot actually return a value, since the value type of the cell is\n",(0,t.jsx)(n.code,{children:"void"}),"."]}),"\n",(0,t.jsxs)(n.p,{children:["To allow observing an ",(0,t.jsx)(n.code,{children:"ActionCell"})," but disallow triggering it, using\nthe ",(0,t.jsx)(n.code,{children:"trigger"})," method, it should be cast to ",(0,t.jsx)(n.code,{children:"ValueCell<void>"}),":"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"class MyControllerClass {\n    // This cell can be triggered with `_myAction.trigger()`.\n    final _myAction = ActionCell();\n    \n    // This cell can be observed but not triggered.\n    ValueCell<void> get myAction => _myAction.\n}\n"})}),"\n",(0,t.jsx)(n.h2,{id:"triggering-actions",children:"Triggering Actions"}),"\n",(0,t.jsx)(n.p,{children:"Besides being used to notify of events, action cells can be used to\ntrigger operations. An example is retrying a failed network request."}),"\n",(0,t.jsx)(n.p,{children:"For example consider an asynchronous cell which performs a network\nrequest:"}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"import 'package:dio/dio.dart';\n\nfinal dio = Dio();\n\nfinal countries = ValueCell.computed(() async {\n    final response = \n        await dio.get('https://api.sampleapis.com/countries/countries');\n        \n    return response.data;\n});\n"})}),"\n",(0,t.jsx)(n.admonition,{type:"note",children:(0,t.jsxs)(n.p,{children:["This example uses the ",(0,t.jsx)(n.a,{href:"https://pub.dev/packages/dio",children:"dio"})," package for\nHTTP requests."]})}),"\n",(0,t.jsx)(n.p,{children:"As the cell is defined in the example above, there is no way to retry\nthe network request if it fails for some reason e.g. the Internet\nconnection is down, the server is down, the request times\nout. Observers of the cell will observe the error and can handle it,\nby displaying an error notice to the user, but there is no way to\noffer a retry functionality to the user."}),"\n",(0,t.jsxs)(n.p,{children:["This is where ",(0,t.jsx)(n.code,{children:"ActionCell"}),"s come in handy. All we need to do to add\nretry functionality is to define an ",(0,t.jsx)(n.code,{children:"ActionCell"}),", which will serve to\ntrigger the retrying of the request, and observe it in our cell defined\nabove."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"final onRetry = ActionCell();\n\nfinal countries = ValueCell.computed(() async {\n    // Observe the retry cell.\n    onRetry();\n    \n    final response = \n        await dio.get('https://api.sampleapis.com/countries/countries');\n        \n    return response.data;\n});\n"})}),"\n",(0,t.jsxs)(n.p,{children:["We've observed the ",(0,t.jsx)(n.em,{children:"retry action cell"})," at the start of the cell\ncomputation function. To retry the network request all we need to do\nis trigger the retry cell with:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"onRetry.trigger();\n"})}),"\n",(0,t.jsxs)(n.p,{children:["This will cause the compute value function of the ",(0,t.jsx)(n.code,{children:"countries"})," cell to\nbe run again, because ",(0,t.jsx)(n.code,{children:"onRetry"})," is observed by ",(0,t.jsx)(n.code,{children:"countries"}),"."]}),"\n",(0,t.jsx)(n.admonition,{type:"tip",children:(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:"ActionCell"}),"s can be defined in the build method/function of a\n",(0,t.jsx)(n.code,{children:"CellWidget"})," just like any other cell."]})}),"\n",(0,t.jsx)(n.h2,{id:"practical-example",children:"Practical Example"}),"\n",(0,t.jsx)(n.p,{children:"This is very handy for implementing a reusable error handling widget\nthat displays the child widget, which displays the result of the\nrequest, if the request was successful or an error notice if it failed\nwith a button to retry the request."}),"\n",(0,t.jsxs)(n.p,{children:["To achieve this we'll need to define a widget that takes a ",(0,t.jsx)(n.code,{children:"child"}),"\nwidget as a cell, and an ",(0,t.jsx)(n.code,{children:"ActionCell"})," for retrying the action."]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Reusable error handling widget"',children:"class ErrorHandler extends CellWidget {\n  final ValueCell<Widget> child;\n  final ActionCell retry;\n    \n  const ErrorHandler({\n    super.key,\n    required this.child,\n    required this.retry\n  });\n    \n    \n  @override\n  Widget build(BuildContext context) {\n    try {\n      return child();\n    } catch (e) {\n      return Column(\n        children: [\n          const Text('Something went wrong!'),\n          ElevatedButton(\n            onPressed: retry.trigger,\n            child: const Text('Retry')\n          )\n        ]\n      );\n    }\n  }\n}\n"})}),"\n",(0,t.jsx)(n.p,{children:"A couple of things to note from this definition:"}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:["The ",(0,t.jsx)(n.code,{children:"child"})," widget is provided as a cell rather than a widget to allow\nus to handles errors using ",(0,t.jsx)(n.code,{children:"try"})," and ",(0,t.jsx)(n.code,{children:"catch"}),"."]}),"\n",(0,t.jsxs)(n.li,{children:["The value of ",(0,t.jsx)(n.code,{children:"child"})," is referenced inside a ",(0,t.jsx)(n.code,{children:"try"})," block, and\nreturned if the child widget is created successfully."]}),"\n",(0,t.jsxs)(n.li,{children:["If an error occurred while computing the ",(0,t.jsx)(n.code,{children:"child"})," widget, an error\nnotice with a retry button is displayed."]}),"\n",(0,t.jsxs)(n.li,{children:["The ",(0,t.jsx)(n.code,{children:"onPressed"})," handler of the retry button calls ",(0,t.jsx)(n.code,{children:"retry.trigger()"}),"\nwhich triggers the retry action."]}),"\n"]}),"\n",(0,t.jsxs)(n.p,{children:["Let's place the definition of the ",(0,t.jsx)(n.code,{children:"countries"})," cell inside a function\nthat creates the cell using a given retry cell:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"ValueCell<List> countries(ValueCell<void> onRetry) => \n    ValueCell.computed(() async {\n        // Observe the retry cell.\n        onRetry();\n    \n        final response = \n            await dio.get('https://api.sampleapis.com/countries/countries');\n        \n        return response.data;\n    });\n"})}),"\n",(0,t.jsx)(n.admonition,{type:"note",children:(0,t.jsx)(n.p,{children:"This example will use the parsed JSON response directly. In production\ncode, you would deserialize the response to a model object."})}),"\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:"ErrorHandler"})," widget can now be used as follows"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",children:"CellWidget.builder((_) {\n  final retry = ActionCell();\n  final results = countries(retry);\n  \n  return ErrorHandler(\n    retry: retry,\n    child: ValueCell.computed(() {\n      final data = results.awaited\n          .initialValue([].cell);\n      \n      return Column(\n        children: [\n          for (final country in data())\n            Text('${country['name']}')\n        ]\n      );\n    })\n  );\n});\n"})}),"\n",(0,t.jsx)(n.p,{children:"Some points to note from this example:"}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsxs)(n.p,{children:["The same retry action cell is passed to the ",(0,t.jsx)(n.em,{children:"countries"})," cell and the\n",(0,t.jsx)(n.code,{children:"ErrorHandler"})," widget. This allows the widget to directly trigger\nthe retry action."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsxs)(n.p,{children:["The child widget is defined in a computed cell, which awaits the\n",(0,t.jsx)(n.code,{children:"Future"})," held in the ",(0,t.jsx)(n.em,{children:"countries"})," cell using ",(0,t.jsx)(n.code,{children:".awaited"}),"."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsxs)(n.p,{children:[(0,t.jsx)(n.code,{children:".initialValue([].cell)"})," is used so that the cell evaluates to the\nempty list while the response is still pending, rather than throwing\nan ",(0,t.jsx)(n.code,{children:"UninitializedCellError"}),"."]}),"\n"]}),"\n"]}),"\n",(0,t.jsx)(n.p,{children:"Notice we've successfuly decoupled the data loading, presentation and\nerror handling steps from each other and factored them out into three\nreusable components:"}),"\n",(0,t.jsxs)(n.ol,{children:["\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.em,{children:"countries"})," cell, which is only concerned with performing the\nHTTP request that loads the data, and doesn't care how that data is\npresented, how errors are handled or how the operation is retried."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:"child"})," widget, which is only concerned with presenting the data to\nthe user when the request is successful, and not handling errors."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:"ErrorHandler"})," widget, which is agnostic to how the data is\nloaded and presented, but is only concerned with handling errors."]}),"\n"]}),"\n"]}),"\n",(0,t.jsxs)(n.p,{children:["And note we were able to achieve all of this reusability and\nseparation of concerns without a mess of callbacks and ",(0,t.jsx)(n.em,{children:"controller"}),"\nobjects."]}),"\n",(0,t.jsxs)(n.p,{children:["We've glossed over styling and UI design in these examples, since\nthat's beyond the scope of this library, but we can make this example\nmore user friendly by providing a loading indication while the data is\nloading, rather than showing an empty list. We can do this easily\nusing, the ",(0,t.jsx)(n.code,{children:".isCompleted"})," property of cells holding a ",(0,t.jsx)(n.code,{children:"Future"}),", and\nthe ",(0,t.jsx)(n.a,{href:"https://pub.dev/packages/skeletonizer",children:"skeletonizer"})," package."]}),"\n",(0,t.jsxs)(n.p,{children:["This is the definition of the ",(0,t.jsx)(n.code,{children:"child"})," widget cell which displays a\nloading indication:"]}),"\n",(0,t.jsx)(n.pre,{children:(0,t.jsx)(n.code,{className:"language-dart",metastring:'title="Displaying a loading indication"',children:"ValueCell.computed(() {\n  final data = results.awaited\n    .initialValue(\n        List.filled(5, { 'name': '' }).cell\n    );\n      \n  return Skeletonizer(\n    enabled: !results.isCompleted()\n    child: Column(\n      children: [\n        for (final country in data())\n          Text('${country['name']}')\n        ]\n    )\n  );\n})\n"})}),"\n",(0,t.jsxs)(n.ul,{children:["\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsxs)(n.p,{children:["The child widget is wrapped in a ",(0,t.jsx)(n.code,{children:"Skeletonizer"}),", from the\n",(0,t.jsx)(n.a,{href:"https://pub.dev/packages/skeletonizer",children:"skeletonizer"})," package, that\ndisplays its children using a shimmer effect while it is enabled."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsxs)(n.p,{children:["The ",(0,t.jsx)(n.code,{children:"Skeletonizer"})," is only enabled when ",(0,t.jsx)(n.code,{children:"isCompleted()"})," is\nfalse,that is when the response is still pending."]}),"\n"]}),"\n",(0,t.jsxs)(n.li,{children:["\n",(0,t.jsxs)(n.p,{children:["The initial data is now set to a list containing five ",(0,t.jsx)(n.em,{children:"dummy"}),"\nitems. These items aren't actually displayed but are required by\n",(0,t.jsx)(n.code,{children:"Skeletonizer"})," to display a shimmer effect."]}),"\n"]}),"\n"]})]})}function h(e={}){const{wrapper:n}={...(0,s.R)(),...e.components};return n?(0,t.jsx)(n,{...e,children:(0,t.jsx)(d,{...e})}):d(e)}},8453:(e,n,i)=>{i.d(n,{R:()=>r,x:()=>c});var t=i(6540);const s={},l=t.createContext(s);function r(e){const n=t.useContext(l);return t.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function c(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:r(e.components),t.createElement(l.Provider,{value:n},e.children)}}}]);