//
//  QMSignUpController.m


#import "QMSignUpController.h"
#import "QMWelcomeScreenViewController.h"
#import "QMLicenseAgreement.h"
#import "UIImage+Cropper.h"
#import "REAlertView+QMSuccess.h"
#import "SVProgressHUD.h"
#import "QMApi.h"
#import "QMImagePicker.h"
#import "REActionSheet.h"
#import "QMMainTabBarController.h"
#import "AppDelegate.h"
#import "APNumberPad/APNumberPad.h"
#import "QMFAQViewController.h"
#import "QMIAPViewController.h"
#import "QMLicenseAgreementViewController.h"
#import "QMSettingsManager.h"
#import "InitViewController.h"




@interface QMSignUpController () <APNumberPadDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, readwrite, nonatomic) IBOutlet UITextField *wefieNumberField;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UIView *popupView;


@property (strong, nonatomic) UIImage *cachedPicture;

- (IBAction)chooseUserPicture:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)clickQuestionBtn:(id)sender;

@end

@implementation QMSignUpController
{
    NSUInteger userNumber;
}

- (void)dealloc {
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ---------- test --------------
    
//   self.fullNameField.text = @"test";
//   self.emailField.text = @"test@test.com";
//   self.passwordField.text = @"12345678";
//    self.wefieNumberField.text = @"444444333333";
    
    // ---------- test ---------------

    self.wefieNumberField.delegate = self;
    
    self.wefieNumberField.inputView =({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        [numberPad.leftFunctionButton setTitle:@"Done" forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad;
    });

    userNumber = 0;
    
    [self retrieveAllUsersFromPage:1];

    self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
    self.userImage.layer.masksToBounds = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Actions

- (IBAction)hideKeyboard:(id)sender {
    [sender resignFirstResponder];
}


#pragma mark - APNumberPadDelegate

- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    if ([textInput isEqual:self.wefieNumberField]) {
        [functionButton setTitle:[functionButton.currentTitle stringByAppendingString:@""] forState:UIControlStateNormal];
        [self.wefieNumberField resignFirstResponder];

    }
}

- (IBAction)chooseUserPicture:(id)sender {
    
    __weak __typeof(self)weakSelf = self;
    
   
    
    [QMImagePicker chooseSourceTypeInVC:self allowsEditing:YES result:^(UIImage *image) {
        
        [weakSelf.userImage setImage:image];
        weakSelf.cachedPicture = image;
        [AppDelegate sharedInstance].avatarImageForSignUp = image;

    }];
}

- (IBAction)pressentUserAgreement:(id)sender
{
    if (!QMApi.instance.isInternetConnected) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_CHECK_INTERNET_CONNECTION", nil) actionSuccess:NO];
        return;
    }
    
    BOOL flag = [[QMApi instance].settingsManager userAgreementAccepted];
    if(!flag){
     
        [AppDelegate sharedInstance].isManualAgreement = YES;
        
    }
    
    [QMLicenseAgreement checkAcceptedUserAgreementInViewController:self completion:nil];

}
- (IBAction)signUp:(id)sender
{
    if (!QMApi.instance.isInternetConnected) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_CHECK_INTERNET_CONNECTION", nil) actionSuccess:NO];
        return;
    }
    [self fireSignUp];
}

- (IBAction)clickQuestionBtn:(id)sender {
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Help" message:@"Wefie Number. Adding a Wefie number to your account will enable others to call you by your Wefie number, without worrying about country code, area code, and roaming, so long as you are Internet-connected. You can always add a number later if not now. Please note: once you decide a Wefie number for your account, you will not be able to change it again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [myAlert show];
    
}

