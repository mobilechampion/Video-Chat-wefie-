//
//  QMCustomSegue.m


#import "QMCustomSegue.h"
#import "AppDelegate.h"

@implementation QMCustomSegue

- (void)perform {
    
    AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    window.rootViewController = self.destinationViewController;
}

@end
