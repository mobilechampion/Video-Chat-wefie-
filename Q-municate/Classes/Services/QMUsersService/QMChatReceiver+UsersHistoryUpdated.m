//
//  QMChatReceiver+UsersHistoryUpdated.m


#import "QMChatReceiver.h"

@implementation QMChatReceiver (UsersHistoryUpdated)

- (void)postUsersHistoryUpdated {
    
    [self executeBloksWithSelector:_cmd enumerateBloks:^(QMUsersHistoryUpdated block) {
        block();
    }];
}

- (void)usersHistoryUpdatedWithTarget:(id)target block:(QMUsersHistoryUpdated)block {
    [self subsribeWithTarget:target selector:@selector(postUsersHistoryUpdated) block:block];
}

- (void)contactRequestUsersListChanged
{
#warning Make sure that this case neeeded
    [self executeBloksWithSelector:_cmd enumerateBloks:^(QMUsersHistoryUpdated block) {
        block();
    }];
}

- (void)contactRequestUsersListChangedWithTarget:(id)target block:(QMUsersHistoryUpdated)block {
    [self subsribeWithTarget:target selector:@selector(contactRequestUsersListChanged) block:block];
}

@end
