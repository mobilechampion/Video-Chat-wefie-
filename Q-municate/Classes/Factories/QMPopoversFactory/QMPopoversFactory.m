//
//  QMPopoversFactory.m


#import "QMPopoversFactory.h"
#import "QMChatViewController.h"
#import "QMApi.h"

@implementation QMPopoversFactory


+ (UIViewController *)chatControllerWithDialogID:(NSString *)dialogID
{
    QBChatDialog *dialog = [[QMApi instance] chatDialogWithID:dialogID];
    
    QMChatViewController *chatVC = (QMChatViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QMChatViewController"];
    chatVC.dialog = dialog;
    return chatVC;
}

@end
