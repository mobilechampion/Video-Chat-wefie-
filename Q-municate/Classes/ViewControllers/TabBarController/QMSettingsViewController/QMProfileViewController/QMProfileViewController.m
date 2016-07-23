//
//  QMProfileViewController.m


#import "QMProfileViewController.h"
#import "QMPlaceholderTextView.h"
#import "QMApi.h"
#import "REAlertView+QMSuccess.h"
#import "QMImageView.h"
#import "SVProgressHUD.h"
#import "QMContentService.h"
#import "UIImage+Cropper.h"
#import "REActionSheet.h"
#import "QMImagePicker.h"
#import "QMUsersUtils.h"
#import "APNumberPad.h"
#import "AppDelegate.h"
#import "QMProfileIAPViewController.h"


@interface QMProfileViewController ()

<UITextFieldDelegate, UITextViewDelegate,APNumberPadDelegate>

@property (weak, nonatomic) IBOutlet QMImageView *avatarView;
@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet QMPlaceholderTextView *statusField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateProfileButton;

@property (strong, nonatomic) NSString *fullNameFieldCache;
@property (copy, nonatomic) NSString *phoneFieldCache;
@property (copy, nonatomic) NSString *statusTextCache;


@property (nonatomic, strong) UIImage *avatarImage;

@property BOOL isPossibleChangeWN;

@end


@implementation QMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarView.imageViewType = QMImageViewTypeCircle;
    self.statusField.placeHolder = @"Add brief intro...";
    
    self.phoneNumberField.delegate = self;
    self.phoneNumberField.inputView = ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        [numberPad.leftFunctionButton setTitle:@"Done" forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad;
    });

    
   
    
    [self updateProfileView];
    
    NSString *testString = self.currentUser.phone;
    
    if([self.phoneNumberField.text isEqualToString:@""]){
        
        self.isPossibleChangeWN = YES;
    }else{
    
        self.isPossibleChangeWN = NO;
    }
    
    [self setUpdateButtonActivity];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - APNumberPadDelegate

- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    if ([textInput isEqual:self.phoneNumberField]) {
        [functionButton setTitle:[functionButton.currentTitle stringByAppendingString:@""] forState:UIControlStateNormal];
        [self.phoneNumberField resignFirstResponder];
        
    }
}


- (void)updateProfileView {

    self.fullNameFieldCache = self.currentUser.fullName;
    self.phoneFieldCache = self.currentUser.phone ?: @"";
    self.statusTextCache = self.currentUser.status ?: @"";
    
    UIImage *placeholder = [UIImage imageNamed:@"upic-placeholder"];
    NSURL *url = [QMUsersUtils userAvatarURL:self.currentUser];
    
    [self.avatarView setImageWithURL:url
                         placeholder:placeholder
                             options:SDWebImageHighPriority
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                ILog(@"r - %zd; e - %zd", receivedSize, expectedSize);
                            } completedBlock:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                
                            }];
    
    self.fullNameField.text = self.currentUser.fullName;
    self.emailField.text = self.currentUser.email;
    self.phoneNumberField.text = self.currentUser.phone;
    self.statusField.text = self.currentUser.status;
    
     [self changeWefieNumberStatus];
    
}

- (IBAction)changeAvatar:(id)sender {
    
    if (!QMApi.instance.isInternetConnected) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_CHECK_INTERNET_CONNECTION", nil) actionSuccess:NO];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [QMImagePicker chooseSourceTypeInVC:self allowsEditing:YES result:^(UIImage *image) {
        
        weakSelf.avatarImage = image;
        weakSelf.avatarView.image = [image imageByCircularScaleAndCrop:weakSelf.avatarView.frame.size];
        [weakSelf setUpdateButtonActivity];
    }];
}

- (void)setUpdateButtonActivity {
    
    BOOL activity = [self fieldsWereChanged];
    self.updateProfileButton.enabled = activity;
}

