//
//  FlutterToNative.m
//  ngr_channel_lib
//
//  Created by 林云飞 on 2020/5/25.
//  Flutter与native通信
//

#import "BaseFlutterToNative.h"

@implementation BaseFlutterToNative


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initChannelMothed];
    }
    return self;
}

- (void)initChannel:(NSObject<FlutterPluginRegistrar> *)registrar channelName:(NSString *)channelName{
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:channelName
              binaryMessenger:[registrar messenger]];
    
    [self setChannel:channel];
    
    [registrar addMethodCallDelegate:self channel:channel];
}



+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    
}


//  响应dart方法
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (self.methods == NULL) {
        NSLog(@"没有注册通信协议方法");
        result(FlutterMethodNotImplemented);
        return;
    }
    
    NSObject<FlutterToNativeFunc>* methodInfo = [self.methods objectForKey:call.method];
    if (methodInfo == NULL) {
        NSLog(@"没有注册:%@",call.method);
        result(FlutterMethodNotImplemented);
        return;
    }
    
    
    [methodInfo callMethod:call.arguments result:result];
}

- (void)registerMethod:(NSObject<FlutterToNativeFunc>*)methodInfo{
    if (self.methods == NULL) {
        self.methods = [[NSMutableDictionary alloc]init];
    }
    
    [self.methods setObject:methodInfo forKey: [methodInfo getMethodName]];
}


- (void)invokeMethod:(NSString*)method
           arguments:(id _Nullable)arguments
              result:(FlutterResult _Nullable)callback{
    [[self channel] invokeMethod:method arguments:arguments result:callback];
}

//  初始化通信方法
-(void)initChannelMothed{

}

@end
