//
//  PhotoMergeViewController.m
//  Wefie
//
//  Created by Superman on 11/20/14.
//  Copyright (c) 2014 Superman. All rights reserved.
//

#import "PhotoMergeViewController.h"
#import "MZCroppableView.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageMaskView.h"
#import "AlbumDetailViewController.h"
#import "GlobalPool.h"
#import "AAShareBubbles.h"
#import <Social/Social.h>
#import "SCLAlertView.h"
#import "DataManager.h"

#define kPhoneHeight [UIScreen mainScreen].bounds.size.height

#define CUSTOM_BUTTON_ID 100

@interface PhotoMergeViewController ()<CLImageEditorDelegate,AAShareBubblesDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic, strong) AAShareBubbles *shareBubbles;

@end

@implementation PhotoMergeViewController

@synthesize image1;
@synthesize image2;
@synthesize indexShare;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackground];

    [self.view addSubview:self.containerView];
    
    [self initial2View];
    [self resizeBtnClicked:nil];
    
    self.toolBar.frame = CGRectMake(0, kPhoneHeight-44, 320, 44);
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(btnShareClicked)];
    shareBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = shareBtn;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)btnShareClicked {
    if(self.shareBubbles) {
        [self.shareBubbles hide];
        self.shareBubbles = nil;
    }
    self.shareImage = [self convertViewToImage];
    self.shareBubbles = [[AAShareBubbles alloc] initWithPoint:self.view.center radius:120.0 inView:self.view];

    self.shareBubbles.delegate = self;
    self.shareBubbles.bubbleRadius = 35.0;
    self.shareBubbles.showFacebookBubble = YES;
    self.shareBubbles.showTwitterBubble = YES;
    self.shareBubbles.showTumblrBubble = YES;
    self.shareBubbles.showInstagramBubble = YES;
    self.shareBubbles.showMailBubble = YES;
    
    [self.shareBubbles addCustomButtonWithIcon:[UIImage imageNamed:@"libraryBubble"]
                          backgroundColor:[UIColor colorWithRed:0.0 green:164.0/255.0 blue:120.0/255.0 alpha:1.0]
                              andButtonId:CUSTOM_BUTTON_ID];
    [self.shareBubbles show];
}

-(UIImage *)convertViewToImage
{
    [imageResizableView1 hideEditingHandles];
    [imageResizableView2 hideEditingHandles];
    
    UIGraphicsBeginImageContext(self.containerView.bounds.size);
    
    [self.containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShot;
}

- (void)initial2View{
    photo1ImageView = [[ImageMaskView alloc] initWithFrame:CGRectMake(10, 10, 240, 240/image1.size.width*image1.size.height) image:image1];
    imageResizableView1 = [[SPUserResizableView alloc] initWithFrame:photo1ImageView.frame];
    imageResizableView1.contentView = photo1ImageView;
    imageResizableView1.delegate =self;
    [self.containerView addSubview:imageResizableView1];
    
    photo2ImageView = [[ImageMaskView alloc] initWithFrame:CGRectMake(40, 40,240, 240/image2.size.width*image2.size.height) image:image2];
    imageResizableView2 = [[SPUserResizableView alloc] initWithFrame:photo2ImageView.frame];
    imageResizableView2.contentView = photo2ImageView;
    imageResizableView2.delegate =self;
    [self.containerView addSubview:imageResizableView2];
    
    currentlyEditingView = imageResizableView2;
    lastEditedView = imageResizableView2;

    [self.view bringSubviewToFront:self.toolBar];
    
}

- (void)setupBackground {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIImageView *backGroundImageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backGroundImageview setContentMode:UIViewContentModeScaleAspectFill];
    [backGroundImageview setClipsToBounds:YES];
    backGroundImageview.image = [GlobalPool sharedInstance].backgroundImage;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.view.bounds;
    [backGroundImageview insertSubview:effectView atIndex:1];
    
    [self.view addSubview:backGroundImageview];
    [self.view sendSubviewToBack:backGroundImageview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)userResizableViewDidBeginEditing:(SPUserResizableView *)userResizableView {
    [currentlyEditingView hideEditingHandles];
    currentlyEditingView = userResizableView;
}

- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
    lastEditedView = userResizableView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([currentlyEditingView hitTest:[touch locationInView:currentlyEditingView] withEvent:nil]) {
        return NO;
    }
    return YES;
}

- (void)hideEditingHandles {
    // We only want the gesture recognizer to end the editing session on the last
    // edited view. We wouldn't want to dismiss an editing session in progress.
    [lastEditedView hideEditingHandles];
}

- (IBAction)resizeBtnClicked:(id)sender {
    [currentlyEditingView showEditingHandles];
    [imageResizableView1 setMoveEnable:YES];
    [imageResizableView2 setMoveEnable:YES];
    self.eraseBtn.enabled = YES;
    self.resizeBtn.enabled = NO;
}

