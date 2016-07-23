//
//  QMContentOperation.h


#import <Foundation/Foundation.h>


typedef void(^QMTaskResultBlock)(id taskResult);

@interface QMContentOperation : NSOperation <QBActionStatusDelegate>

@property (copy, nonatomic) QMContentProgressBlock progressHandler;
@property (copy, nonatomic) id completionHandler;

@property (strong, nonatomic) NSObject<Cancelable>*cancelableOperation;

@end
