//
//  MethodInfo.h
//  ngr_channel_lib
//
//  Created by 林云飞 on 2020/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelMethodInfo : NSObject

//  方法的对象
@property(weak, nonatomic) NSObject* obj;

//  回调方法
@property NSString* callFuncStr;

@end


NS_ASSUME_NONNULL_END
