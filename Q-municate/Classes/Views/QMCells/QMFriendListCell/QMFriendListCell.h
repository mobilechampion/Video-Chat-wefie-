//
//  QMFriendListCell.h


#import "QMTableViewCell.h"


@interface QMFriendListCell : QMTableViewCell

@property (strong, nonatomic) NSString *searchText;

@property (weak, nonatomic) id <QMUsersListDelegate>delegate;

@end
