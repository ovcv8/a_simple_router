//
//  ModuleAViewController.m
//  a_simple_router
//
//  Created by 邓伟涛 on 2018/8/1.
//  Copyright © 2018年 OHG. All rights reserved.
//

#import "ModuleAViewController.h"

@import Social;

@interface ModuleAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation ModuleAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.text = self.interface.name;
}

- (IBAction)back:(id)sender {
    !self.interface.callback ?: self.interface.callback(@"我没了");
    [self dismissViewControllerAnimated:YES completion:nil];
    

}

- (void)dealloc {
    
}

@end
