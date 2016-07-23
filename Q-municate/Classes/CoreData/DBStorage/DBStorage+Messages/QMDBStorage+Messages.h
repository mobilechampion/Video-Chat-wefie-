//
//  QMDBStorage+Messages.h


#import "QMDBStorage.h"

@interface QMDBStorage (Messages)

- (void)cacheQBChatMessages:(NSArray *)messages withDialogId:(NSString *)dialogId finish:(QMDBFinishBlock)finish;
- (void)cachedQBChatMessagesWithDialogId:(NSString *)dialogId qbMessages:(QMDBCollectionBlock)qbMessages;

@end
