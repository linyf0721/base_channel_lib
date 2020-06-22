/// @Author: 林云飞
/// @Date: 2020-05-13 17:56:28
/// @Last Modified by:   林云飞
/// @Last Modified time: 2020-05-13 17:56:28
/// @Note: native 向 dart 通信基于EventChannel

import 'package:flutter/services.dart';

/// 事件句柄
class EventHandle {
  int handleId;
  String eventName;
}

/// 事件回调
typedef EventCallBackFunc = Function(dynamic args);

/// 事件
class EventInfo {
  String eventName; //事件名称
  Map<int, EventCallBackFunc> eventMap = Map(); //事件列表
}

/// native to dart
abstract class BaseNTFEventChannel {
  /// 事件通信通道
  EventChannel _channel;

  /// 事件通道名
  String get eventChannelName;

  /// 事件列表
  Map<String, EventInfo> _events = Map();

  /// 事件句柄id
  static int _handleId = 0;

  BaseNTFEventChannel() {
    // 设置事件通道
    _channel = EventChannel(eventChannelName);

    // 监听事件
    _channel.receiveBroadcastStream().listen(processEvent,
        onError: (dynamic error) {
      print('Received error: ${error.message}');
    }, cancelOnError: true);
  }

  /// 注册[event]事件
  /// 返回事件句柄，用户取消事件
  EventHandle registerEvent(String event, EventCallBackFunc callBack) {
    if (_events == null) _events = Map();

    EventInfo eventInfo;

    if (_events.containsKey(event)) eventInfo = _events[event];

    if (eventInfo == null) {
      //  新事件
      eventInfo = EventInfo();

      eventInfo.eventName = event;
    }

    int handleId = _handleId++;
    //  设置事件回调
    eventInfo.eventMap[handleId] = callBack;
    //  设置事件
    _events[event] = eventInfo;

    EventHandle eventHandle = EventHandle();
    eventHandle.handleId = handleId;
    eventHandle.eventName = event;
    return eventHandle;
  }

  /// 取消[eventId]事件
  cancelEvent(EventHandle eventHandle) {
    if (eventHandle == null ||
        _events == null ||
        !_events.containsKey(eventHandle.eventName)) return;

    EventInfo eventInfo = _events[eventHandle.eventName];

    if (eventInfo == null) return;

    Map eventMap = eventInfo.eventMap;

    if (eventMap == null || !eventMap.containsKey(eventHandle.handleId)) return;

    eventMap.remove(eventHandle.handleId);

    // 事件为空，则删除事件句柄
    if (eventMap.length == 0) {
      _events.remove(eventHandle.eventName);
    }
  }

  /// 处理事件
  processEvent(eventInfo) {
    if (!eventInfo.containsKey("eventName")) {
      print("native事件格式有误，请检查");
      return;
    }

    String eventName = eventInfo["eventName"];
    dynamic args = eventInfo["args"];

    if (!_events.containsKey(eventName)) {
      print("没有注册事件：$eventName");
      return;
    }

    EventInfo event = _events[eventName];
    if (event == null || event.eventMap == null || event.eventMap.length == 0) {
      print("事件为空:$eventName");
      return;
    }

    event.eventMap.forEach((key, callBack) {
      if (callBack != null) {
        callBack(args);
      }
    });
  }
}
