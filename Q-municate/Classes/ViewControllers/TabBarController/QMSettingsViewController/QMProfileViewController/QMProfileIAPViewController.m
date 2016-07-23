//
//  QMProfileIAPViewController.m
//  Wefie
//
//  Created by black2 on 5/27/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "QMProfileIAPViewController.h"
#import "SVProgressHUD.h"
#import "QMApi.h"
#import "IAPManager.h"


#define IAP_PRODUCT_ID @"iap.wefie.purchase"


@interface QMProfileIAPViewController ()

@end

@implementation QMProfileIAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)purchaseBtnClicked:(id)sender {
    [SVProgressHUD show];
    
    [[IAPManager sharedIAPManager] purchaseProductForId:IAP_PRODUCT_ID
                                             completion:^(SKPaymentTransaction *transaction) {
                                                 
                                                 [SVProgressHUD dismiss];
                                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                 NSLog(@"Success");
                                                 
                                                 
//                                                 [self purchaseSignUp];
                                                 [self saveChanged:self.currentUserForPurhase];
                                                 
                                                 
                                             } error:^(NSError *err) {
                                                 [SVProgressHUD dismiss];
                                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                 
                                                 UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Purchase failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                 
                                                 [myAlert show];
                                                 
                                                 NSLog(@"Failed");
                                             }];

    
}
- (IBAction)restoreBtnClicked:(id)sender {
    
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

- (void)saveChanged:(QBUUser*)user{

    [SVProgressHUD showProgress:0.f status:nil maskType:SVProgressHUDMaskTypeClear];
    [[QMApi instance] updateUser:user image:self.avatarImage progress:^(float progress) {
        [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
    } completion:^(BOOL success) {
        
        if (success) {
//            weakSelf.avatarImage = nil;
//            [weakSelf updateProfileView];
//            [weakSelf setUpdateButtonActivity];
            
            NSLog(@"saveChanged is success!");
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }
        [SVProgressHUD dismiss];
    }];
    
}

@end
