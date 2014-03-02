//
//  VerticalInteractiveTransition.m
//  PlayingWithNavigationController
//
//  Created by Daniel Garbień on 26/02/14.
//  Copyright (c) 2014 Daniel Garbień. All rights reserved.
//

#import "VerticalInteractiveTransition.h"

static const CGFloat kStartingViewAlpfha = 0.2;
static const CGFloat kAnimationDuration = 0.5;

@interface VerticalInteractiveTransition ()

@property (strong, nonatomic) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation VerticalInteractiveTransition

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    CGRect bounds = transitionContext.containerView.bounds;
    CGRect toViewStartFrame = CGRectOffset(bounds, 0, -CGRectGetHeight(bounds));

    toViewController.view.frame = toViewStartFrame;
    toViewController.view.alpha = kStartingViewAlpfha;

    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    [super updateInteractiveTransition:percentComplete];

    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    CGRect bounds = transitionContext.containerView.bounds;
    CGRect fromViewFrame = CGRectOffset(bounds, 0, CGRectGetHeight(bounds) * percentComplete);
    CGRect toViewFrame = CGRectOffset(bounds, 0, CGRectGetHeight(bounds) * (-1+percentComplete));

    fromViewController.view.frame = fromViewFrame;
    fromViewController.view.alpha = 1 - (1-kStartingViewAlpfha)*percentComplete;
    toViewController.view.frame = toViewFrame;
    toViewController.view.alpha = (1-kStartingViewAlpfha)*percentComplete + kStartingViewAlpfha;
}

- (void)finishInteractiveTransition
{
    [super finishInteractiveTransition];

    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    CGRect bounds = [[transitionContext containerView] bounds];
    CGRect toViewEndFrame = bounds;
    CGRect fromViewEndFrame = CGRectOffset(bounds, 0, CGRectGetHeight(bounds));

    [UIView animateWithDuration:(1-self.percentComplete)*kAnimationDuration animations:^{
        toViewController.view.frame = toViewEndFrame;
        toViewController.view.alpha = 1.0;
        fromViewController.view.frame = fromViewEndFrame;
        fromViewController.view.alpha = kStartingViewAlpfha;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)cancelInteractiveTransition
{
    [super cancelInteractiveTransition];

    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    CGRect bounds = [[transitionContext containerView] bounds];
    CGRect toViewStartFrame = CGRectOffset(bounds, 0, -CGRectGetHeight(bounds));
    CGRect fromViewStartFrame = bounds;

    // animate views back to their start frames
    [UIView animateWithDuration:self.percentComplete*kAnimationDuration animations:^{
        toViewController.view.frame = toViewStartFrame;
        toViewController.view.alpha = kStartingViewAlpfha;
        fromViewController.view.frame = fromViewStartFrame;
        fromViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        // If the state of toViewController is not changed back to normal it's going to stay this way.
        // Taking care of consistancy of what's find at the start and the end point is especially important
        // if it's possible that a transition controller might changed.
        toViewController.view.alpha = 1.0;
        [transitionContext completeTransition:NO];
    }];
}

@end
