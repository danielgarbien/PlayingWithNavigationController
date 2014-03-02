//
//  SecondViewController.m
//  PlayingWithNavigationController
//
//  Created by Daniel Garbień on 10/10/13.
//  Copyright (c) 2013 Daniel Garbień. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl * segmentedControl;

@end

@implementation SecondViewController

#pragma mark - Overriden

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Second";
    self.segmentedControl.tintColor = [UIColor whiteColor];
}

#pragma mark - NavigationControlAnimationPreferenceDelegate

- (NavigationControllerAnimationPreference)navigationControllerAnimationPreference
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 1:
            return NavigationControllerInteractiveAnimationCustomHorizontal;
        case 2:
            return NavigationControllerInteractiveAnimationCustomVertical;
        default:
            return NavigationControllerInteractiveAnimationNone;
    }
}

@end
