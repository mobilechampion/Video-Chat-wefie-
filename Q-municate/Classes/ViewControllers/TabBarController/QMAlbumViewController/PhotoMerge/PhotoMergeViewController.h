//
//  PhotoMergeViewController.h
//  Wefie
//
//  Created by Superman on 11/20/14.
//  Copyright (c) 2014 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserResizableView.h"
#import "ImageMaskView.h"
#import <MessageUI/MessageUI.h>

@protocol PhotoMergeDelegate <NSObject>

- (void)setMergeImage:(UIImage *)shareImage;

@end

@interface PhotoMergeViewController : UIViewController<SPUserResizableViewDelegate>
{
    SPUserResizableView *currentlyEditingView;
    SPUserResizableView *lastEditedView;

    SPUserResizableView *imageResizableView1;
    SPUserResizableView *imageResizableView2;
    
    ImageMaskView *photo1ImageView;
    ImageMaskView *photo2ImageView;
}

@property (nonatomic,strong) id<PhotoMergeDelegate> delegate;

@property (nonatomic,strong) UIImage *shareImage;
@property (nonatomic,strong) UIImage *image1;
@property (nonatomic,strong) UIImage *image2;
@property int indexShare;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *detailBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *eraseBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resizeBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *completeBtn;

@end