- (void)fireSignUp
{
    NSString *fullName = self.fullNameField.text;
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    NSString *wefieNumber = self.wefieNumberField.text;
    
    
    [AppDelegate sharedInstance].fullNameForSignUp = self.fullNameField.text;
    [AppDelegate sharedInstance].emailAddressForSignUp = self.emailField.text;
    [AppDelegate sharedInstance].passwordForSignUp = self.passwordField.text;
    [AppDelegate sharedInstance].wefiePhoneNumberForSignUp = self.wefieNumberField.text;
    
    
    
    __weak __typeof(self)weakSelf = self;

    
    if (fullName.length == 0 || password.length == 0 || email.length == 0) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_FILL_IN_ALL_THE_FIELDS", nil) actionSuccess:NO];
        return;
    }
    if(wefieNumber.length != 0){
        
        if(wefieNumber.length != 12){

        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wefie Number must be 12 digits!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [myAlert show];
        return;
        }
        
        if(![self checkingWefieNumber:wefieNumber]){
            
            //NSString *suggestedPhoneNumbers  = [[NSString alloc] init];
            //NSArray *arr = [self makeSuggestionWefieNumber];
            //suggestedPhoneNumbers = [arr componentsJoinedByString:@","];

            NSString *messages = [[NSString alloc] init];
            messages = @"This Wefie number is already taken. Please try another Wefie number!";
            //NSString *suffixMessage = @") is already taken.";
            
            //messages = [preMessage stringByAppendingString:wefieNumber];
           // messages = [messages stringByAppendingString:suffixMessage];

            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:messages delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
            return;
        }
        
    }

    [QMLicenseAgreement checkAcceptedUserAgreementInViewController:self completion:^(BOOL userAgreementSuccess) {
        
        if (userAgreementSuccess) {

            
            if([AppDelegate sharedInstance].isPurchaseSignup){
            
                return ;
            }
            
            if([self isInAppPurchase:self.wefieNumberField.text]){
            
               QMLicenseAgreementViewController *agreementVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QMLicenceAgreementControllerID"];
                [self presentViewController:agreementVC animated:NO completion:nil];
                
//                QMIAPViewController *iapVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QMIAPViewController"];
//                
//                [[InitViewController sharedInstance] pushViewController:iapVC animated:YES];
//                
                
                
                
                return;
            }
            
            
            QBUUser *newUser = [QBUUser user];
            
            newUser.fullName = fullName;
            newUser.email = email;
            newUser.password = password;
            newUser.phone = wefieNumber;
            
            newUser.tags = [[NSMutableArray alloc] initWithObjects:@"ios", nil];
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];

            void (^presentTabBar)(void) = ^(void) {
                
                [SVProgressHUD dismiss];
                QMMainTabBarController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QMMainTabBarController"];
                vc.selectedIndex = 4;
                [self presentViewController:vc animated:YES completion:nil];
               
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:true forKey:@"isFristSignup"];
                [defaults synchronize];
                
             //   [weakSelf performSegueWithIdentifier:kTabBarSegueIdnetifier sender:nil];
 
            };
            
            [[QMApi instance] signUpAndLoginWithUser:newUser rememberMe:YES completion:^(BOOL success) {
                
                if (success) {
                    
                    if (weakSelf.cachedPicture) {
                        
                        [SVProgressHUD showProgress:0.f status:nil maskType:SVProgressHUDMaskTypeClear];
                        [[QMApi instance] updateUser:nil image:weakSelf.cachedPicture progress:^(float progress) {
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
    }]; 
}

- (BOOL) isInAppPurchase:(NSString*)string{

    if([string isEqualToString:@""]){
    
        return FALSE;
    }
    
    NSString *fourString = [string substringWithRange:NSMakeRange(0, 4)];
    NSString *sixString = [string substringWithRange:NSMakeRange(0, 6)];
    NSString *reverseSixString;
    
    // myString is "hi"
    NSMutableString *reversedString = [NSMutableString string];
    NSInteger charIndex = [sixString length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reversedString appendString:[sixString substringWithRange:subStrRange]];
    }
    // outputs "ih"
    
    reverseSixString = reversedString;
    
    // first case : abcdefabcdef : 123456123456, 333333333333, 874819874819
    
    if ([sixString isEqualToString:[string substringWithRange:NSMakeRange(6, 6)]]){
        return TRUE;
    }
    
    // second case :abcdeffedcba : 123456654321, 222224422222, 190088880091
    
    if([reverseSixString isEqualToString:[string substringWithRange:NSMakeRange(6, 6)]]){
    
        return TRUE;
    }
    
    // third case: aaaaaabbbbbb : 444444777777, 999999888888, 333333111111
    
        /* this is the special case of 5,6 case ! */
    
    // fourth case : abcdabcdabcd: 123412341234, 981298129812, 800080008000
    if([fourString isEqualToString:[string substringWithRange:NSMakeRange(4, 4)]] &&
       [fourString isEqualToString:[string substringWithRange:NSMakeRange(8, 4)]] ){
    
        return  TRUE;
    }

    // fifth case : aaaabbbbcccc : 111122223333, 999911115555, 666600000000
    if([self isAllEqual:[string substringWithRange:NSMakeRange(0, 4)]] &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(4, 4)]] &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(8, 4)]]){
    
        return TRUE;
    }

    // sixth case: aaabbbcccddd : 333555999222, 111000888000, 777555555666
    
    if([self isAllEqual:[string substringWithRange:NSMakeRange(0, 3)]] &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(3, 3)]] &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(6, 3)]] &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(9, 3)]]  ){
    
        return  TRUE;
    }

    // seventh case : aabbccddeeff : 445599887733, 881111223377, 110000000099
    if([self isAllEqual:[string substringWithRange:NSMakeRange(0, 2)]]  &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(2, 2)]]  &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(4, 2)]]  &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(6, 2)]]  &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(8, 2)]]  &&
       [self isAllEqual:[string substringWithRange:NSMakeRange(10, 2)]]  ){
        
        return TRUE;
    }

    // eight case :abcdefgggggg : 293456888888, 169999999999, 300000000000
    
    if([self isAllEqual:[string substringWithRange:NSMakeRange(6, 6)]] ){
    
        return  TRUE;
    }

    // nineth case : aaaaaabcdefg: 555555129834, 777777123456, 222222987654
    
    if([self isAllEqual:[string substringWithRange:NSMakeRange(0, 6)]]){
        
        return  TRUE;
    }


    return FALSE;
}
- (BOOL) isAllEqual:(NSString*)string{

    NSInteger length = string.length;
    NSString *firstString =[string substringWithRange:NSMakeRange(0,1)];
    
    for (int i = 0; i < length ; i++)
    {
        if(![firstString isEqualToString:[string substringWithRange:NSMakeRange(i,1)]])
            return FALSE;
    }

    return TRUE;
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
- (BOOL) checkingWefieNumber:(NSString*) wefieNumber{
//  if wefieNumber existed in  phoneNumbers alreay returen NO , if Not , then returen YES
    
    NSMutableArray *userPhoneNumbersArr;
    NSUInteger totalUserNumber;
    
    userPhoneNumbersArr = [[NSMutableArray alloc] init];
    
    totalUserNumber = [AppDelegate sharedInstance].users.count;
    
    for(NSUInteger i = 0 ; i < totalUserNumber ; i++){
    
        QBUUser *user = [[AppDelegate sharedInstance].users objectAtIndex:i];
        
        NSLog(@" user.phone%@" , user.phone);
        
        if(user.phone != nil){
        
            [userPhoneNumbersArr addObject:user.phone];
        }
        
    }

    if ([userPhoneNumbersArr containsObject:wefieNumber]) {
        return NO;
    }

    return YES;
}
- (NSArray*) makeSuggestionWefieNumber{

    NSMutableArray *suggestedPhoneNumberArr = [[NSMutableArray alloc] init];
    NSString *letters = @"0123456789";
    
    while(suggestedPhoneNumberArr.count != 5){
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 12];
    for (int i=0; i<12; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    if([self checkingWefieNumber:randomString]){
    
        [suggestedPhoneNumberArr addObject:randomString];
    }
    
    }

    return suggestedPhoneNumberArr;
    


}

@end
