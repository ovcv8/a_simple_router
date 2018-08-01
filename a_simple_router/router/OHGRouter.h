//
//  JRouter.h
//  MKJMWWM
//
//  Created by 邓伟涛 on 2018/7/5.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoudleProtocol.h"

@interface OHGRouter : NSObject

+ (instancetype) router;
/**
 请确保组件遵守组件对应的协议，并创建对应的接口类
 */
- (id) interfaceForProtocol:(Protocol *) p;
- (id) interfaceForURL:(NSURL *) url;

// for unit test
- (void) assertForMoudleWithProtocol:(Protocol *) p;
- (void) assertForMoudleWithURL:(NSURL *) url;

// navi type for vc
// push present
- (UIViewController *) findVcOfView:(UIView *) view;

@end
