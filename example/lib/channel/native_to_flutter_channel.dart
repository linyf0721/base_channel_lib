/// @Author: 林云飞
/// @Date: 2020-05-13 17:56:28
/// @Last Modified by:   林云飞
/// @Last Modified time: 2020-05-13 17:56:28
/// @Note: native 向 dart 通信基于EventChannel

import 'package:basechannellib/basechannellib.dart';

/// native to dart
class ExampleNTFEventChannel extends BaseNTFEventChannel {
  static ExampleNTFEventChannel _instance;

  static ExampleNTFEventChannel instance() {
    if (null == _instance) _instance = ExampleNTFEventChannel();
    return _instance;
  }

  @override
  String get eventChannelName => "examplechannellib_event";
}
