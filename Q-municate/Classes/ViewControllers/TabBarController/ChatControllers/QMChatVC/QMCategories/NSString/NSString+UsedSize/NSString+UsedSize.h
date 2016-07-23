//
//  NSString+UsedSize.h


#import <Foundation/Foundation.h>

@interface NSString (UsedSize)

- (CGSize)usedSizeForWidth:(CGFloat)width font:(UIFont *)font withAttributes:(NSDictionary *)attributes;

@end
