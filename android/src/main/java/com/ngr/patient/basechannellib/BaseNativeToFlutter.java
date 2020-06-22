package com.ngr.patient.basechannellib;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

//  原生与flutter通信，基于EventChannel
public class BaseNativeToFlutter implements EventChannel.StreamHandler {

    static private BaseNativeToFlutter _instance =null;

    static String TAG = "NativeToFlutter";

    public BaseNativeToFlutter(){

    }

    // 事件通道
    EventChannel eventChannel;

    // 事件句柄
    EventChannel.EventSink eventSink;


    /**
     * 发送事件
     *
     * @param event the event 事件名称
     * @param args  the args 参数
     */
    public void sendEvent(String event,Object args){
        if (this.eventSink == null) {
            Log.e(TAG,"事件通道没有注册");
            return;
        }

        Map<String,Object> eventInfo = new HashMap<>();

        eventInfo.put("eventName",event);
        eventInfo.put("args",args);

        this.eventSink.success(eventInfo);
    }


    /**
     * 通道初始化
     *
     * @param flutterPluginBinding the flutter plugin binding
     * @param eventChannelName     the event channel name 事件通道名称
     */
    public void initChannel(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding,String eventChannelName){
        eventChannel = new EventChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),eventChannelName);
        eventChannel.setStreamHandler(this);
    }


    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {

    }
}