- (IBAction)mergeBtnClicked:(id)sender {
    [currentlyEditingView hideEditingHandles];
    [imageResizableView2 setMoveEnable:NO];
    [imageResizableView1 setMoveEnable:NO];
    self.eraseBtn.enabled = NO;
    self.resizeBtn.enabled = YES;
}

- (IBAction)completeBtnClicked:(id)sender {
    self.shareImage = [self convertViewToImage];
    [_delegate setMergeImage:self.shareImage]; // mine
    
    DataManager *dm = [DataManager SharedDataManager];
    NSString *imageName = [NSString stringWithFormat:@"photo%d", indexShare];
    [dm saveImageToDevice:self.shareImage withName:imageName extension:@"png"];
    indexShare = indexShare + 1;
    [dm setDefaultUserObject:[NSNumber numberWithInteger:indexShare] forKey:@"photoCount"];
    [dm update];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)detailBtnClicked:(id)sender {
    UIImage *imageSelected;
    if(![imageResizableView1 isShowingEditingHandles]) {
        imageSelected = imageResizableView1.contentView.image;
    } else if(![imageResizableView2 isShowingEditingHandles]) {
        imageSelected = imageResizableView2.contentView.image;
    }

    AlbumDetailViewController *detailView = [[AlbumDetailViewController alloc] initWithImage:imageSelected];
    detailView.delegate = self;
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)frontLayerBtnClicked:(id)sender {
    [currentlyEditingView hideEditingHandles];
    [self.containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
}

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    if(![imageResizableView1 isShowingEditingHandles]) {
        photo1ImageView.image = image;
        [photo1ImageView initialize:photo1ImageView.frame image:image];
        imageResizableView1.contentView = photo1ImageView;
    } else if(![imageResizableView2 isShowingEditingHandles]) {
        photo2ImageView.image = image;
        [photo2ImageView initialize:photo2ImageView.frame image:image];
        imageResizableView2.contentView = photo2ImageView;
    }
    [editor.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark Share Kit Delegate 
-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(int)bubbleType
{
    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
        {
            NSLog(@"Facebook");
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                if (composeViewController) {
                    [composeViewController addImage:self.shareImage];
                    //[composeViewController addURL:[NSURL URLWithString:@"http://www.google.com"]];
                    NSString *initialTextString = @"Like this picture?";
                    [composeViewController setInitialText:initialTextString];
                    [composeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
                        if (result == SLComposeViewControllerResultDone) {
                            SCLAlertView *alert = [[SCLAlertView alloc] init];
                            alert.shouldDismissOnTapOutside = YES;
                            
                            [alert alertIsDismissed:^{
                                NSLog(@"SCLAlertView dismissed!");
                            }];
                            
                            [alert showSuccess:self title:@"Facebook Posting" subTitle:@"Successfully Posted" closeButtonTitle:nil duration:2.0f];

                        } else if (result == SLComposeViewControllerResultCancelled) {
                            NSLog(@"Post Cancelled");

                        } else {
                            NSLog(@"Post Failed");
                            SCLAlertView *alert = [[SCLAlertView alloc] init];
                            alert.shouldDismissOnTapOutside = YES;
                            
                            [alert alertIsDismissed:^{
                                NSLog(@"SCLAlertView dismissed!");
                            }];
                            
                            [alert showError:self title:@"Info" subTitle:@"Wefie Server Provider Problems" closeButtonTitle:nil duration:2.0f];
                        }
                    }];
                    [self presentViewController:composeViewController animated:YES completion:nil];
                }
            } else {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                alert.shouldDismissOnTapOutside = YES;
                
                [alert alertIsDismissed:^{
                    NSLog(@"SCLAlertView dismissed!");
                }];
                
                [alert showNotice:self title:@"Required Signin" subTitle:@"Facebook Account SignIn Required on Settings" closeButtonTitle:@"Close" duration:0.f];

            }
            break;
        }
        case AAShareBubbleTypeTwitter:
        {
            NSLog(@"Twitter");
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                if (composeViewController) {
                    [composeViewController addImage:self.shareImage];
                    //[composeViewController addURL:[NSURL URLWithString:@"http://www.google.com"]];
                    NSString *initialTextString = @"Like this picture?";
                    [composeViewController setInitialText:initialTextString];
                    [composeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
                        if (result == SLComposeViewControllerResultDone) {
                            SCLAlertView *alert = [[SCLAlertView alloc] init];
                            alert.shouldDismissOnTapOutside = YES;
                            
                            [alert alertIsDismissed:^{
                                NSLog(@"SCLAlertView dismissed!");
                            }];
                            
                            [alert showSuccess:self title:@"Twitter Posting" subTitle:@"Successfully Posted" closeButtonTitle:nil duration:2.0f];
                            
                        } else if (result == SLComposeViewControllerResultCancelled) {
                            NSLog(@"Post Cancelled");
                            
                        } else {
                            NSLog(@"Post Failed");
                            SCLAlertView *alert = [[SCLAlertView alloc] init];
                            alert.shouldDismissOnTapOutside = YES;
                            
                            [alert alertIsDismissed:^{
                                NSLog(@"SCLAlertView dismissed!");
                            }];
                            
                            [alert showError:self title:@"Info" subTitle:@"Wefie Server Provider Problems" closeButtonTitle:nil duration:2.0f];
                        }
                    }];
                    [self presentViewController:composeViewController animated:YES completion:nil];
                }
            } else {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                alert.shouldDismissOnTapOutside = YES;
                
                [alert alertIsDismissed:^{
                    NSLog(@"SCLAlertView dismissed!");
                }];
                
                [alert showNotice:self title:@"Required Signin" subTitle:@"Twitter Account SignIn Required on Settings" closeButtonTitle:@"Close" duration:0.f];
                
            }
            break;
        }
        case AAShareBubbleTypeTumblr:
        {
            NSLog(@"Tumblr");
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.shouldDismissOnTapOutside = YES;
            
            [alert alertIsDismissed:^{
                NSLog(@"SCLAlertView dismissed!");
            }];
            
            [alert showNotice:self title:@"Wefie Notice" subTitle:@"Tumblr Sharing is not activated" closeButtonTitle:@"Close" duration:0.f];

            break;
        }
        case AAShareBubbleTypeMail:
        {
            NSLog(@"Mail");
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            
            picker.mailComposeDelegate = self;
            
            [picker setSubject:@"Pic from Wefie"];
            
            NSData* imageData = UIImagePNGRepresentation(self.shareImage);
            
            [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"wefie"];
            
            NSString *emailBody = @"Like this picture?";
            [picker setMessageBody:emailBody isHTML:NO];
            
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        }
        case AAShareBubbleTypeInstagram:
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.shouldDismissOnTapOutside = YES;
            
            [alert alertIsDismissed:^{
                NSLog(@"SCLAlertView dismissed!");
            }];
            
            [alert showNotice:self title:@"Wefie Notice" subTitle:@"Instagram Sharing is not activated" closeButtonTitle:@"Close" duration:0.f];

            break;
        }
        case CUSTOM_BUTTON_ID:
        {
            UIImageWriteToSavedPhotosAlbum(self.shareImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            break;
        }
        default:
            break;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Unable to save the image
    if (error) {

        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.shouldDismissOnTapOutside = YES;
        
        [alert alertIsDismissed:^{
            NSLog(@"SCLAlertView dismissed!");
        }];
        
        [alert showError:self title:@"Wefie Save To Album" subTitle:@"Unable to save image to Photo Album" closeButtonTitle:nil duration:2.0f];

    }else {
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.shouldDismissOnTapOutside = YES;
        
        [alert alertIsDismissed:^{
            NSLog(@"SCLAlertView dismissed!");
        }];
        
        [alert showSuccess:self title:@"Wefie Save To Album" subTitle:@"Successfully Saved" closeButtonTitle:nil duration:2.0f];
    }
}

