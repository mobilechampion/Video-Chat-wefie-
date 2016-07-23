//
//  QMDownloadContentOperation.m


#import "QMDownloadContentOperation.h"

@interface QMDownloadContentOperation()

@property (assign, nonatomic) NSUInteger blobID;

@end

@implementation QMDownloadContentOperation

- (instancetype)initWithBlobID:(NSUInteger )blobID {
    
    self = [super init];
    if (self) {
        self.blobID = blobID;
    }
    return self;
}

- (void)main {
    self.cancelableOperation = [QBContent TDownloadFileWithBlobID:self.blobID delegate:self];
}

@end
