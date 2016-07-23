//
//  UIImage+Cropper.h

//

#import <UIKit/UIKit.h>

@interface UIImage (Cropper)

- (UIImage *)imageByScaleAndCrop:(CGSize)targetSize;
- (UIImage *)imageByCircularScaleAndCrop:(CGSize)targetSize;

@end
