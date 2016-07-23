//
//  REAlertView.h


#import <UIKit/UIKit.h>

@class REAlertView;

typedef void(^REAlertButtonAction)();
typedef void(^REAlertConfiguration)(REAlertView *alertView);

@interface REAlertView : UIAlertView

- (void)dissmis;
- (void)addButtonWithTitle:(NSString *)title andActionBlock:(REAlertButtonAction)block;
+ (void)presentAlertViewWithConfiguration:(REAlertConfiguration)configuration;

@end