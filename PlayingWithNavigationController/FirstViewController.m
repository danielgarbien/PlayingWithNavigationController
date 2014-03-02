//
//  FirstViewController.m
//  PlayingWithNavigationController
//
//  Created by Daniel Garbień on 10/10/13.
//  Copyright (c) 2013 Daniel Garbień. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"


@implementation FirstViewController

#pragma mark - IBActions

- (IBAction)pushNextController:(id)sender
{
    SecondViewController * second = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:second animated:YES];
}

#pragma mark - Overriden

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"First";
}

@end
