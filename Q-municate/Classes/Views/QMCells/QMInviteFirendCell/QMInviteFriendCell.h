//
//  QMInviteFriendsCell.h


#import "QMCheckBoxProtocol.h"
#import "QMTableViewCell.h"

@class QMInviteFriendCell;

@interface QMInviteFriendCell : QMTableViewCell

@property (assign, nonatomic, getter = isChecked) BOOL check;
@property (weak, nonatomic) id <QMCheckBoxProtocol> delegate;

@end
