//
//  QMAlbumViewController.m
//  Wefie


#import "QMAlbumViewController.h"
#import "AlbumDetailViewController.h"
#import "CLImageEditor.h"
#import "DiceTableViewCell.h"
#import "TWPhotoPickerController.h"
#import "PhotoMergeViewController.h"
#import "DataManager.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "MHGallery.h"

@implementation MHGallerySectionItem

- (id)initWithSectionName:(NSString*)sectionName
                    items:(NSArray*)galleryItems{
    self = [super init];
    if (!self)
        return nil;
    self.sectionName = sectionName;
    self.galleryItems = galleryItems;
    return self;
}

@end

@interface QMAlbumViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MHGalleryDelegate, PhotoMergeDelegate, CLImageEditorDelegate, DataManagerDelegate>
{
    UITableView *galleryTableView;
}

@property (assign, nonatomic) CGPoint lastContentOffset;
@property (nonatomic, strong) NSMutableArray *mergeImages;

@property (nonatomic, weak)   UIImage *resultImage;
@property (nonatomic, weak)   UIImage *editImage;

@property                     int tableCellCount;
@property (nonatomic,strong)  NSMutableArray *allData;

@property(nonatomic,strong)   MHTransitionDismissMHGallery *interactive;

@end

@implementation QMAlbumViewController

