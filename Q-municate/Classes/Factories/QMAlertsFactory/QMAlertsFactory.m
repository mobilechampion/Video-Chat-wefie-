//
//  QMAlertsFactory.m


#import "QMAlertsFactory.h"
#import "REAlertView.h"

@implementation QMAlertsFactory

+ (void)comingSoonAlert {
    
    [REAlertView presentAlertViewWithConfiguration:^(REAlertView *alertView) {
        alertView.title = NSLocalizedString(@"QM_STR_COMING_SOON", nil);
        [alertView addButtonWithTitle:NSLocalizedString(@"QM_STR_OK", nil) andActionBlock:nil];
    }];
}

@end
