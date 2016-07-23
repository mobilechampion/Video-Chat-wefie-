//
//  QMChatNotificationCell.h


#import <UIKit/UIKit.h>

@class QMMessage;

static NSString *const kChatNotificationCellID = @"QMContactNotificationCell";

@interface QMChatNotificationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) QMMessage *notification;

@end
