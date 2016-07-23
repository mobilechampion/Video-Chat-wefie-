//
//  QMUsersUtils.h


#import <Foundation/Foundation.h>

@interface QMUsersUtils : NSObject

+ (NSArray *)sortUsersByFullname:(NSArray *)users;
+ (NSMutableArray *)filteredUsers:(NSArray *)users withFlterArray:(NSArray *)usersToFilter;
+ (NSURL *)userAvatarURL:(QBUUser *)user;

@end
