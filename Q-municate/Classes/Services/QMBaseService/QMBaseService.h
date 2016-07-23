//
//  QMBaseService.h


#import <Foundation/Foundation.h>
#import "QMServiceProtocol.h"

@interface QMBaseService : NSObject <QMServiceProtocol>

@property (assign, nonatomic, getter = isActive) BOOL active;

- (void)start;
- (void)stop;

@end
