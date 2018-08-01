//
//  ViewController.m
//  a_simple_router
//
//  Created by 邓伟涛 on 2018/8/1.
//  Copyright © 2018年 OHG. All rights reserved.
//

#import "ViewController.h"
#import "OHGRouter.h"

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)callModuleA:(UIButton *)sender {
    
    id <ModuleA> obj = [[OHGRouter router] interfaceForProtocol: @protocol(ModuleA)];
//    id<ModuleA> obj = [[OHGRouter router] interfaceForURL:[NSURL URLWithString:@"ModuleA://?name=xiaobaitu"]];
    obj.name = @"小白兔";
    obj.callback = ^(id params) {
        NSLog(@"%@", params);
    };
    [self presentViewController:obj.serverBody animated:YES completion:nil];
}

@end
