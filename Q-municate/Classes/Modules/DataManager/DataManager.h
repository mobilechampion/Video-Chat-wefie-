//
//  DataManager.h
//  WarbyParker
//
//  Created by Philip Hayes on 2/20/12.
//  Copyright (c) 2012 happyMedium
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define IS_IPHONE ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
#define IS_IPHONE_RETINA ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] scale] == 2.00 )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPAD ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
#define IS_IPAD_RETINA ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad && [[UIScreen mainScreen] scale] == 2.00 )
@protocol DataManagerDelegate <NSObject>

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@interface DataManager : NSObject<NSFetchedResultsControllerDelegate>{
    
}

//Passed in from the app delegate
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//Not in use currently
@property(nonatomic, weak)id<DataManagerDelegate>delegate;


+(DataManager*)SharedDataManager;

//Call this to save any and all changes made to the managedObjectContext
-(void)update;

//If at any time multi-threading is needed a second context must be managed and then passed back when done
-(void)saveBackgroundContext;

#pragma mark - fetchedResultsController helpers

//Simplification of the current fetching opperation
-(NSArray *) getResultsWithEntity:(NSString*)entity sortDescriptor:(NSString*)sortDesc batchSize:(int)batchSize;
-(NSArray *) getResultsWithEntity:(NSString*)entity sortDescriptor:(NSString*)sortDesc sortPredicate:(NSPredicate*)sortPredicate batchSize:(int)batchSize;

-(NSFetchedResultsController*)fetchedResultsControllerWithEntity:(NSString*)entity sortDescriptor:(NSString*)sortDesc batchSize:(int)batchSize;
-(NSFetchedResultsController*)fetchedResultsControllerWithEntity:(NSString*)entity sortDescriptor:(NSString*)sortDesc sortPredicate:(NSPredicate*)sortPredicate batchSize:(int)batchSize;

-(id)newObjectForEntityForName:(NSString *)name;
#pragma  mark - NSUserDefaults helpers
/* methods for using NSUserDefaults */

-(id) defaultUserObjectForKey:(NSString *)key;
-(void) setDefaultUserObject:(id)obj forKey:(NSString *)key;

#pragma mark - File/image loading/cache helpers
/* methods for saving images to/loading from disk */

-(NSString *) saveImageToDevice:(UIImage *)file withName:(NSString *)name extension:(NSString *)ext;
-(BOOL)addSkipBackupAttributeToFile:(NSString *)fileName;
-(BOOL) removeFile:(NSString *)fileName;
-(BOOL) doesFileExist:(NSString *)fileName;
-(BOOL) doesImageExist:(NSString *)imageName;
-(UIImage *) loadImageNamed:(NSString *)imageName;
-(void) clearImageCache;
-(void) removeImageFromImageCache:(UIImage *)image;
-(void) removeImageFromImageCacheNamed:(NSString *)imageName;

#pragma mark - other helpers
/* method for loading view from a Nib */
-(UIView *) loadViewFromNib:(NSString *) nibName andOwner:(id) owner;
-(NSString *)nibNameWithDeviceSuffix:(NSString *)name;
@end
