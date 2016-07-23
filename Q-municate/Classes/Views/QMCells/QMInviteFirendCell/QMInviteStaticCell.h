//
//  QMInviteFriendsStaticCell.h


#import <UIKit/UIKit.h>
#import "QMCheckBoxProtocol.h"

@interface QMInviteStaticCell : UITableViewCell

@property (assign, nonatomic) NSUInteger badgeCount;
@property (assign, nonatomic, getter = isChecked) BOOL check;
@property (weak, nonatomic) id <QMCheckBoxProtocol> delegate;

@end
