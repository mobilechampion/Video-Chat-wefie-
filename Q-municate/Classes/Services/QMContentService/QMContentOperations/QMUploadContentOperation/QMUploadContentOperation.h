//
//  QMUploadContentOperation.h


#import "QMContentOperation.h"

@interface QMUploadContentOperation : QMContentOperation

- (instancetype)initWithUploadFile:(NSData *)data fileName:(NSString *)fileName contentType:(NSString *)contentType isPublic:(BOOL)isPublic;

@end
