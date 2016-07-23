//
//  QMContactRequestCell.m


#import "QMContactRequestCell.h"
#import "QMChatUtils.h"
#import "QMApi.h"

@interface QMContactRequestCell()

@property (nonatomic, strong) QBUUser *opponent;

@end


@implementation QMContactRequestCell


- (void)setNotification:(QMMessage *)notification
{
    if (![_notification isEqual:notification]) {
        _notification = notification;
    }
    self.opponent = [[QMApi instance] userWithID:notification.senderID];
    self.fullNameLabel.text = [QMChatUtils messageTextForNotification:notification];
}


- (IBAction)rejectButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(contactRequestWasRejectedForUser:)]) {
        [self.delegate contactRequestWasRejectedForUser:self.opponent];
    }
}

- (IBAction)acceptButtonPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(contactRequestWasAcceptedForUser:)]) {
        [self.delegate contactRequestWasAcceptedForUser:self.opponent];
    }
}

@end
