//
//  DartToNative.h
//  ngr_channel_lib
//
//  Created by 林云飞 on 2020/5/25.
//  flutter 向 native通信 基类

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "FlutterToNativeFunc.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^__callfunc)(id arguments,FlutterResult result);

@interface BaseFlutterToNative :  NSObject<FlutterPlugin>


//  dart回调native方法
@property NSMutableDictionary* methods;

// 通道
@property FlutterMethodChannel* channel;

/**
 初始化通道
 @param registrar flutter插件注册器
 @param channelName 通道名称与flutter中通道保持一致
*/
-(void)initChannel:(NSObject<FlutterPluginRegistrar>*) registrar channelName: (NSString*) channelName;

//  初始化
//  [self registerMethod:[[PlatformVersion alloc]init]];
-(void)initChannelMothed;

/**
 注册flutter调用native方法
 @param method 原生方法
*/
-(void)registerMethod:(NSObject<FlutterToNativeFunc>*)methodInfo;


/**
 native调用flutter方法
 @param method 方法名  调用flutter的方法名
 @param arguments 参数
 @param callback    调用结果回调
*/
- (void)invokeMethod:(NSString*)method
           arguments:(id _Nullable)arguments
              result:(FlutterResult _Nullable)callback;

@end

NS_ASSUME_NONNULL_END
