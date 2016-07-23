//
//  QBChatDialog+UpdateWithNotification.m


#import "QBChatDialog+UpdateWithNotification.h"

@implementation QBChatDialog (UpdateWithNotification)

- (void)updateLastMessageInfoWithMessage:(QBChatMessage *)message isMine:(BOOL)isMine
{
    self.lastMessageText = message.text;
    self.lastMessageDate = message.datetime;
    self.lastMessageUserID = message.senderID;
    
    // if message isn't mine:
    if (!isMine) {
        self.unreadMessagesCount++;
    }
}

@end