@synthesize resultImage;
@synthesize editImage;
@synthesize mergeImages;
@synthesize tableCellCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackground];
    
    mergeImages = [[NSMutableArray alloc] init];
    
    galleryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  -64)];
    galleryTableView.backgroundColor = [UIColor clearColor];
    
    [galleryTableView registerNib:[UINib nibWithNibName:@"DiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiceTableViewCell"];
    
    galleryTableView.delegate = self;
    galleryTableView.dataSource = self;
    
    [self.view addSubview:galleryTableView];

/***********************************   DataManager  *******************************/
    DataManager *dm = [DataManager SharedDataManager];
    if([[dm defaultUserObjectForKey:@"photoCount"] intValue]) {
        tableCellCount = [[dm defaultUserObjectForKey:@"photoCount"] intValue];
        for (int i = 0; i < tableCellCount; i++) {
            NSString *imageName = [NSString stringWithFormat:@"photo%d.png", i];
            UIImage *image = [dm loadImageNamed:imageName];
            [mergeImages addObject:image];
        }
    } else {
        tableCellCount =0;
    }
/************************************************************************************/
/*******************************   Photo Gallary   ***********************************/
    self.allData = [NSMutableArray new];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    for (int i = 0; i < tableCellCount; i++) {
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
            NSMutableArray *items = [NSMutableArray new];
            
            for (int j = 0; j < tableCellCount; j++) {
                MHGalleryItem *item = [[MHGalleryItem alloc] initWithImage:mergeImages[j]];
                [items addObject:item];
            }
            
            if(group){
                MHGallerySectionItem *section = [[MHGallerySectionItem alloc]initWithSectionName:[group valueForProperty:ALAssetsGroupPropertyName]
                                                                                           items:items];
                [self.allData addObject:section];
            }
            if (!group) {
                [galleryTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            
        } failureBlock: ^(NSError *error) {
            
        }];

    }
/************************************************************************************/
   // [galleryTableView reloadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupBackground {
    
    self.title = @"Album";

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImageView *backGroundImageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [backGroundImageview setContentMode:UIViewContentModeScaleAspectFill];
    [backGroundImageview setClipsToBounds:YES];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.view.bounds;
    [backGroundImageview insertSubview:effectView atIndex:1];
    
    [self.view addSubview:backGroundImageview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark DataManagerDelegate
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat heightForRowAtIndexPath = 150.0f;
    
    return heightForRowAtIndexPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return mergeImages.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiceTableViewCell" forIndexPath:indexPath];
    
    if (mergeImages.count != 0) {
        if (mergeImages.count > indexPath.row) {
            cell.mergeImage.image = mergeImages[indexPath.row];
        }
        else{
            cell.mergeImage.image = nil;
            cell.mergeImageOne.image = nil;
            cell.mergeImageTwo.image = nil;
        }
    }
    else{
        cell.mergeImage.image = nil;
        cell.mergeImageOne.image = nil;
        cell.mergeImageTwo.image = nil;
    }
    
    if (cell.mergeImage.image != nil) {
        cell.mergeImage.hidden = NO;
        cell.mergeImageOne.hidden = YES;
        cell.mergeImageTwo.hidden = YES;
        cell.importImageBtn.hidden = YES;
        cell.importImageBtn.tag = indexPath.row;
        [cell.importImageBtn addTarget:self action:@selector(btnImportImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        cell.mergeImage.hidden = YES;
        cell.importImageBtn.hidden = NO;
        cell.importImageBtn.tag = indexPath.row;
        [cell.importImageBtn addTarget:self action:@selector(btnImportImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

/**************************************    PhotoMergeDelegate  **************************************/
- (void)setMergeImage:(UIImage *)shareImage
{
    resultImage = shareImage;
    [mergeImages addObject:resultImage];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    int nMergeImageNum = mergeImages.count;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allAssets]];
        NSMutableArray *items = [NSMutableArray new];
        
        for (int j = 0; j < nMergeImageNum; j++) {
            MHGalleryItem *item = [[MHGalleryItem alloc] initWithImage:mergeImages[j]];
            [items addObject:item];
        }
        
        if(group){
            MHGallerySectionItem *section = [[MHGallerySectionItem alloc]initWithSectionName:[group valueForProperty:ALAssetsGroupPropertyName]
                                                                                       items:items];
            [self.allData addObject:section];
        }
        if (!group) {
            [galleryTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        
    } failureBlock: ^(NSError *error) {
        
    }];

    [galleryTableView reloadData];
}

/**************************************    CLImageEditorDelegate  ************************************/
- (void)imageEditor:(CLImageEditor*)editor didFinishEdittingWithImage:(UIImage*)image
{

}

/*************************************   Button Action  ***********************************************/
- (void)btnImportImageClicked:(UIButton *)sender
{
    DiceTableViewCell *cell = (DiceTableViewCell*)[[sender superview] superview];
    
    TWPhotoPickerController *twPhotoPicker = [[TWPhotoPickerController alloc] init];
    twPhotoPicker.cropBlock = ^(UIImage *image) {
        //do something
        if (cell.mergeImageTwo.image == nil) {
            cell.mergeImageTwo.image = image;
            cell.mergeImageTwo.hidden = NO;
        }
        else{
            cell.mergeImageOne.image = image;
            cell.mergeImageOne.hidden = NO;
        }
            
        if (cell.mergeImageOne.image != nil && cell.mergeImageTwo.image != nil) {
            cell.importImageBtn.hidden = YES;
            PhotoMergeViewController *photoMergeView = [[PhotoMergeViewController alloc] init];
            photoMergeView.image1 = cell.mergeImageOne.image;
            photoMergeView.image2 = cell.mergeImageTwo.image;
            cell.importImageBtn.hidden = YES;
            photoMergeView.delegate = self;
            photoMergeView.indexShare = sender.tag;
            [self.navigationController pushViewController:photoMergeView animated:YES];
        }
    };
    [self presentViewController:twPhotoPicker animated:YES completion:NULL];
}

/*************************************  MHGalleryDelegate  ********************************/
- (void)setEditImage:(UIImage *)galleryImage editShowIndex:(NSInteger)index
{
    editImage = galleryImage;
    [mergeImages replaceObjectAtIndex:index withObject:editImage];
    
    DataManager *dm = [DataManager SharedDataManager];
    NSString *imageName = [NSString stringWithFormat:@"photo%d.png", index];
    
    if ([dm doesImageExist:imageName]) {
        [dm removeImageFromImageCacheNamed:imageName];
        [dm setDefaultUserObject:[NSNumber numberWithInteger:[[dm defaultUserObjectForKey:@"photoCount"] intValue] - 1] forKey:@"photoCount"];
        [dm update];
        NSString *updateImageName = [NSString stringWithFormat:@"photo%d", index];
        [dm saveImageToDevice:galleryImage withName:updateImageName extension:@"png"];
        [dm setDefaultUserObject:[NSNumber numberWithInteger:[[dm defaultUserObjectForKey:@"photoCount"] intValue] + 1] forKey:@"photoCount"];
        [dm update];
    }
    
    [galleryTableView reloadData];
}

/*************************************  Delete Action  ****************************************/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        DiceTableViewCell *selectedCell = (DiceTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.mergeImage.image != nil) {
            DataManager *dm = [DataManager SharedDataManager];
            NSString *imageName = [NSString stringWithFormat:@"photo%d.png", indexPath.row];
            if ([dm doesImageExist:imageName]) {
                [dm removeImageFromImageCacheNamed:imageName];
                [dm setDefaultUserObject:[NSNumber numberWithInteger:[[dm defaultUserObjectForKey:@"photoCount"] intValue] - 1] forKey:@"photoCount"];
                [dm update];
            }
            
            if (mergeImages.count > 0) {
                [mergeImages removeObjectAtIndex:indexPath.row];
                [self.allData removeObjectAtIndex:indexPath.row];
            }
            
            [galleryTableView reloadData]; // tell table to refresh now
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiceTableViewCell *selectedCell = (DiceTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    if (selectedCell.mergeImage.image == nil) {
        if (selectedCell.mergeImageOne.image != nil && selectedCell.mergeImageTwo.image != nil) {
            PhotoMergeViewController *photoMergeView = [[PhotoMergeViewController alloc] init];
            photoMergeView.image1 = selectedCell.mergeImageOne.image;
            photoMergeView.image2 = selectedCell.mergeImageTwo.image;
            selectedCell.importImageBtn.hidden = YES;
            photoMergeView.delegate = self;
            photoMergeView.indexShare = indexPath.row;
            [self.navigationController pushViewController:photoMergeView animated:YES];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Photo Collage" message:@"1. Tap the folder icon to select a photo\n 2. Tap it again to select the second        photo\n 3. Combine the two photos to make it  look like it’s taken at the same place\n 4. Share it                                                                  " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MHGallerySectionItem *section = self.allData[indexPath.row];
            NSArray *galleryData = section.galleryItems;
            if (galleryData.count >0) {
                
                MHGalleryController *gallery = [[MHGalleryController alloc]initWithPresentationStyle:MHGalleryViewModeOverView];
                gallery.galleryItems = galleryData;
                gallery.presentationIndex = indexPath.row;
                gallery.galleryDelegate = self; // mine
                
                __weak MHGalleryController *blockGallery = gallery;
                
                gallery.finishedCallback = ^(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition,MHGalleryViewMode viewMode){
                    [blockGallery dismissViewControllerAnimated:YES dismissImageView:nil completion:nil];
                };
                
                [self presentMHGalleryController:gallery animated:YES completion:nil];
                
            }else{
                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"Hint"
                                                                   message:@"You don't have images on your Simulator"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
                [alterView show];
            }
        });
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    DiceTableViewCellScrollDirection scrollDirection = ScrollDirectionNone;
    
    if (self.lastContentOffset.x > scrollView.contentOffset.x)
    {
        scrollDirection = ScrollDirectionRight;
    }
    else if (self.lastContentOffset.x < scrollView.contentOffset.x)
    {
        scrollDirection = ScrollDirectionLeft;
    }
    else if (self.lastContentOffset.y > scrollView.contentOffset.y)
    {
        scrollDirection = ScrollDirectionDown;
    }
    else if (self.lastContentOffset.y < scrollView.contentOffset.y)
    {
        scrollDirection = ScrollDirectionUp;
    }
    else
    {
        scrollDirection = ScrollDirectionCrazy;
    }
    
    self.lastContentOffset = scrollView.contentOffset;
    
    id notificationObject = [NSNumber numberWithInteger:scrollDirection];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DiceTableViewCellDirectionNotification object:notificationObject];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
