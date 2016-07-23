//
//  QMCallWMViewController.m
//  Wefie
//
//  Created by black2 on 5/18/15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "QMCallWMViewController.h"
#import "APNumberPad.h"
#import "AppDelegate.h"
#import "REAlertView+QMSuccess.h"
#import "QMApi.h"
#import "REAlertView.h"
#import "QMAlertsFactory.h"

#import "QMUsersService.h"






@interface QMCallWMViewController ()

@property (weak, nonatomic) IBOutlet UITextField *wefieNumberField;
@property (weak, nonatomic) IBOutlet UIButton *videoCallBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioCallBtn;


@end

@implementation QMCallWMViewController
{
   
    NSString *wefieNumber;
     NSUInteger userNumber;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.wefieNumberField.delegate = self;
    
    userNumber = 0;
    [self retrieveAllUsersFromPage:1];
    
    
    self.wefieNumberField.inputView =({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        [numberPad.leftFunctionButton setTitle:@"Done" forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad;
    });
}

- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    if ([textInput isEqual:self.wefieNumberField]) {
        [functionButton setTitle:[functionButton.currentTitle stringByAppendingString:@""] forState:UIControlStateNormal];
        [self.wefieNumberField resignFirstResponder];
        
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField != self.wefieNumberField)
        return YES;
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 12;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)videoCallBtnClicked:(id)sender {
    
    
    if(![self checkingHavingWefieNumber]){
        
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must have a Wefie number before calling other Wefie numbers." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        
        return;
        
    }
    
    if([self.wefieNumberField.text isEqual:@""]){
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have to input the wefie number!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        
        return;
    }
    
    if(self.wefieNumberField.text.length != 12){
        
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wefie number must be 12 digits!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        
        return;
    }
    
    if([self checkingWefieNumber:self.wefieNumberField.text]){
    
    
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This wefie number does not exist!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        return;
        
    }
    
    
    [AppDelegate sharedInstance].isWefieNumberCall = YES;
    
    
    QBUUser *selectedUser = [self findUserFromPhoneNumber:self.wefieNumberField.text];

    
    if( [[QMApi instance].usersService userIDIsInPendingList:selectedUser.ID] ) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_CANT_MAKE_CALLS", nil) actionSuccess:NO];
    }
    else{
        [[QMApi instance] callToUser:@(selectedUser.ID) conferenceType:QBConferenceTypeVideo];
    }
    
    
}
- (IBAction)audioCallBtnClicked:(id)sender {
    
    if(![self checkingHavingWefieNumber]){
    
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must have a Wefie number before calling other Wefie numbers." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        
        return;
        
    }
    
    if([self.wefieNumberField.text isEqual:@""]){
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You have to input the wefie number!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        
        return;
    }
    
    if(self.wefieNumberField.text.length != 12){
    
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wefie number must be 12 digits!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        
        return;
    }
    
    
    if([self checkingWefieNumber:self.wefieNumberField.text]){
    
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"This wefie number does not exist!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        
        return;
    }
    
    [AppDelegate sharedInstance].isWefieNumberCall = YES;

    QBUUser *selectedUser = [self findUserFromPhoneNumber:self.wefieNumberField.text];

//    if( [[QMApi instance].usersService userIDIsInPendingList:selectedUser.ID] ) {
//        [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_CANT_MAKE_CALLS", nil) actionSuccess:NO];
//    }
//    else{
        [[QMApi instance] callToUser:@(selectedUser.ID) conferenceType:QBConferenceTypeAudio];
//    }
    
    
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL) checkingWefieNumber:(NSString*) wefieNumber{
    //  if wefieNumber existed in  phoneNumbers alreay returen NO , if Not , then returen YES
    
    NSMutableArray *userPhoneNumbersArr;
    NSUInteger totalUserNumber;
    
    userPhoneNumbersArr = [[NSMutableArray alloc] init];
    
    totalUserNumber = [AppDelegate sharedInstance].users.count;
    
    for(NSUInteger i = 0 ; i < totalUserNumber ; i++){
        
        QBUUser *user = [[AppDelegate sharedInstance].users objectAtIndex:i];
        
        //NSLog(@" user.phone%@" , user.phone);
        
        if(user.phone != nil){
            
            [userPhoneNumbersArr addObject:user.phone];
        }
        
    }
    
    if ([userPhoneNumbersArr containsObject:wefieNumber]) {
        return NO;
    }
    
    return YES;
}

// @@@
- (void)retrieveAllUsersFromPage:(int)page{
    
    
    [QBRequest usersForPage:[QBGeneralResponsePage responsePageWithCurrentPage:page perPage:100] successBlock:^(QBResponse *response, QBGeneralResponsePage *pageInformation, NSArray *users) {
        
        [AppDelegate sharedInstance].users  = users;
        
        userNumber += users.count;
        if (pageInformation.totalEntries > userNumber) {
            [self retrieveAllUsersFromPage:pageInformation.currentPage + 1];
        }
    } errorBlock:^(QBResponse *response) {
        // Handle error
    }];
}
// @@@

- (QBUUser*) findUserFromPhoneNumber:(NSString*) wefieNumber{

    NSUInteger totalUserNumber;
    totalUserNumber = [AppDelegate sharedInstance].users.count;
    
    for(NSUInteger i = 0 ; i < totalUserNumber ; i++){
        
        QBUUser *user = [[AppDelegate sharedInstance].users objectAtIndex:i];
        
        if ([wefieNumber isEqual:user.phone]) {
            return  user;
        }
    }

    return nil;
    
}

- (BOOL) checkingHavingWefieNumber{

    NSString *currentUserWefieNumber = [QMApi instance].currentUser.phone;
    if(!currentUserWefieNumber){
    
        return FALSE;
    }
    if([currentUserWefieNumber isEqualToString:@""]){
    
        return FALSE;
    }
    
    return TRUE;
}



@end
