//
//  NativeToFlutter.m
//  ngr_channel_lib
//
//  Created by 林云飞 on 2020/5/25.
//

#import "BaseNativeToFlutter.h"

@implementation BaseNativeToFlutter

-(void)initChannel:(NSObject<FlutterPluginRegistrar> *)registrar channelName: (NSString*) channelName{
    FlutterEventChannel* eventChannel = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:[registrar messenger]];
    
    [self setChannel:eventChannel];
    
    [eventChannel setStreamHandler:self];
    
}


- (void)sendEvent:(NSString *)event arguments:(id)arguments{
    
    if (self.eventSink == NULL) {
        NSLog(@"事件通道没有注册");
        return;
    }
    
    NSMutableDictionary* eventInfo = [[NSMutableDictionary alloc] init];
    [eventInfo setValue:event forKey:@"eventName"];
    [eventInfo setValue:arguments forKey:@"args"];
    
    //  发送事件
    self.eventSink(eventInfo);
    
}

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    //  删除事件句柄
    if (arguments ==  NULL) {
        return NULL;
    }
    return NULL;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)event {
    [self setEventSink:event];
    return NULL;
}

@end
