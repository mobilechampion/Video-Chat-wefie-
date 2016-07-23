//
//  QMLicenseAgreement.h


#import <Foundation/Foundation.h>

@interface QMLicenseAgreement : NSObject

+ (void)checkAcceptedUserAgreementInViewController:(UIViewController *)vc completion:(void(^)(BOOL success))completion;

@end
