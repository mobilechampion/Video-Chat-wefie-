//
//  REAlertView+QMSuccess.m


#import "REAlertView+QMSuccess.h"

@implementation REAlertView (QMSuccess)

+ (void)showAlertWithMessage:(NSString *)messageString actionSuccess:(BOOL)success {
    
    [REAlertView presentAlertViewWithConfiguration:^(REAlertView *alertView) {
        alertView.title = success ? NSLocalizedString(@"QM_STR_SUCCESS", nil) : NSLocalizedString(@"QM_STR_ERROR", nil);
        alertView.message = messageString;
        if ([messageString isEqualToString:@"Id should be a positive number"]){
            NSLog(@"Alert91919 : %@",messageString);
        }
        [alertView addButtonWithTitle:NSLocalizedString(@"QM_STR_OK", nil) andActionBlock:^{}];
    }];
}

@end
