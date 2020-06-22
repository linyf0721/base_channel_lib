/// @Author: 林云飞
/// @Date: 2020-05-13 17:51:32
/// @Last Modified by:   林云飞
/// @Last Modified time: 2020-05-13 17:51:32
/// @Note: flutter 调用 native方法，基于method channel

import 'package:basechannellib/basechannellib.dart';

class ExampleFTNMethodChannel extends BaseFTNMethodChannel {
  static ExampleFTNMethodChannel _instance;

  static ExampleFTNMethodChannel instance() {
    if (null == _instance) _instance = ExampleFTNMethodChannel();
    return _instance;
  }

  @override
  String get channelName => "examplechannellib";

  ///  获取版本
  static Future<String> get platformVersion async {
    //  调用native getPlatformVersion 方法
    String version = await ExampleFTNMethodChannel.instance()
        .invokeNativeMethod('getPlatformVersion');
    return version;
  }

  /// 发送测试通信
  static Future<String> sendEventTest() async {
    String version = await ExampleFTNMethodChannel.instance()
        .invokeNativeMethod('sendEventTest');
    return version;
  }
}
