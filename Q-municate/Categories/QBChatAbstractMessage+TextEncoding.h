//
//  QBChatAbstractMessage+TextEncoding.h

//

#import <Quickblox/Quickblox.h>

@interface QBChatAbstractMessage (TextEncoding)

@property (strong, nonatomic, readonly) NSString *encodedText;

@end
