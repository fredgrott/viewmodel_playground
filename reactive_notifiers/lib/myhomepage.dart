// Copyright 2021 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

final counter = RxNotifier<int>(0);

class MyHomePage extends StatelessWidget with RxMixin {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '${counter.value}',
          style: TextStyle(fontSize: 23),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => counter.value++,
      ),
    );
  }
}
