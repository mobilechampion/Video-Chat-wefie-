//
//  QBChatDialog+UpdateWithNotification.h


#import <Foundation/Foundation.h>

@interface QBChatDialog (UpdateWithNotification)

- (void)updateLastMessageInfoWithMessage:(QBChatMessage *)message isMine:(BOOL)isMine;

@end
