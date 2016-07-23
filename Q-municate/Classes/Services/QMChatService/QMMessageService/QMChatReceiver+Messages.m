//
//  QMChatReceiver+Messages.m


#import "QMChatReceiver.h"

@implementation QMChatReceiver (Messages)

- (void)messageHistoryWasUpdatedWithTarget:(id)target block:(void (^)(BOOL))block
{
    [self subsribeWithTarget:target selector:@selector(messageHistoryWasUpdated) block:block];
}

- (void)messageHistoryWasUpdated
{
    [self executeBloksWithSelector:_cmd enumerateBloks:^(QMChatDidLogin block) {
        block(YES);
    }];
}

@end
