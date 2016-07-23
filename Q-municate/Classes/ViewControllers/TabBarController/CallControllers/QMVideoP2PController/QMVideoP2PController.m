//
//  QMVideoP2PController.m


#import "QMVideoP2PController.h"
#import "QMAVCallManager.h"
#import <sys/utsname.h>
#import <ImageIO/ImageIO.h>

// Andrey A
@interface QMVideoP2PController()
{
    BOOL isMineScreen;
    
}

@end
// Andrey A
@implementation QMVideoP2PController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if( [QMApi instance].avCallManager.localVideoTrack ){
        self.localVideoTrack = [QMApi instance].avCallManager.localVideoTrack;
    }
    if( [QMApi instance].avCallManager.remoteVideoTrack ){
        self.opponentVideoTrack = [QMApi instance].avCallManager.remoteVideoTrack;
    }
    
    [self.contentView startTimerIfNeeded];
    [self reloadVideoViews];
    
    if([machineName() isEqualToString:@"iPhone3,1"] ||
       [machineName() isEqualToString:@"iPhone3,2"] ||
       [machineName() isEqualToString:@"iPhone3,3"] ||
       [machineName() isEqualToString:@"iPhone4,1"]) {
        
        self.opponentsVideoViewBottom.constant = -80.0f;
    }
    [[[QMApi instance] avCallManager] setAudioSessionDefaultToSpeakerIfNeeded];
    
    isMineScreen = NO;
    self.rotateBtn.titleLabel.text = @"Friend";
    // Andrey
}

- (void)audioSessionRouteChanged:(NSNotification *)notification{
    [[[QMApi instance] avCallManager] setAudioSessionDefaultToSpeakerIfNeeded];
}

- (void)stopCallTapped:(id)sender {
    [self hideViewsBeforeDealloc];
    [super stopCallTapped:sender];
}

- (void)reloadVideoViews {
    [self.opponentsView setVideoTrack:self.opponentVideoTrack];
    [self.myView setVideoTrack:self.localVideoTrack];
}

- (void)hideViewsBeforeDealloc{
    [self.myView setVideoTrack:nil];
    [self.opponentsView setVideoTrack:nil];
    [self.myView setHidden:YES];
    [self.opponentsView setHidden:YES];
}

// to check for 4/4s screen
NSString* machineName() {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (void)videoTapped:(id)sender{
    [super videoTapped:sender];
    if( [self.session videoEnabled] ){
        [self allowSendingLocalVideoTrack];
        [self.btnSwitchCamera setUserInteractionEnabled:YES];
    }
    else{
        [self denySendingLocalVideoTrack];
        [self.btnSwitchCamera setUserInteractionEnabled:NO];
    }
    
    
}

- (void)allowSendingLocalVideoTrack {
    // it is a view with cam_off image that we need to display when cam is off
    [self.camOffView setHidden:YES];
    [self reloadVideoViews];
}

- (void)denySendingLocalVideoTrack {
    [self.session setVideoEnabled:NO];
    [self.myView setVideoTrack:nil];
    // it is a view with cam_off image that we need to display when cam is off
    [self.camOffView setHidden:NO];
}

#pragma mark QBRTCSession delegate -

- (void)session:(QBRTCSession *)session disconnectedFromUser:(NSNumber *)userID {
    [super session:session disconnectTimeoutForUser:userID];
    [self startActivityIndicator];
}

- (void)session:(QBRTCSession *)session didReceiveLocalVideoTrack:(QBRTCVideoTrack *)videoTrack {
    [super session:session didReceiveLocalVideoTrack:videoTrack];
    if( self.disableSendingLocalVideoTrack ){
        [self denySendingLocalVideoTrack];
        self.disableSendingLocalVideoTrack = NO;
    }
    
    self.localVideoTrack = videoTrack;
    [self reloadVideoViews];
}

- (void)session:(QBRTCSession *)session didReceiveRemoteVideoTrack:(QBRTCVideoTrack *)videoTrack fromUser:(NSNumber *)userID {
    
    [super session:session didReceiveRemoteVideoTrack:videoTrack fromUser:userID];
    self.opponentVideoTrack = videoTrack;
    
    [self reloadVideoViews];
}

- (void)session:(QBRTCSession *)session connectedToUser:(NSNumber *)userID {
    [super session:session connectedToUser:userID];
    [self stopActivityIndicator];
}

- (void)session:(QBRTCSession *)session hungUpByUser:(NSNumber *)userID {
    [self hideViewsBeforeDealloc];
    [super session:session hungUpByUser:userID];
}

// Andrey A

-(void)saveImage:(UIImage*) image{
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Image couldn't be saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else {
        
    }
}

// Andrey A

- (IBAction)takePhotoAndSave:(id)sender {
    if(isMineScreen){
        // take a photo of Mine
        NSLog(@"%@", @"take a photo of Mine!!!!");
        
        UIGraphicsBeginImageContextWithOptions(self.myView.bounds.size, YES, 0);
        [self.myView drawViewHierarchyInRect:self.myView.bounds afterScreenUpdates:YES];
        UIImage *imageMine = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self saveImage:imageMine];
        
        
        
        UIAlertView *alertViewMine = [[UIAlertView alloc] initWithTitle:@"Photo" message:@"Your photo is taken." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertViewMine show];
        
       // isMineScreen = NO;
    }else{
        
        // take a photo of other user
        NSLog(@"%@", @"take a photo of other User!!!!");
        
        UIGraphicsBeginImageContextWithOptions(self.opponentsView.bounds.size, YES, 0);
        [self.opponentsView drawViewHierarchyInRect:self.opponentsView.bounds afterScreenUpdates:YES];
        UIImage *imageOther = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self saveImage:imageOther];
        
        UIAlertView *alertViewOther = [[UIAlertView alloc] initWithTitle:@"Photo" message:@"Friend's photo is taken." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertViewOther show];
        
        //isMineScreen = YES;
        
    }

}

- (IBAction)changeTakenPicture:(id)sender {
    
    if(isMineScreen){
    
        [self.rotateBtn setTitle:@"Friend" forState:UIControlStateNormal] ;
        isMineScreen = NO;
    }else{
        [self.rotateBtn setTitle:@"Me" forState:UIControlStateNormal] ;
        isMineScreen = YES;
    }
    
}
@end
