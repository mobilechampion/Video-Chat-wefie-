//
//  QMInviteFriendsDataSource.h



@protocol QMCheckBoxStateDelegate <NSObject>
@optional
- (void)checkListDidChangeCount:(NSInteger)checkedCount;
@end



@interface QMInviteFriendsDataSource : NSObject

@property (weak, nonatomic) id <QMCheckBoxStateDelegate> checkBoxDelegate;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)emailsToInvite;
- (void)clearABFriendsToInvite;

@end