#pragma mark -
#pragma mark Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error  {
    
    switch (result)
    {
        case MFMailComposeResultCancelled: {
         
            break;
        }
        case MFMailComposeResultSaved: {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.shouldDismissOnTapOutside = YES;
            
            [alert alertIsDismissed:^{
                NSLog(@"SCLAlertView dismissed!");
            }];
            
            [alert showNotice:self title:@"Wefie Pic Email Send" subTitle:@"Saved to Draft!" closeButtonTitle:nil duration:2.0f];
            
            break;

            break;
        }
        case MFMailComposeResultSent: {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.shouldDismissOnTapOutside = YES;
            
            [alert alertIsDismissed:^{
                NSLog(@"SCLAlertView dismissed!");
            }];
            
            [alert showSuccess:self title:@"Wefie Pic Email Send" subTitle:@"Successfully sent!" closeButtonTitle:nil duration:2.0f];

            break;
        }
        case MFMailComposeResultFailed: {

            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.shouldDismissOnTapOutside = YES;
            
            [alert alertIsDismissed:^{
                NSLog(@"SCLAlertView dismissed!");
            }];
            
            [alert showError:self title:@"Wefie Pic Email Send" subTitle:@"Failed to Send!" closeButtonTitle:nil duration:2.0f];

            break;
        }
        default:
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.shouldDismissOnTapOutside = YES;
            
            [alert alertIsDismissed:^{
                NSLog(@"SCLAlertView dismissed!");
            }];
            
            [alert showError:self title:@"Wefie Pic Email Send" subTitle:@"Failed to Send" closeButtonTitle:nil duration:2.0f];

            break;
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];

}

@end
