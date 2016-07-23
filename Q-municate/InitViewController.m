//
//  InitViewController.m
//  Tinder
//
//  Created by Jesper on 4/30/15.
//  Copyright (c) 2015 AiLan. All rights reserved.
//

#import "InitViewController.h"

@implementation InitViewController

static InitViewController *singletonInstance;

+ (InitViewController *)sharedInstance
{
    if (!singletonInstance)
        NSLog(@"SlideNavigationController has not been initialized. Either place one in your storyboard or initialize one in code");
    
    return singletonInstance;
}

- (id)init
{
    if (self = [super init])
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    if (singletonInstance)
        NSLog(@"Singleton instance already exists. You can only instantiate one instance of SlideNavigationController. This could cause major issues");
    
    singletonInstance = self;
}


@end
