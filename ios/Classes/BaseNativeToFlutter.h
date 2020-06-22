//
//  NativeToDart.h
//  ngr_channel_lib
//
//  Created by 林云飞 on 2020/5/25.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNativeToFlutter : NSObject<FlutterStreamHandler>

//  事件句柄
@property FlutterEventSink eventSink;

//  事件通道
@property FlutterEventChannel* channel;

//  初始化通道
-(void)initChannel:(NSObject<FlutterPluginRegistrar>*) registrar channelName: (NSString*) channelName;

//  发送事件
-(void)sendEvent:(NSString*) event arguments:(id) arguments;

@end

NS_ASSUME_NONNULL_END
