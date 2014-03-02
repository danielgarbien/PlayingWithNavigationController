//
//  NavigationControllerDelegate.m
//  PlayingWithNavigationController
//
//  Created by Daniel Garbień on 10/10/13.
//  Copyright (c) 2013 Daniel Garbień. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "HorizontalStandardTransition.h"
#import "VerticalInteractiveTransition.h"

@interface NavigationControllerDelegate ()

@property (weak, nonatomic) UIViewController * presentedViewController;
@property (assign, nonatomic) BOOL interactive;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition * interactiveTransition;
@property (strong, nonatomic) HorizontalStandardTransition * noninteractiveTransition;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition * customInteractiveTransition;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer * edgePanGestureRecognizer;

@end

@implementation NavigationControllerDelegate

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    [self updateInteractiveTransitionForViewController:self.presentedViewController];

    if (operation == UINavigationControllerOperationPush){
        self.noninteractiveTransition.presenting = YES;
    }
    return self.noninteractiveTransition;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0)
{
    // return interactiveTransition only if transition is interactive
    if (!self.interactive){
        return nil;
    }
    return self.interactiveTransition;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // save a weak reference to actually presented view controller
    self.presentedViewController = viewController;

    // add a gesture recognizer if it's not a first controller on the navigation stack (it's used to pop a controller)
    // AND if it hasn't been added yet
    if ([navigationController.viewControllers count] == 1) {
        return;
    }
    if ([viewController.view.gestureRecognizers containsObject:self.edgePanGestureRecognizer]) {
        return;
    }
    [viewController.view addGestureRecognizer:self.edgePanGestureRecognizer];
}

#pragma mark - UIScreenEdgePanGestureRecognizer

- (void)userDidPan:(UIScreenEdgePanGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.presentedViewController.view.superview];
    CGPoint velocity = [sender velocityInView:self.presentedViewController.view.superview];
    CGFloat ratio = location.x / CGRectGetWidth(self.presentedViewController.view.bounds);
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        // If pan occured on the right edge - return. Only dismissal is supported.
        if (location.x > CGRectGetMidX(self.presentedViewController.view.bounds)) {
            return;
        }
        self.interactive = YES;
        [self.presentedViewController.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        [self.interactiveTransition updateInteractiveTransition:ratio];
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateCancelled) {
        [self.interactiveTransition cancelInteractiveTransition];
        self.interactive = NO;
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateFailed) {
        // do nothing
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
            self.interactiveTransition.completionSpeed = 1 - ratio;
            [self.interactiveTransition finishInteractiveTransition];
        }
        else{
            self.interactiveTransition.completionSpeed = ratio;
            [self.interactiveTransition cancelInteractiveTransition];
        }
        self.interactive = NO;
        return;
    }
}


#pragma mark - Private Properties

- (UIScreenEdgePanGestureRecognizer *)edgePanGestureRecognizer
{
    if (_edgePanGestureRecognizer == nil){
        _edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(userDidPan:)];
        _edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    }
    return _edgePanGestureRecognizer;
}

#pragma mark - Private Methods

- (void)updateInteractiveTransitionForViewController:(UIViewController *)viewControlle
{
    if ([self.presentedViewController respondsToSelector:@selector(navigationControllerAnimationPreference)]){
        __weak id<NavigationControlAnimationPreferenceDelegate> animationPreferenceDelegate = (id<NavigationControlAnimationPreferenceDelegate>) self.presentedViewController;
        switch ([animationPreferenceDelegate navigationControllerAnimationPreference]) {
            case NavigationControllerInteractiveAnimationNone:
                self.noninteractiveTransition = nil;
                self.interactiveTransition = nil;
                break;
            case NavigationControllerInteractiveAnimationCustomHorizontal:
                self.noninteractiveTransition = [[HorizontalStandardTransition alloc] init];
                self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
                break;
            case NavigationControllerInteractiveAnimationCustomVertical:
                self.noninteractiveTransition = [[HorizontalStandardTransition alloc] init];
                self.interactiveTransition = [[VerticalInteractiveTransition alloc] init];
                break;
            default:
                break;
        }
        return;
    }
    // default animation
    self.noninteractiveTransition = [[HorizontalStandardTransition alloc] init];
    self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
}

@end
