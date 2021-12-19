// Copyright 2021 Fredrick Allan Grott. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// Original author Polyflection 2020 BSD 3 clause license
// under package name reacive components.

import 'dart:async';
import 'dart:ui';

import 'sinks.dart';


/// An object to handle resource disposing.
class ResourceDisposer {
  final Future<void> Function()? _doDispose;
  final List<ResourceDisposer> _disposers = [];
  StreamController<void>? __disposeController;
  final VoidCallback? _onDispose;
  bool _isDisposeEventSent = false;


    /// A [VoidSink] to dispose of the resources.
  VoidSink get dispose {
    return _VoidSink(
      _disposeController.sink,
      () => !_isDisposeEventSent,
      _wrapOnDispose(
        _onDispose,
      ),
    );
  }

  

  /// A stream to notify the resource has been disposed of.
  Stream<void> get disposed => Stream.fromFuture(_disposeController.done);

  /// Check whether an event data has been added to [dispose] sink once.
  ///
  /// It is synchronously set to true on an event data added.
  bool get isDisposeEventSent => _isDisposeEventSent;



  
  StreamController<void> get _disposeController => __disposeController ??=
      StreamController<void>()..stream.listen((_) => _dispose());


  

  


  /// Constructs resource disposer.
  ResourceDisposer(
      {required Future<void> Function()? doDispose,
      required VoidCallback? onDispose,})
      : _doDispose = doDispose,
        _onDispose = onDispose;

 

  /// Registers a resource disposer for disposing of together.
  ///
  /// If [isDisposeEventSent] is true, then the resource disposer calls
  /// dispose method immediately.
  void register(ResourceDisposer disposer) {
    if (isDisposeEventSent) {
      disposer.dispose();
    } else {
      _disposers.add(disposer);
    }
  }

  /// Delegates its [dispose] call to [disposerDelegate].
  void delegateDisposingTo(ResourceDisposer disposerDelegate) {
    disposerDelegate.register(this);
  }

  

  
  

  Future<void> _dispose() => _doDispose != null
      ? Future.wait([_doDispose!(), _disposePrivateResource(),])
      : _disposePrivateResource();

      

  Future<void> _disposePrivateResource() => _disposeController.close();

  

  VoidCallback _wrapOnDispose(VoidCallback? onDispose) {
    return () {
      if (_isDisposeEventSent) return;
      _isDisposeEventSent = true;
      for (final disposer in _disposers) {
        disposer.dispose();
      }
      onDispose?.call();
    };
  }

  
}

class _VoidSink implements VoidSink {
  final Sink<dynamic> _sink;
  final bool Function() _canAdd;
  final VoidCallback _onAdd;


  _VoidSink(this._sink, this._canAdd, this._onAdd,);

  

  @override
  void call() {
    if (_canAdd()) {
      _sink.add(null);
      _onAdd();
    }
  }

  @override
  void add(void _) {
    call();
  }

  @override
  void close() {
    call();
  }
}
