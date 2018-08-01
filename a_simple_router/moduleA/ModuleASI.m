//
//  MoudleAClass.m
//  MKJMWWM
//
//  Created by 邓伟涛 on 2018/7/5.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "ModuleASI.h"
#import "ModuleAViewController.h"

@implementation ModuleASI

@synthesize callback;

@synthesize name;

@synthesize serverBody;

- (UIViewController *)serverBody {
  if (!serverBody) {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    serverBody = [sb instantiateViewControllerWithIdentifier: @"ModuleAViewController"];
    ((ModuleAViewController *)serverBody).interface = self;
  }
  return serverBody;
}

- (void)dealloc {
  
}

@end
