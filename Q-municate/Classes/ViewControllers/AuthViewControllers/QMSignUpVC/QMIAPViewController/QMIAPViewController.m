//
//  QMIAPViewController.m
//  Wefie
//
//  Created by black2 on 5/20/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "QMIAPViewController.h"
#import "IAPManager.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "QMApi.h"
#import "QMMainTabBarController.h"
#import "QMSignUpController.h"
#import "InitViewController.h"



#define IAP_PRODUCT_ID @"iap.wefie.purchase"

@interface QMIAPViewController ()

@end

@implementation QMIAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.048 green:0.361 blue:0.606 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
   
    // Do any additional setup after loading the view.

    self.isBackIAP = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    if(self.isBackIAP == YES)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onBackFromIAP" object:nil];
}

- (IBAction)backBtnPressed:(id)sender
{
    self.isBackIAP = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    QMSignUpController *vc = [storyboard instantiateViewControllerWithIdentifier:@"QMSignUpController"];
//
//    [[InitViewController sharedInstance] pushViewController:vc animated:YES];
//
}

-(IBAction)processPurchase:(id)sender
{
    [SVProgressHUD show];
    
    [[IAPManager sharedIAPManager] purchaseProductForId:IAP_PRODUCT_ID
                                             completion:^(SKPaymentTransaction *transaction) {
                                                 
                                                 [SVProgressHUD dismiss];
                                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                 NSLog(@"Success");
                                                 
                                                 
                                                 [self purchaseSignUp];
                                                 
                                                 
                                             } error:^(NSError *err) {
                                                 [SVProgressHUD dismiss];
                                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                 
                                                 UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Purchase failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                 
                                                 [myAlert show];
                                                 
                                                 NSLog(@"Failed");
                                             }];
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) purchaseSignUp{
    
      QBUUser *newUser = [QBUUser user];
      newUser.fullName = [AppDelegate sharedInstance].fullNameForSignUp;
      newUser.email = [AppDelegate sharedInstance].emailAddressForSignUp;
      newUser.password = [AppDelegate sharedInstance].passwordForSignUp;
      newUser.phone = [AppDelegate sharedInstance].wefiePhoneNumberForSignUp;
    
    UIImage *avatarImage = [AppDelegate sharedInstance].avatarImageForSignUp;


    
    void (^presentTabBar)(void) = ^(void) {
        
        
        QMMainTabBarController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QMMainTabBarController"];
        vc.selectedIndex = 4;
        [self presentViewController:vc animated:YES completion:nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:true forKey:@"isFristSignup"];
        [defaults synchronize];

    };
    
    [[QMApi instance] signUpAndLoginWithUser:newUser rememberMe:YES completion:^(BOOL success) {
        
        if (success) {
            
            if (avatarImage) {
                
                [SVProgressHUD showProgress:0.f status:nil maskType:SVProgressHUDMaskTypeClear];
                [[QMApi instance] updateUser:nil image:avatarImage progress:^(float progress) {
                    [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
                } completion:^(BOOL updateUserSuccess) {
                    presentTabBar();
                }];
            }
            else {
                presentTabBar();
            }
        }
        else {
            [SVProgressHUD dismiss];
        }
    }];

}

- (IBAction)pressRestore:(id)sender {
    
    [SVProgressHUD show];
    
    [[IAPManager sharedIAPManager] restorePurchasesWithCompletion:^{
        [SVProgressHUD dismiss];
        NSLog(@"Success");
    } error:^(NSError *err){
    
        [SVProgressHUD dismiss];
        
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Restore Failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        
        NSLog(@"Failed");
    }];
    
}

@end
