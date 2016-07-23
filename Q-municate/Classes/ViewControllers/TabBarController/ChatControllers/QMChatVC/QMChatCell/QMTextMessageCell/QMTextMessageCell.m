//
//  QMTextMessageCell.m
//  Qmunicate
//
//  Created by Andrey Ivanov on 17.06.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMTextMessageCell.h"
#import "Parus.h"
#import "QMApi.h"

@interface QMTextMessageCell()

@property (strong, nonatomic) UILabel *textView;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) UIColor *textColor;

@end

@implementation QMTextMessageCell

- (void)createContainerSubviews {
    
    [super createContainerSubviews];
    
    self.textView = [[UILabel alloc] init];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.numberOfLines = 0;
    
    [self.containerView addSubview:self.textView];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.containerView addConstraints:@[PVLeftOf(self.textView).equalTo.leftOf(self.containerView).asConstraint,
                                         PVBottomOf(self.textView).equalTo.bottomOf(self.containerView).asConstraint,
                                         PVTopOf(self.textView).equalTo.topOf(self.containerView).asConstraint,
                                         PVRightOf(self.textView).equalTo.rightOf(self.containerView).asConstraint]];
}

- (void)setMessage:(QMMessage *)message user:(QBUUser *)user isMe:(BOOL)isMe {

    [super setMessage:message user:user isMe:isMe];
    
    self.textColor = message.textColor;
    self.font = UIFontFromQMMessageLayout(message.layout);
    self.textView.text = message.encodedText;
    
    self.balloonImage =  message.balloonImage;
    
    //[[self formatter] setTimeStyle:NSDateFormatterFullStyle];
    //NSDate *date = message.datetime;
   // NSString *strDate = [[self formatter] stringFromDate:message.datetime];
    
    self.timeLabel.text = [[self formatter] stringFromDate:message.datetime];
     NSLog(@"timelabel == %@",[[self formatter] stringFromDate:message.datetime]);
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
//    
//    [[self formatter] setTimeStyle:NSDateFormatterFullStyle];
////    [formatter setDateFormat:@"a hh:mm"];
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
//    [[self formatter] setLocale:locale];
//    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
//    NSTimeInterval gmtTimeInterval = [message.datetime timeIntervalSinceReferenceDate] - timeZoneOffset;
//    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
//    NSLog(@"timelabel == %@",[[[self formatter] stringFromDate:gmtDate] uppercaseStringWithLocale:locale]);
    
 
    self.timeLabel.textColor = (isMe) ? [UIColor colorWithRed:0.938 green:0.948 blue:0.898 alpha:1.000] : [UIColor grayColor];
}

- (void)setTextColor:(UIColor *)textColor {
    
    if (![_textColor isEqual:textColor] ) {
        _textColor = textColor;
        self.textView.textColor = textColor;
    }
}

- (void)setFont:(UIFont *)font {
    
    if (![_font isEqual:font]) {
        _font = font;
        self.textView.font = font;
    }
}

@end
