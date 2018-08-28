//
//
//  Created by 邓伟涛 on 2018/7/5.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "ModuleASI.h"
#import "ModuleAViewController.h"


static NSInteger _moduleASIAllocCount = 0;
@implementation ModuleASI {
    UIViewController *_presentingController;
    OHGShowStyle _showStyle;
    NSTimeInterval _initTime;
    NSTimeInterval _expendTime;
}

@synthesize callback;
@synthesize name;
@synthesize transitionDelegate;

+ (instancetype) alloc {
    //增加组件创建次数
    ++_moduleASIAllocCount;
    NSLog(@"%@创建%ld次", NSStringFromClass([self class]), _moduleASIAllocCount);
    return [super alloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _initTime = CACurrentMediaTime();
    }
    return self;
}

- (void)showViewController:(UIViewController *)presentingController showStyle:(OHGShowStyle)style {
    _presentingController = presentingController;
    _showStyle = style;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *serverBody = [sb instantiateViewControllerWithIdentifier: @"ModuleAViewController"];
    ((ModuleAViewController *)serverBody).interface = self;
    serverBody.transitioningDelegate = self.transitionDelegate;
    serverBody.view.backgroundColor = [UIColor orangeColor];
    serverBody.modalPresentationStyle = UIModalPresentationCustom;

    [_presentingController presentViewController: serverBody animated:YES completion:nil];
    
}

- (void)dealloc {
    _expendTime = CACurrentMediaTime() - _initTime;
}


#pragma 组件使用次数统计

+ (NSInteger)allocCount {
    return _moduleASIAllocCount;
}


@end
