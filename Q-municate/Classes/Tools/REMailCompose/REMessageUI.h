//
//  REMailCompose.h


#import <MessageUI/MessageUI.h>

typedef void(^MFMailComposeResultBlock)(MFMailComposeResult result, NSError *error);
typedef void(^MessageComposeResultBlock)(MessageComposeResult result);

@class REMailComposeViewController;

@interface REMailComposeViewController : MFMailComposeViewController

+ (void)present:(void(^)(REMailComposeViewController *mailVC))mailComposeViewController
         finish:(MFMailComposeResultBlock)finish;

@end

@interface REMessageComposeViewController : MFMessageComposeViewController

+ (void)present:(void(^)(REMessageComposeViewController *massageVC))messageComposeViewController
         finish:(void(^)(MessageComposeResult result))finish;

@end



