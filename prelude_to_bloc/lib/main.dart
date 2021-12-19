// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:prelude_to_bloc/reactive.dart';
import 'package:prelude_to_bloc/reactive_component.dart';
import 'package:prelude_to_bloc/reactive_sink.dart';

/// A counter which is a kind of [ReactiveComponent].
///
/// [ReactiveComponent] is a unit that encapsulates its members
/// and publicizes only [Sink]s and [Stream]s.
///
/// [ReactiveComponent] acts as a delegate to disposing its [ReactiveResource]s,
/// so that they should be disposed of together by [ReactiveComponent]'s
/// dispose method call.
class _Counter with ReactiveComponent {
  /// A special kind of [StreamSink] with its own single stream listener
  /// that handles for adding an event to increment this counter.
  ///
  /// The "increment();" is shorthand notation of "increment.add(null);".
  ///
  /// An event stream can be transformed by [_Transform] callback function
  /// passed at the constructor.
  ///
  /// "dispose()" action of [ReactiveSink] can be delegated to
  /// [ReactiveComponent]'s disposer.
  ///
  /// For more information, see [ReactiveSink]'s API documentation.
  late final VoidReactiveSink increment = VoidReactiveSink(
    () {
      // Increments _count on a increment event is delivered.
      _count.data++;
    },
    disposer: disposer,
  );


  final int _initialCount;

  

  /// A [Reactive], [int] data as count state of this counter.
  ///
  /// [Reactive] is a special kind of [StreamController] that holds its latest
  /// stream data, and sends that as the first data to any new listener.
  ///
  /// For more information, see [Reactive]'s API documentation.
  late final Reactive<int> _count = Reactive<int>(
    _initialCount,
    disposer: disposer,
  );

  /// Publicize only the stream of [_count] to hide its data mutating
  /// and the other behaviors.
  /// It's a good point to transform the stream as necessary.
  Stream<int> get count => _count.stream;



  _Counter(this._initialCount);

  

  

  

  
}

void main() {
  runApp(const MyApp());
}

/// Flutter Counter App
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

/// MyHomePage
// ignore: prefer-single-widget-per-file
class MyHomePage extends StatefulWidget {

  /// Title
  final String title;

  /// Constructor
  MyHomePage({Key? key, required this.title,}) : super(key: key);

  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final _Counter _counter;

  @override
  void initState() {
    super.initState();
    _counter = _Counter(0);
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder<int>(
                stream: _counter.count,
                builder: (context, snapshot,) {
                  if (!snapshot.hasData) return const SizedBox.shrink();

                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.headline4,
                  );
                },),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _counter.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
