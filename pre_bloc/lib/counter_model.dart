// Copyright 2021 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:pre_bloc/pre_bloc.dart';
import 'package:rx_notifier/rx_notifier.dart';

// Scoped Model example had:
//  class CounterModel extends Model {
//     int _counter = 0;
//
//      int get counter => _counter;
//
//      void increment() {
    // First, increment the counter
 //         _counter++;

    // Then notify all the listeners.
//          notifyListeners();
//     }
//    }

//
// Yes, really that simple to have the gist core of BLoC right from 
// begining to learn flutter!
class CounterModel extends Model {
  final RxNotifier<int> _counter = RxNotifier<int>(0);


  int get counter => _counter.value;

  void increment() {
    // First, increment the counter
    _counter.value++;

    // Then notify all the listeners.
    notifyListeners();
  }
}
