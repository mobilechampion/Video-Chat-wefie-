//
//  QMDevice.m


#import "QMDevice.h"

@implementation QMDevice

+ (BOOL)isIphone6
{
    CGSize rectSize = [UIScreen mainScreen].bounds.size;
    return rectSize.width == 375.0f;
}

+ (BOOL)isIphone6Plus
{
    CGSize rectSize = [UIScreen mainScreen].bounds.size;
    return rectSize.width == 414.0f;
}

@end
