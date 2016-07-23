//
//  QMGroupDetailsDataSource.h


#import <Foundation/Foundation.h>

@interface QMGroupDetailsDataSource : NSObject <UITableViewDataSource>

- (id)initWithTableView:(UITableView *)tableView;
- (void)reloadDataWithChatDialog:(QBChatDialog *)chatDialog;

@end
