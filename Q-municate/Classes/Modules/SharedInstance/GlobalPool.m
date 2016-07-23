//
//  GlobalPool.m
//  Pocket Parties
//
//  Created by Ma Shang on 1/31/13.
//  Copyright (c) 2013 Ma Shang. All rights reserved.
//

#import "GlobalPool.h"
#import <Quickblox/Quickblox.h>
#import <Quickblox/QBRequest+QBAuth.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "DataManager.h"
#import "FXKeychain.h"

@implementation GlobalPool

+ (GlobalPool *)sharedInstance
{
    static GlobalPool *instance = nil;
    
    if (instance == nil)
    {
        instance = [[GlobalPool alloc] init];
    }
    
    return instance;
}

- (id)init {
    
    if(self = [super init]) {
        if([FXKeychain defaultKeychain][@"udid"]) {
            self.udid = [FXKeychain defaultKeychain][@"udid"];
        } else {
            self.udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [FXKeychain defaultKeychain][@"udid"] = self.udid;
        }
        self.isLoggedIn = NO;
    }
    NSLog(@"USERID = %@",self.udid);
    //7A82B2AC-D0C3-47BF-B378-37AAD8CDC49F
    return self;
    
}
- (void)qSignUp {

    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        QBUUser *user = [QBUUser user];
        user.login = [GlobalPool sharedInstance].udid;
        user.password = @"12345678";
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
            self.mAccout = user;
            [[DataManager SharedDataManager] setDefaultUserObject:[NSNumber numberWithBool:YES] forKey:@"isSignup"];
        } errorBlock:^(QBResponse *response) {
            NSLog(@"%@",response);
        }];

    } errorBlock:^(QBResponse *response) {
        //Handle error here
          NSLog(@"%@", response.error);
    }];
}
- (void)qSignin
{
    // Authenticate user
    
    if ([[DataManager SharedDataManager] defaultUserObjectForKey:@"isSignup"]) {
        [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
            [QBRequest logInWithUserLogin:[GlobalPool sharedInstance].udid password:@"12345678"
                             successBlock:[self successBlock] errorBlock:[self errorBlock]];
            
        } errorBlock:^(QBResponse *response) {
            //Handle error here
            NSLog(@"%@", response.error);   
        }];

    } else {
        [self qSignUp];
    }
}
- (void (^)(QBResponse *response, QBUUser *user))successBlock
{
    return ^(QBResponse *response, QBUUser *user) {
        self.mAccout = user;
    };
}

- (QBRequestErrorBlock)errorBlock
{
    return ^(QBResponse *response) {
        // Handle error
    };
}
@end
