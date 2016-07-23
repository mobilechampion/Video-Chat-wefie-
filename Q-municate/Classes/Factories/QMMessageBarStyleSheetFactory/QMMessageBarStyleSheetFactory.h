//
//  QMMessageBarStyleSheetFactory.h


#import <Foundation/Foundation.h>
#import "MPGNotification.h"

@interface QMMessageBarStyleSheetFactory : NSObject

+ (void)showMessageBarNotificationWithMessage:(QBChatAbstractMessage *)chatMessage chatDialog:(QBChatDialog *)chatDialog completionBlock:(MPGNotificationButtonHandler)block;

@end
