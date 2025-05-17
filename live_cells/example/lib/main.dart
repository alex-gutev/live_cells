import 'package:flutter/material.dart';

import 'demos/async_demo.dart';
import 'demos/action_cell_demo1.dart';
import 'demos/action_cell_demo2.dart';
import 'demos/live_text_field_demo1.dart';
import 'demos/live_text_field_demo2.dart';
import 'demos/counter_demo.dart';
import 'demos/effect_cells_demo.dart';
import 'demos/mutable_computed_cell_demo.dart';
import 'demos/mutable_computed_cell_demo2.dart';
import 'demos/error_handling_demo1.dart';
import 'demos/error_handling_demo2.dart';
import 'demos/sum_demo.dart';
import 'demos/live_checkbox_demo.dart';
import 'demos/live_radio_demo.dart';
import 'demos/cell_restoration_demo.dart';
import 'demos/live_slider_demo.dart';
import 'demos/live_switch_demo.dart';
import 'demos/previous_value_demo.dart';
import 'demos/subclass_demo1.dart';
import 'demos/subclass_demo2.dart';
import 'demos/watch_demo.dart';

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
      restorationScopeId: 'root',
      home: const MyHomePage(title: 'Live Cells Demo'),
    );
  }
}

@pragma('vm:entry-point')
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
                        child: const Text('Counter'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const CounterDemo())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Computed Cells'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SumDemo())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Previous Values'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const PreviousValueDemo())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('LiveTextField'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const LiveTextFieldDemo1())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('LiveTextField 2'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const LiveTextFieldDemo2())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Mutable Computed Cells'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const MutableComputedCellDemo())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Mutable Computed Cells 2'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const MutableComputedCellDemo2())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Error handling 1'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const ErrorHandlingDemo1())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Error handling 2'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const ErrorHandlingDemo2())
                          );
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Watching Cells'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const WatchDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('LiveSlider'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const LiveSliderDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('LiveCheckbox'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const LiveCheckboxDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('LiveSwitch'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const LiveSwitchDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('LiveRadio'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const LiveRadioDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('State Restoration'),
                        onPressed: () {
                            Navigator.restorablePush(context, _makeStateRestorationDemo);
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Asynchronous Cells'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const AsyncDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Action Cells 1'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const ActionCellDemo1()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Action Cells 2'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const ActionCellDemo2()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Effect Cells'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const EffectCellDemo()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('ValueCell Subclass 1'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SubclassDemo1()
                          ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('ValueCell Subclass 2'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SubclassDemo2()
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

  @pragma('vm:entry-point')
  static Route _makeStateRestorationDemo(BuildContext context, Object? args) {
    return MaterialPageRoute(builder: (context) => const CellRestorationDemo());
  }
}
