//
//  QMServiceProtocol.h


@protocol QMServiceProtocol <NSObject>

@property (assign, nonatomic, getter = isActive) BOOL active;

- (void)start;
- (void)stop;

@end
