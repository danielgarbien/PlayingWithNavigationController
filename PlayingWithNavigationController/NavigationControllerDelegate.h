//
//  NavigationControllerDelegate.h
//  PlayingWithNavigationController
//
//  Created by Daniel Garbień on 10/10/13.
//  Copyright (c) 2013 Daniel Garbień. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NavigationControllerAnimationPreference){
    NavigationControllerInteractiveAnimationNone,
    NavigationControllerInteractiveAnimationCustomHorizontal,
    NavigationControllerInteractiveAnimationCustomVertical
};

/**
 * This protocol represents preferred transition type used when a view controller is being popped.
 * Contained controller may this way decide about the preferred animation. By default it's Horizontal standard transition.
 */
@protocol NavigationControlAnimationPreferenceDelegate <NSObject>

- (NavigationControllerAnimationPreference)navigationControllerAnimationPreference;

@end

@interface NavigationControllerDelegate : NSObject <UINavigationControllerDelegate>

@end
