//
//  QMFriendsListDataSource.h


static NSString *const kQMFriendsListCellIdentifier = @"QMFriendListCell";
static NSString *const kQMDontHaveAnyFriendsCellIdentifier = @"QMDontHaveAnyFriendsCell";

@protocol QMFriendsListDataSourceDelegate <NSObject>

- (void)didChangeContactRequestsCount:(NSUInteger)contactRequestsCount;

@end

@interface QMFriendsListDataSource : NSObject <UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate, QMUsersListDelegate>

@property (nonatomic, assign) BOOL viewIsShowed;
@property (weak, nonatomic) id <QMFriendsListDataSourceDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView searchDisplayController:(UISearchDisplayController *)searchDisplayController;
- (NSArray *)usersAtSections:(NSInteger)section;
- (QBUUser *)userAtIndexPath:(NSIndexPath *)indexPath;

@end
