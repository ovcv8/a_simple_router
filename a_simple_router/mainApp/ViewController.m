//
//  ViewController.m
//  a_simple_router
//
//  Created by 邓伟涛 on 2018/8/1.
//  Copyright © 2018年 OHG. All rights reserved.
//

#import "ViewController.h"
#import "OHGRouter.h"


@interface ModuleAPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition
@property(nonatomic, weak) UIViewController *modalViewController;

@end

@implementation ModuleAPercentDrivenInteractiveTransition {
    UIPanGestureRecognizer *_pan;
    CGFloat _panStartY;
}

- (void)setModalViewController:(UIViewController *)modalViewController {
    _modalViewController = modalViewController;
    [self _addGesture];
}

- (void) _addGesture {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panChanged:)];
        [_modalViewController.view addGestureRecognizer:_pan];
    } else {
        [_modalViewController.view addGestureRecognizer:_pan];
    }
}

- (void) _panChanged:(UIPanGestureRecognizer *) pan {
    CGFloat percent = [self _percentForGesture:pan];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _panStartY = [pan locationInView:_modalViewController.view].y;
            [_modalViewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            if (percent < .3) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        default:
            [self cancelInteractiveTransition];
            break;
    }
}

- (CGFloat) _percentForGesture:(UIPanGestureRecognizer *) pan {
    CGFloat y = [pan locationInView:_modalViewController.view].y;
    return ABS(y - _panStartY) / CGRectGetHeight(_modalViewController.view.frame);
}

@end

@interface ViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@end

@implementation ViewController {
    ModuleAPercentDrivenInteractiveTransition *_interactiveTransition;
}

- (IBAction)callModuleA:(UIButton *)sender {
    
    id <ModuleA> obj = [[OHGRouter router] interfaceForProtocol: @protocol(ModuleA)];
//    id<ModuleA> obj = [[OHGRouter router] interfaceForURL:[NSURL URLWithString:@"ModuleA://?name=xiaobaitu"]];
    obj.name = @"小白兔";
    obj.callback = ^(id params) {
        NSLog(@"%@", params);
    };
    obj.transitionDelegate = self;
    [obj showViewController:self showStyle:OHGShowStyleCustom];
}


// UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (!_interactiveTransition) _interactiveTransition = [ModuleAPercentDrivenInteractiveTransition new];
    
    _interactiveTransition.modalViewController = presented;
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return _interactiveTransition;
}

// UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview: toView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (toView) {
        CGPoint center = toView.center;
        toView.frame = CGRectZero;
        toView.center = center;
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toView.frame = [transitionContext finalFrameForViewController:toVc];
        } completion:^(BOOL finished) {
            BOOL isCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition: !isCancelled];
        }];
    } else { // dismiss
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromView.alpha = 0;
        } completion:^(BOOL finished) {
            BOOL isCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition: !isCancelled];
        }];
    }
}



@end
