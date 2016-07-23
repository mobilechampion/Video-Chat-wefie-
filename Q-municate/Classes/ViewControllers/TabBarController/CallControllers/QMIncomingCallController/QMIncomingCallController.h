//
//  QMIncomingCallController.h


#import <UIKit/UIKit.h>

@interface QMIncomingCallController : UIViewController

@property (weak, nonatomic) QBRTCSession *session;

@property (assign, nonatomic) NSUInteger opponentID;
@property (assign, nonatomic) QBConferenceType callType;
@property (strong, nonatomic) QBUUser *opponent;

@end