- (IBAction)hideKeyboard:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)saveChanges:(id)sender {
    
    if (!QMApi.instance.isInternetConnected) {
        [REAlertView showAlertWithMessage:NSLocalizedString(@"QM_STR_CHECK_INTERNET_CONNECTION", nil) actionSuccess:NO];
        return;
    }
    
    [self.view endEditing:YES];
    
    __weak __typeof(self)weakSelf = self;
    
    if(![self.phoneNumberField.text isEqual:@""]){
        if(self.phoneNumberField.text.length != 12){
        
        UIAlertView *myAlert = [[UIAlertView  alloc] initWithTitle:@"Error" message:@"Wefie Number must be 12 digits." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        
        return ;
        
        }
    }
    
    if(![self.phoneNumberField.text isEqual:@""]){
    if(![self checkingWefieNumber:self.phoneNumberField.text] && self.isPossibleChangeWN){
        NSString *messages = [[NSString alloc] init];
        messages = @"This Wefie number is alredy taken. Please try another Wefie number!";
        //NSString *suffixMessage = @") is already taken.";
        
        //messages = [preMessage stringByAppendingString:self.phoneNumberField.text];
       // messages = [messages stringByAppendingString:suffixMessage];
        
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:messages delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [myAlert show];
        return;
    }
    }
    
    QBUUser *user = weakSelf.currentUser;
    user.fullName = weakSelf.fullNameFieldCache;
    //  user.phone = weakSelf.phoneFieldCache;
    user.phone = weakSelf.phoneNumberField.text;
    
    NSLog(@"phonefieldCache test ====  %@", weakSelf.phoneFieldCache);
    
    user.status = weakSelf.statusTextCache;
    
    
    
    
    if([self isInAppPurchase:self.phoneNumberField.text]){
    
            QMProfileIAPViewController *iapVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QMProfileIAPViewController"];
        iapVC.currentUserForPurhase = user;
        iapVC.avatarImage = self.avatarImage;
        
        [self.navigationController pushViewController:iapVC animated:YES];
        
        return;
        
    }
    
    
    
    

    
    [SVProgressHUD showProgress:0.f status:nil maskType:SVProgressHUDMaskTypeClear];
    [[QMApi instance] updateUser:user image:self.avatarImage progress:^(float progress) {
        [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
    } completion:^(BOOL success) {
        
        if (success) {
            weakSelf.avatarImage = nil;
            [weakSelf updateProfileView];
            [weakSelf setUpdateButtonActivity];
        }
        [SVProgressHUD dismiss];
    }];
}

- (BOOL)fieldsWereChanged {
    
    if (self.avatarImage) return YES;
    if (![self.fullNameFieldCache isEqualToString:self.currentUser.fullName]) return YES;
    if (![self.phoneFieldCache isEqualToString:self.currentUser.phone ?: @""]) return YES;
    if (![self.statusTextCache isEqualToString:self.currentUser.status ?: @""]) return YES;
    
    return NO;
}

#pragma mark - UITextFieldDelegate & UITextViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
     NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    NSLog(@"testfield test ==== %@ ", str);
    
    
    
    if (textField == self.fullNameField) {
        self.fullNameFieldCache = str;
        [self setUpdateButtonActivity];

    }else if(textField == self.phoneNumberField){
        
        if(range.length + range.location > textField.text.length)
        {
                  return NO;
        }
        
            self.phoneFieldCache = str;
        
            [self setUpdateButtonActivity];
    
            NSUInteger newLength = [textField.text length] + [string length] - range.length;
            

            return newLength <= 12;
    
        }

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.statusTextCache = textView.text;
    [self setUpdateButtonActivity];
}


- (void) changeWefieNumberStatus{
    
    
    NSString *currentUserWefieNumber = [QMApi instance].currentUser.phone;
    
    if( !currentUserWefieNumber){
    
        self.phoneNumberField.enabled = YES;
        return;
    }
    
    if([currentUserWefieNumber isEqualToString:@""]){
    
        self.phoneNumberField.enabled = YES;
        return ;
    }
    
    self.phoneNumberField.enabled = NO;
    self.phoneNumberField.textColor = [UIColor grayColor];

    
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




@end
