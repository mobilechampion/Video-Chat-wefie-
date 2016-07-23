//
//  QMLicenseAgreementViewController.h


#import <UIKit/UIKit.h>

typedef void (^LicenceCompletionBlock)(BOOL accepted);

@interface QMLicenseAgreementViewController : UIViewController

@property (copy, nonatomic) LicenceCompletionBlock licenceCompletionBlock;
@property BOOL isBackIAP;

@end
