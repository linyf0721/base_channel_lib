//
//  FlutterToNativeFunc.h
//  ngr_channel_lib
//
//  Created by 林云飞 on 2020/5/28.
//  Flutter 调用 native 方法基类

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FlutterToNativeFunc <NSObject>

/// 获取方法名
-(NSString*)getMethodName;

/// 方法回调
-(void)callMethod:(id) arguments result:(FlutterResult)result;

@end


NS_ASSUME_NONNULL_END
