//
//  UIViewController+Interface.h
//  a_simple_router
//
//  Created by 邓伟涛 on 2018/8/3.
//  Copyright © 2018年 OHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoudleProtocol.h"


@interface UIViewController (Interface)

@property(nonatomic, strong) id<BaseModule> interface;

@end
