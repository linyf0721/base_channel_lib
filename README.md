# Flutter 与 Native 基础通信库

basechannellib 库包含基本 Flutter 与 native 通信的方法

# Flutter 与 Native 通信

Flutter 与 Native 通信基于 MethodChannel 和 EventChannel

Flutter 调用 Native 方法基于 MethodChannel

Native 通知 Flutter 基于 EventChannel

## Flutter

| 类名                 | 描述                           |
| -------------------- | ------------------------------ |
| BaseFTNMethodChannel | Flutter 调用 Native 方法实现类 |
| BaseFTNChannel       | Flutter 调用 Native 方法工具类 |
| BaseNTFEventChannel  | Native 通知 Flutter 事件类     |

## Android

| 类名                    | 描述                             |
| ----------------------- | -------------------------------- |
| BaseFlutterToNative     | Flutter 调用 Native 方法实现类   |
| BaseFlutterToNativeFunc | Flutter 调用 Native 原生实现接口 |
| BaseNativeToFlutter     | Native 通知 Flutter 事件实现类   |

## Ios

| 类名                    | 描述                                 |
| ----------------------- | ------------------------------------ |
| BaseFlutterToNative     | Flutter 调用 Native 方法实现类       |
| BaseFlutterToNativeFunc | Flutter 调用 Native 原生实现基类接口 |
| BaseNativeToFlutter     | Native 通知 Flutter 事件实现类       |

# 使用方法

1. pubspec.yaml 添加依赖

```yaml
dependencies:
  #基础通信层
  basechannellib:
    hosted:
      name: basechannellib
      url: http://139.9.115.167:10088
    version: ^1.0.0
```

2. 运行 flutter pub get

## Flutter 向 Native 通信

- 定义 flutter 向 native 通信 dart 单例类

```dart
import 'package:basechannellib/basechannellib.dart';
/// flutter向native通信
class FTNMethodChannel extends BaseFTNMethodChannel {
  static FTNMethodChannel _instance;

  static FTNMethodChannel instance() {
    if (null == _instance) _instance = FTNMethodChannel();
    return _instance;
  }

  /// 获取通信通道名称
  @override
  String get channelName => "ngrchannellib";
}
```

- ios 定义通信单例类

```objective-c
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <basechannellib/BaseFlutterToNative.h>
/// flutter向native通信类，继承BaseFlutterToNative，实现initChannelMothed方法
@interface FlutterToNative : BaseFlutterToNative

/**
 单例类初始化
 */
+ (instancetype)instance;


@end
```

```objective-c
//  FlutterToNative.m 实现基类初始化通信方法
//  初始化通信方法
-(void)initChannelMothed{
    [self registerMethod:[[PlatformVersion alloc]init]];
    [self registerMethod:[[TestNativeEvent alloc]init]];
}
```

- native 定义通信方法

```objective-c
//
//  PlatformVersion.h
//
//  Created by 林云飞 on 2020/5/28.
//  获取版本信息

#import <basechannellib/FlutterToNativeFunc.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformVersion : NSObject<FlutterToNativeFunc>

@end

NS_ASSUME_NONNULL_END

```

```objective-c
//
//  PlatformVersion.m
//
//  Created by 林云飞 on 2020/5/28.
//

#import "PlatformVersion.h"

@implementation PlatformVersion

/// 获取方法名
- (NSString *)getMethodName{
    return @"getPlatformVersion";
}

/// 调用方法
- (void)callMethod:(id)arguments result:(FlutterResult)result{
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
}

@end

```

- flutter 调用 native 方法

```dart
   //  调用native getPlatformVersion 方法
    String version = await FTNMethodChannel.instance()
        .invokeNativeMethod('getPlatformVersion');
```

- android 同理具体可参考 example

# Native 向 Flutter 发送事件通信

- 定义 native 向 flutter 通信 dart 单例类

```dart
/// @Author: 林云飞
/// @Date: 2020-05-13 17:56:28
/// @Last Modified by:   林云飞
/// @Last Modified time: 2020-05-13 17:56:28
/// @Note: native 向 dart 通信基于EventChannel

import 'package:basechannellib/basechannellib.dart';

/// native to dart
class NTFEventChannel extends BaseNTFEventChannel {
  static NTFEventChannel _instance;

  static NTFEventChannel instance() {
    if (null == _instance) _instance = NTFEventChannel();
    return _instance;
  }
 /// 事件通道名称
  @override
  String get eventChannelName => "ngrchannellib_event";
}

```

- dart 注册事件监听

```dart
/// 注册事件
NTFEventChannel.instance().registerEvent("test", ntfEventCallback);

 /// 事件回调
 ntfEventCallback(args) {
    print(args);
 }
```

- native 定义事件通信单例类

```objective-c
//
//  NativeToDart.h
//  ngr_channel_lib
//
//  Created by 林云飞 on 2020/5/25.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <basechannellib/BaseNativeToFlutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface NativeToFlutter : BaseNativeToFlutter
/**
 单例类初始化
 */
+ (instancetype)instance;

@end

NS_ASSUME_NONNULL_END

```

- 发送事件

```objective-c
[[NativeToFlutter instance] sendEvent:@"test" arguments:@"test args"];
```

- 插件初始化

```objective-c
@implementation NgrchannellibPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    // 初始化通信通道
    [[FlutterToNative instance] initChannel:registrar channelName:@"ngrchannellib"];
    // 初始化事件通道
    [[NativeToFlutter instance] initChannel:registrar channelName:@"ngrchannellib_event"];

}

@end

```
