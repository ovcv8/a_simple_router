//
//
//  Created by 邓伟涛 on 2018/7/5.
//  Copyright © 2018年 mintou. All rights reserved.
//

#import "ModuleASI.h"
#import "ModuleAViewController.h"

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

static NSInteger _moduleASIAllocCount = 0;
@implementation ModuleASI {
    UIViewController *_presentingController;
    ModuleAPercentDrivenInteractiveTransition *_interactiveTransition;
    OHGShowStyle _showStyle;
}

@synthesize callback;

@synthesize name;

//@synthesize serverBody;

//- (UIViewController *)serverBody {
//  if (!serverBody) {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    serverBody = [sb instantiateViewControllerWithIdentifier: @"ModuleAViewController"];
////    serverBody = [ModuleAViewController new];
//    ((ModuleAViewController *)serverBody).interface = self;
//  }
//  return serverBody;
//}

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
        _interactiveTransition = [ModuleAPercentDrivenInteractiveTransition new];
    }
    return self;
}

- (void)showViewController:(UIViewController *)presentingController showStyle:(OHGShowStyle)style {
    _presentingController = presentingController;
    _showStyle = style;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *serverBody = [sb instantiateViewControllerWithIdentifier: @"ModuleAViewController"];
    ((ModuleAViewController *)serverBody).interface = self;
    serverBody.transitioningDelegate = self;
    serverBody.view.backgroundColor = [UIColor orangeColor];
    serverBody.modalPresentationStyle = UIModalPresentationCustom;
    _interactiveTransition.modalViewController = serverBody;

    
    [_presentingController presentViewController: serverBody animated:YES completion:nil];
    
}

// UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
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

    if ([self _isPresentedViewController:toVc]) {
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

- (void)dealloc {
    
}


#pragma 组件使用次数统计

+ (NSInteger)allocCount {
    return _moduleASIAllocCount;
}


#pragma Private

- (BOOL) _isPresentedViewController:(UIViewController *) vc {
    return [vc isKindOfClass:[ModuleAViewController class]];
}




@end
