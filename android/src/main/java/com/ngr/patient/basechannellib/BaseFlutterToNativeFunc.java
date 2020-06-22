package com.ngr.patient.basechannellib;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodChannel;

// flutter 调用 native 方法接口
public interface BaseFlutterToNativeFunc {

    //  获取Flutter注册方法名
    String getMethodName();

    //  回调处理方法
    void onMethodCall(Object args, @NonNull MethodChannel.Result result);
}
