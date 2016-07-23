//
//  QMChatUtils.h


#import <Foundation/Foundation.h>

@interface QMChatUtils : NSObject

+ (NSString *)messageTextForNotification:(QBChatAbstractMessage *)notification;
+ (NSString *)messageTextForPushWithNotification:(QBChatMessage *)notification;
+ (NSString *)idsStringWithoutSpaces:(NSArray *)users;
+ (NSString *)messageForText:(NSString *)text participants:(NSArray *)participants;

@end
