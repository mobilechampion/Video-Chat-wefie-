//
//  IAButton.h


#import <Foundation/Foundation.h>

@interface IAButton : UIButton

@property (assign, nonatomic) BOOL isPushed;
@property (strong, nonatomic) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *selectedColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *highlightedColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *hightlightedTextColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *textColor  UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIFont *mainLabelFont UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIFont *subLabelFont UI_APPEARANCE_SELECTOR;

@end
