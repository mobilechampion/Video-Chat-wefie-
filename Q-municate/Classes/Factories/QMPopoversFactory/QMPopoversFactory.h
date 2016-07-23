//
//  QMPopoversFactory.h


#import <Foundation/Foundation.h>
@class QMChatViewController;

@interface QMPopoversFactory : NSObject

+ (UIViewController *)chatControllerWithDialogID:(NSString *)dialogID;

@end
