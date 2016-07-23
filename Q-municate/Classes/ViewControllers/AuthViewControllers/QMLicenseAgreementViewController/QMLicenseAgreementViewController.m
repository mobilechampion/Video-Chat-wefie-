//
//  QMLicenseAgreementViewController.m


#import "QMLicenseAgreementViewController.h"
#import <SVProgressHUD.h>
#import "REAlertView.h"
#import "QMApi.h"
#import "QMSettingsManager.h"
#import "AppDelegate.h"
#import "QMIAPViewController.h"

NSString *const kQMAgreementUrl = @"http://www.ideayoga.com/wefie/terms/terms.htm";

@interface QMLicenseAgreementViewController ()

<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *acceptButton;

@end

@implementation QMLicenseAgreementViewController

- (void)dealloc {
    NSLog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.048 green:0.361 blue:0.606 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    
    BOOL licenceAccepted = [[QMApi instance].settingsManager userAgreementAccepted];
    
    if (licenceAccepted) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [SVProgressHUD show];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kQMAgreementUrl]];
    [self.webView loadRequest:request];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBackIAP) name:@"onBackFromIAP" object:nil];
    self.isBackIAP = NO;
    
}

- (void) onBackIAP
{
    self.isBackIAP = YES;
    
    [AppDelegate sharedInstance].isPurchaseSignup = NO;

    [self dismissViewControllerSuccess:NO];
}

- (void)viewWillAppear:(BOOL)animated{

    if([[QMApi instance].settingsManager userAgreementAccepted] && !self.isBackIAP){
    
        if([self isInAppPurchase:[AppDelegate sharedInstance].wefiePhoneNumberForSignUp]){
        
            QMIAPViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"QMIAPViewController"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
             [self presentViewController:nav animated:NO completion:nil];
        }
    }
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerSuccess:NO];
}

- (void)dismissViewControllerSuccess:(BOOL)success {
    __weak __typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        
        if(weakSelf.licenceCompletionBlock) {
            
            weakSelf.licenceCompletionBlock(success);
            weakSelf.licenceCompletionBlock = nil;
        }
    }];
}

- (IBAction)acceptLicense:(id)sender {
    
//    [self dismissViewControllerSuccess:YES];
    BOOL flag = [AppDelegate sharedInstance].isManualAgreement;
    
    
    if(!flag){
    
        
        NSString *testString = [AppDelegate sharedInstance].wefiePhoneNumberForSignUp;
        
        if ([self isInAppPurchase:[AppDelegate sharedInstance].wefiePhoneNumberForSignUp]) {
        NSLog(@"this is in app purchase number ");
        [AppDelegate sharedInstance].isPurchaseSignup = YES;
        [[QMApi instance].settingsManager setUserAgreementAccepted:YES];

        QMIAPViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"QMIAPViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
    
        }else{
    
        NSLog(@"this is not in app purchse number");
        [AppDelegate sharedInstance].isPurchaseSignup = NO;
        [[QMApi instance].settingsManager setUserAgreementAccepted:YES];
        [self dismissViewControllerSuccess:YES];
    
        }
    }else{
    
        [[QMApi instance].settingsManager setUserAgreementAccepted:YES];
        [self dismissViewControllerSuccess:YES];
    }
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

    
    
#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

@end
