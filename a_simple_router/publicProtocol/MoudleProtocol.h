//
//
//  Created by 邓伟涛 on 2018/7/4.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef MoudleProtocol_ServerInterface
#define MoudleProtocol_ServerInterface @"SI"
#endif

@protocol BaseModule <NSObject>
@required
// server body
@property(nonatomic, weak) __kindof UIViewController *serverBody;

@optional
// callback
@property(nonatomic, copy) void (^callback) (id params);

@end



@protocol ModuleA <BaseModule>

@required
// input 作为组件A的入参 可以自定义任意属性
@property(nonatomic, strong) NSString *name;

@end





