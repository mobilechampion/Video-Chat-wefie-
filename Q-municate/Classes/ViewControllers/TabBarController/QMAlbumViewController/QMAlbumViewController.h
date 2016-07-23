//
//  QMAlbumViewController.h
//  Wefie


#import <UIKit/UIKit.h>

@interface MHGallerySectionItem : NSObject

@property (nonatomic, strong) NSString *sectionName;
@property (nonatomic, strong) NSArray *galleryItems;

- (id)initWithSectionName:(NSString*)sectionName
                    items:(NSArray*)galleryItems;

@end

@interface QMAlbumViewController : UIViewController

@end
