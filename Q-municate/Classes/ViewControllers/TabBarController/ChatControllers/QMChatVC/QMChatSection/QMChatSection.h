//
//  QMChatSection.h


#import <Foundation/Foundation.h>

@class QMMessage;

@interface QMChatSection : NSObject

@property (nonatomic, assign, readonly) NSInteger identifier;
@property (nonatomic,strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSMutableArray *messages;

- (id)initWithDate:(NSDate *)date;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
- (void)addMessage:(QMMessage *)message;

@end
