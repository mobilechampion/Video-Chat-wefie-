//
//  QMCornerButton.m


#import "QMCornerButton.h"

@implementation QMCornerButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
}

@end
