//
//  GlobalPool.h
//  Pocket Parties
//
//  Created by Ma Shang on 1/31/13.
//  Copyright (c) 2013 Ma Shang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <Quickblox/Quickblox.h>
#import <QuartzCore/QuartzCore.h>
#define QB_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define PHONE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface GlobalPool : NSObject

+ (GlobalPool *)sharedInstance;

@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, strong) NSString *udid;
@property (nonatomic, strong) NSString *qbID;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) QBUUser *mAccout;
@property (nonatomic, assign) NSUInteger userID;

- (void)qSignUp;
- (void)qSignin;
@end