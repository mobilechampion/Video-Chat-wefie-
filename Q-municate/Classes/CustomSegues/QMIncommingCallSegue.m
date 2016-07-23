//
//  QMIncommingCallSegue.m


#import "QMIncommingCallSegue.h"
#import "QMIncomingCallController.h"
#import "QMVideoCallController.h"

@implementation QMIncommingCallSegue

- (void)perform
{
    QMIncomingCallController *incommingCallController = (QMIncomingCallController *)self.sourceViewController;
    QMBaseCallsController *callsController = (QMVideoCallController *)self.destinationViewController;
    [callsController setOpponent:incommingCallController.opponent];
    callsController.isOpponentCaller = YES;
    
    incommingCallController.navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
//    [incommingCallController.navigationController transitionFromViewController:incommingCallController toViewController:callsController duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
    [incommingCallController.navigationController setViewControllers:@[callsController] animated:YES];
}

@end
