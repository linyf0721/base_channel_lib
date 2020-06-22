//
//  EventInfo.h
//  ngr_channel_lib
//
//  Created by 林云飞 on 2020/5/26.
//  通信事件信息

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelEventInfo : NSObject

//  方法的对象
@property FlutterEventSink eventSink;

//  事件名称
@property NSString* eventName;

@end

NS_ASSUME_NONNULL_END
