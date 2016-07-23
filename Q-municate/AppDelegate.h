//
//  AppDelegate.h


//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationBarDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id rootViewController;
@property (strong, nonatomic) UINavigationController *mainNavController;

@property (strong,nonatomic) NSMutableArray *users;


// sign up user info
@property (strong, nonatomic) NSString *fullNameForSignUp;
@property (strong, nonatomic) NSString *emailAddressForSignUp;
@property (strong, nonatomic) NSString *passwordForSignUp;
@property (strong, nonatomic) NSString *wefiePhoneNumberForSignUp;
@property (strong, nonatomic) UIImage *avatarImageForSignUp;
// sign up user info

@property BOOL isPurchaseSignup;
@property BOOL isManualAgreement;

@property BOOL isWefieNumberCall;

+ (AppDelegate *)sharedInstance;

@end
