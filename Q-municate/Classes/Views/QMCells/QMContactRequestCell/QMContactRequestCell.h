//
//  QMContactRequestCell.h


#import <Foundation/Foundation.h>

#import "QMChatCell.h"

@interface QMContactRequestCell : UITableViewCell

@property (nonatomic, weak) id <QMUsersListDelegate> delegate;

@property (nonatomic, strong) QMMessage *notification;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

@end
