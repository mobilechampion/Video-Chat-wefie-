 //
//  QMFriendListController.m


#import "QMFriendListViewController.h"
#import "QMFriendsDetailsController.h"
#import "QMMainTabBarController.h"
#import "QMFriendListCell.h"
#import "QMFriendsListDataSource.h"
#import "QMApi.h"
#import "QMInviteViewController.h"
#import "AppDelegate.h"

@interface QMFriendListViewController ()

<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, QMFriendsListDataSourceDelegate, QMFriendsTabDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) QMFriendsListDataSource *dataSource;

@end



@implementation QMFriendListViewController{

    NSUInteger userNumber;
}

- (void)dealloc {
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

#define kQMSHOW_SEARCH 0

- (void)viewDidLoad {
    [super viewDidLoad];
    ((QMMainTabBarController *)self.tabBarController).tabDelegate = self;
    
    
    userNumber = 0;
    [self retrieveAllUsersFromPage:1];
    
#if kQMSHOW_SEARCH
    [self.tableView setContentOffset:CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height) animated:NO];
#endif
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dataSource = [[QMFriendsListDataSource alloc] initWithTableView:self.tableView searchDisplayController:self.searchDisplayController];
    self.dataSource.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.dataSource.viewIsShowed = YES;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.dataSource.viewIsShowed = NO;
    [super viewWillDisappear:animated];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kQMDontHaveAnyFriendsCellIdentifier) {
        return;
    }
    
    QBUUser *selectedUser = [self.dataSource userAtIndexPath:indexPath];
    QBContactListItem *item = [[QMApi instance] contactItemWithUserID:selectedUser.ID];

    if (item) {
        [self performSegueWithIdentifier:kDetailsSegueIdentifier sender:nil];
    }
    else
    {
        //@@@
        NSString *messagesTitle;
        NSString *email;
        NSString *briefInfo;
        NSString *phone;
        NSString *messages;
        
        messages = @"";
        messagesTitle = selectedUser.fullName;
        email = selectedUser.email;
        phone = selectedUser.phone;
        if(phone == nil){
        
            phone = @"";
        }
        briefInfo = selectedUser.status;
        
        if(briefInfo == nil){
        
            briefInfo = @"";
        }
        
        messages = [messages stringByAppendingString:@"Email:"];
        messages = [messages stringByAppendingString:email];
        messages = [messages stringByAppendingString:@"\n"];
        messages = [messages stringByAppendingString:@"WefieNumber:"];
        messages = [messages stringByAppendingString:phone];
        messages = [messages stringByAppendingString:@"\n"];
        messages = [messages stringByAppendingString:@"Brief Info:"];
        messages = [messages stringByAppendingString:briefInfo];

       UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:messagesTitle message:messages delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        NSArray *subViewArray = myAlert.subviews;
        
        for(NSUInteger x = 0; x < [subViewArray count]; x++){
            
            //If the current subview is a UILabel...
            if([[[subViewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
                UILabel *label = [subViewArray objectAtIndex:x];
                label.textAlignment = NSTextAlignmentLeft;
            }
        }
        
        [myAlert show];
        //@@@
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    return [self.dataSource searchDisplayController:controller shouldReloadTableForSearchString:searchString];
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self.dataSource searchDisplayControllerWillBeginSearch:controller];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self.dataSource searchDisplayControllerWillEndSearch:controller];
}


#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kDetailsSegueIdentifier]) {
        
        NSIndexPath *indexPath = nil;
        if (self.searchDisplayController.isActive) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
        }
        QMFriendsDetailsController *vc = segue.destinationViewController;
        vc.selectedUser = [self.dataSource userAtIndexPath:indexPath];
    }
}


#pragma mark - QMFriendsListDataSourceDelegate

- (void)didChangeContactRequestsCount:(NSUInteger)contactRequestsCount
{
    NSUInteger idx = [self.tabBarController.viewControllers indexOfObject:self.navigationController];
    if (idx != NSNotFound) {
        UITabBarItem *item = self.tabBarController.tabBar.items[idx];
        item.badgeValue = contactRequestsCount > 0 ? [NSString stringWithFormat:@"%d", contactRequestsCount] : nil;
    }
}


#pragma mark - QMFriendsTabDelegate

- (void)friendsListTabWasTapped:(UITabBarItem *)tab
{
    [self.tableView reloadData];
}


- (IBAction)iviteFriendsPressed:(id)sender {
    
    NSLog(@" test ==== ");
    
    QMInviteViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QMInviteViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

// @@@
- (void)retrieveAllUsersFromPage:(int)page{
    
    
    [QBRequest usersForPage:[QBGeneralResponsePage responsePageWithCurrentPage:page perPage:100] successBlock:^(QBResponse *response, QBGeneralResponsePage *pageInformation, NSArray *users) {
        
        [AppDelegate sharedInstance].users  = users;
        
        userNumber += users.count;
        if (pageInformation.totalEntries > userNumber) {
            [self retrieveAllUsersFromPage:pageInformation.currentPage + 1];
        }
    } errorBlock:^(QBResponse *response) {
        // Handle error
    }];
}
// @@@

@end
