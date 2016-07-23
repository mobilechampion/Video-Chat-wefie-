//
//  QMDBStorage+Dialogs.h


#import "QMDBStorage.h"

@interface QMDBStorage (Dialogs)

- (void)cachedQBChatDialogs:(QMDBCollectionBlock)qbDialogs;
- (void)cacheQBDialogs:(NSArray *)dialogs finish:(QMDBFinishBlock)finish;

@end
