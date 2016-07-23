//
//  QMFAQViewController.m
//  Wefie
//
//  Created by black2 on 5/13/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "QMFAQViewController.h"

@implementation QMFAQViewController


- (void)viewDidLoad{
// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
    
    NSString *urlAddress = @"http://ideayoga.com/wefie/help/help.htm";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.FAQWebView loadRequest:requestObj];
    
    
}


@end
