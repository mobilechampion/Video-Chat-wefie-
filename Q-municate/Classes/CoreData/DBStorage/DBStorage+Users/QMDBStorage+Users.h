//
//  QMDBStorage+Users.h


#import "QMDBStorage.h"

@interface QMDBStorage (Users)

- (void)cacheUsers:(NSArray *)users finish:(QMDBFinishBlock)finish;
- (void)cachedQbUsers:(QMDBCollectionBlock)qbUsers;

@end
