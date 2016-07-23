//
//  QMApi+Calls.m


#import "QMApi.h"
#import "QMAVCallManager.h"

@implementation QMApi (Calls)

- (void)callToUser:(NSNumber *)userID conferenceType:(enum QBConferenceType)conferenceType
{
    [self callToUser:userID conferenceType:conferenceType sendPushNotificationIfUserIsOffline:YES];
}

- (void)callToUser:(NSNumber *)userID conferenceType:(enum QBConferenceType)conferenceType sendPushNotificationIfUserIsOffline:(BOOL)pushEnabled
{
    [self.avCallManager callToUsers:@[userID] withConferenceType:conferenceType pushEnabled:pushEnabled];
}

- (void)acceptCall
{
    [self.avCallManager acceptCall];
}

- (void)rejectCall
{
    [self.avCallManager rejectCall];
}

- (void)finishCall
{
    [self.avCallManager hangUpCall];
}

@end
