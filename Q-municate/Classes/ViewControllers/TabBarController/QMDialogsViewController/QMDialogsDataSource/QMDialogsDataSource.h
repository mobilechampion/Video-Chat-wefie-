//
//  QMDialogsDataSource.h


#import <Foundation/Foundation.h>

@protocol QMDialogsDataSourceDelegate <NSObject>

- (void)didChangeUnreadDialogCount:(NSUInteger)unreadDialogsCount;

@end

@interface QMDialogsDataSource : NSObject

@property(weak, nonatomic) id <QMDialogsDataSourceDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (QBChatDialog *)dialogAtIndexPath:(NSIndexPath *)indexPath;
- (void)fetchUnreadDialogsCount;

@end
