//
//  QMVideoP2PController.h


#import <UIKit/UIKit.h>
#import "QMBaseCallsController.h"

@interface QMVideoP2PController : QMBaseCallsController

@property (weak, nonatomic) IBOutlet QBGLVideoView *opponentsView;
@property (weak, nonatomic) IBOutlet QBGLVideoView *myView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *opponentsVideoViewBottom;

/// will disable sending local video track after invoking
/// - (void)session:(QBRTCSession *)session didReceiveLocalVideoTrack
@property (assign, nonatomic) BOOL disableSendingLocalVideoTrack;

- (IBAction)takePhotoAndSave:(id)sender;
- (IBAction)changeTakenPicture:(id)sender;

@property (weak, nonatomic) IBOutlet IAButton *takePhotoBtn;
@property (weak, nonatomic) IBOutlet IAButton *rotateBtn;

@end
