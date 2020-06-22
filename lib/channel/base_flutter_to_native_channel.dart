/// @Author: 林云飞
/// @Date: 2020-05-13 17:51:32
/// @Last Modified by:   林云飞
/// @Last Modified time: 2020-05-13 17:51:32
/// @Note: flutter 调用 native方法，基于method channel

import 'dart:async';

import 'package:flutter/services.dart';

abstract class BaseFTNMethodChannel {
  /// method 通道
  MethodChannel _channel;

  /// 通道名称
  String get channelName;

  /// 原生调flutter方法
  Map<String, Function> _ntdMethods = Map();

  BaseFTNMethodChannel() {
    // 设置native调用flutter方法
    _channel = MethodChannel(channelName);

    _channel.setMethodCallHandler(platformCallHandler);
  }

  /// 注册原生调用dart方法
  /// [methodName] 方法名
  /// [method] 方法回调
  registerNativeToDart(String methodName, Function method) {
    if (_ntdMethods.containsKey(methodName)) {
      print("方法重复注册，请检查");
      return;
    }
    _ntdMethods[methodName] = method;
  }

  /// 调用原生方法
  /// [method] 方法名
  /// [arguments]  参数
  invokeNativeMethod(String method, [dynamic arguments]) async {
    assert(_channel != null);
    return _channel.invokeMethod(method, arguments);
  }

  /// 响应native方法调用
  Future<dynamic> platformCallHandler(MethodCall call) async {
    if (_ntdMethods == null || !_ntdMethods.containsKey(call.method)) return;
    return _ntdMethods[call.method](call.arguments);
  }
}
