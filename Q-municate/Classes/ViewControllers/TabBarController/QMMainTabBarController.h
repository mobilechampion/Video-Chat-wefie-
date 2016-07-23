//
//  QMMainTabBarController.h


#import <UIKit/UIKit.h>

@protocol QMFriendsTabDelegate <NSObject>
@optional
- (void)friendsListTabWasTapped:(UITabBarItem *)tab;
@end


@interface QMMainTabBarController : UITabBarController <QMTabBarChatDelegate>

@property (nonatomic, weak) id <QMTabBarChatDelegate> chatDelegate;
@property (nonatomic, weak) id <QMFriendsTabDelegate> tabDelegate;

@end
