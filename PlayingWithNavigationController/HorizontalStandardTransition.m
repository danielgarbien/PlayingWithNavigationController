//
//  HorizontalStandardTransition.m
//  PlayingWithNavigationController
//
//  Created by Daniel Garbień on 10/10/13.
//  Copyright (c) 2013 Daniel Garbień. All rights reserved.
//

#import "HorizontalStandardTransition.h"

static const CGFloat kStartingViewAlpfha = 0.2;
static const NSTimeInterval kDuration = 0.5;

@implementation HorizontalStandardTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return kDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // This code is lifted wholesale from the TLTransitionAnimator class
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = [[transitionContext containerView] bounds];
    
    if (self.presenting) {
        [transitionContext.containerView addSubview:toViewController.view]; // fromView is already in containerView
        
        CGRect startFrame = endFrame;
        startFrame.origin.x += CGRectGetWidth([[transitionContext containerView] bounds]);
        toViewController.view.frame = startFrame;
        toViewController.view.alpha = kStartingViewAlpfha;

        CGRect endFrameFromView = endFrame;
        endFrameFromView.origin.x -= CGRectGetWidth(([[transitionContext containerView] bounds]));
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endFrame;
            toViewController.view.alpha = 1.0;
            fromViewController.view.frame = endFrameFromView;
            fromViewController.view.alpha = kStartingViewAlpfha;
        } completion:^(BOOL finished) {
            // If the state of toViewController is not changed back to normal it's going to stay this way.
            // Taking care of consistancy of what's find at the start and the end point is especially important
            // if it's possible that a transition controller might changed.
            fromViewController.view.alpha = 1.0;
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        // might be interactive
        [transitionContext.containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        CGRect startFrameToView = endFrame;
        startFrameToView.origin.x -= CGRectGetWidth([[transitionContext containerView] bounds]);
        toViewController.view.frame = startFrameToView;
        toViewController.view.alpha = kStartingViewAlpfha;
        CGRect endFrameToView = endFrame;
        
        endFrame.origin.x += CGRectGetWidth([[transitionContext containerView] bounds]);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endFrame;
            fromViewController.view.alpha = kStartingViewAlpfha;
            toViewController.view.frame = endFrameToView;
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                // If the state of toViewController is not changed back to normal it's going to stay this way.
                // Taking care of consistancy of what's find at the start and the end point is especially important
                // if it's possible that a transition controller might changed.
                toViewController.view.alpha = 1.0;
                [transitionContext completeTransition:NO];
            }else{
                [transitionContext completeTransition:YES];
            }
        }];
    }
}

@end
