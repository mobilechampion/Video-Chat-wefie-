//
//  QMContentView.h


#import <UIKit/UIKit.h>
#import "QMImageView.h"

@interface QMContentView : UIView

@property (nonatomic, weak) IBOutlet UILabel *fullNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet QMImageView *avatarView;

- (void)updateViewWithUser:(QBUUser *)user conferenceType:(QBConferenceType)conferenceType isOpponentCaller:(BOOL)isOpponentCaller;
- (void)updateViewWithStatus:(NSString *)status;

- (void)startTimerIfNeeded;
// start/restart timer
- (void)startTimer;
- (void)stopTimer;

#pragma mark - Show/Hide

- (void)show;
- (void)hide;

@end
