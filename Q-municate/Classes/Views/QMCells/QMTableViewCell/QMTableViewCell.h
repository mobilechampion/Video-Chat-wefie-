//
//  QMTableViewCell.h


#import <UIKit/UIKit.h>
@class QMImageView;

@interface QMTableViewCell : UITableViewCell 

@property (strong, nonatomic) id userData;
@property (strong, nonatomic) QBContactListItem *contactlistItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet QMImageView *qmImageView;

- (void)setUserImageWithUrl:(NSURL *)userImageUrl;
- (void)setUserImage:(UIImage *)image withKey:(NSString *)key;

@end
