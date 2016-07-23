//
//  NSString+HasText.m


#import "NSString+HasText.h"

@implementation NSString (HasText)

- (NSString *)stringByTrimingWhitespace {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)hasText {
    
    NSString *trimingStr = [self stringByTrimingWhitespace];
    BOOL hasText = trimingStr.length > 0;
    
    return hasText;
}

@end
