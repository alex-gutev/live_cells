import 'package:example/demos/basics_demo.dart';
import 'package:example/demos/cell_text_field_demo.dart';
import 'package:example/demos/compute_cell_demo1.dart';
import 'package:example/demos/compute_cell_demo2.dart';
import 'package:example/demos/compute_cell_demo3.dart';
import 'package:example/demos/equality_cell_demo.dart';
import 'package:example/demos/mutable_cell_demo.dart';
import 'package:example/demos/store_cell_demo.dart';
import 'package:example/demos/subclass_demo1.dart';
import 'package:example/demos/subclass_demo2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Cells Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Live Cells Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose an example:',
              textAlign: TextAlign.center,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text('Cell Basics'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => BasicsDemo())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Mutable Cells'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MutableCellDemo())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Computational Cells 1'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ComputeCellDemo1()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Computational Cells 2'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ComputeCellDemo2()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Equality Cells'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => EqualityCellDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Computational Cells 3'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ComputeCellDemo3()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Store Cells'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => StoreCellDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('CellTextField'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CellTextFieldDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('ValueCell Subclass 1'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => SubclassDemo1()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('ValueCell Subclass 2'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => SubclassDemo2()
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
