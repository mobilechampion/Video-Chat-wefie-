//
//  QBUUser+CustomParameters.h

//

#import <Foundation/Foundation.h>

@interface QBUUser (CustomParameters)

@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) BOOL imported;

@end
