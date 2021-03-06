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

typedef NS_ENUM(NSUInteger, OHGShowStyle) {
    OHGShowStylePresent,
    OHGShowStyleModal,
    OHGShowStyleCustom,
};

@protocol BaseModule <NSObject>
@required
- (void) showViewController:(UIViewController * _Nonnull) presentingController
                  showStyle:(OHGShowStyle) style;

@optional
@property(nonatomic, assign, class) NSInteger allocCount;
@property(nonatomic, assign, class) NSInteger deallocCount;
// callback
@property(nonatomic, copy) void (^callback) (id params);
// 如果是自定义呈现方式，需要定义下面属性
@property(nonatomic, weak) id<UIViewControllerTransitioningDelegate> transitionDelegate;

@end



@protocol ModuleA <BaseModule>

@required
// input 作为组件A的入参 可以自定义任意属性
@property(nonatomic, strong) NSString *name;

@end





