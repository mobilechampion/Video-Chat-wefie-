//
//  QMChatReceiver+DialogsHistoryUpdated.m


#import "QMChatReceiver.h"

@implementation QMChatReceiver (DialogsHistoryUpdated)

- (void)postDialogsHistoryUpdated {
    
    [self executeBloksWithSelector:_cmd enumerateBloks:^(QMDialogsHistoryUpdated block) {
        block();
    }];
    
}

- (void)dialogsHisotryUpdatedWithTarget:(id)target block:(QMDialogsHistoryUpdated)block {
    [self subsribeWithTarget:target selector:@selector(postDialogsHistoryUpdated) block:block];
}

@end
