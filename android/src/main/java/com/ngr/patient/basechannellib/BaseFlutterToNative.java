package com.ngr.patient.basechannellib;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


/**
 * Flutter调用native方法基类
 */
abstract public class BaseFlutterToNative implements MethodChannel.MethodCallHandler {

    static private BaseFlutterToNative _instance = null;

    static String TAG = "BaseFlutterToNative";

    private MethodChannel channel;

    Map<String, BaseFlutterToNativeFunc> methodsMap = new HashMap<>();


    public BaseFlutterToNative() {

    }

    /**
     * 通道初始化
     *
     * @param flutterPluginBinding the flutter plugin binding
     * @param channelName          the channel name 通道名称
     */
    public void initChannel(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding,String channelName){
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), channelName);
        channel.setMethodCallHandler(this);
        initMethod();
    }

    /**
     * 初始化通信通道方法
     *
     */
    public abstract void initMethod();

    /**
     * 注册方法
     *
     * @param flutterToNativeFunc
     */
    public void registerMethod(BaseFlutterToNativeFunc flutterToNativeFunc){
        if (methodsMap == null) return;

        String method = flutterToNativeFunc.getMethodName();

        if (method == null || method.length() == 0){
            Log.e(TAG,"方法为空");
            return;
        }

        if (methodsMap.containsKey(method)){
            Log.e(TAG,"已经注册过改FlutterToNative方法了，请检查,方法名："+method);
            return;
        }

        methodsMap.put(method,flutterToNativeFunc);

    }

    /**
     * 响应flutter方法
     *
     * @param call   the call
     * @param result the result
     */
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        try {
            if (methodsMap == null) return;

            if (!methodsMap.containsKey(call.method)){
                Log.e(TAG,"没有注册过该方法:"+call.method);
                result.notImplemented();
                return;
            }

            BaseFlutterToNativeFunc flutterToNativeFunc = methodsMap.get(call.method);
            if (flutterToNativeFunc == null){
                Log.e(TAG,"没有找到方法:"+call.method);
                result.notImplemented();
                return;
            }

            flutterToNativeFunc.onMethodCall(call.arguments,result);

        }catch (Exception e){
            Log.e(TAG, "",e );
        }
    }

    /**
     * 直接调用flutter方法
     *
     * @param method    the method 方法名
     * @param arguments the arguments 参数
     * @param callback  the callback 结果回调
     */
    public void invokeMethod(String method, @Nullable Object arguments, MethodChannel.Result callback){
        if(channel == null) return;
        channel.invokeMethod(method,arguments,callback);
    }


}
