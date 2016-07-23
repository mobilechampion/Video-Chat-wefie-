//
//  QMAudioCallController.m


#import "QMAudioCallController.h"
#import "QMAVCallManager.h"

@implementation QMAudioCallController
{
    BOOL isFirstRun;
}

#pragma mark - Overridden methods

- (void)startCall {
    [[QMApi instance] callToUser:@(self.opponent.ID) conferenceType:QBConferenceTypeAudio];
    [QMSoundManager playCallingSound];
    isFirstRun = YES;
}

- (void)session:(QBRTCSession *)session connectedToUser:(NSNumber *)userID{
    [super session:session connectedToUser:userID];
    
    if( isFirstRun ){
        isFirstRun = NO;
        // Me is not a caller
    
        if( [QMApi instance].currentUser.ID != [userID unsignedIntegerValue] ){
            [[QMApi instance].avCallManager setAudioSessionDefaultToHeadphoneIfNeeded];
        }
        [self updateButtonsState];
    }
}
@end