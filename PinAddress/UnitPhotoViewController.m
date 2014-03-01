//
//  UnitPhotoViewController.m
//  PinAddress
//
//  Created by Zhu Yu on 14-1-14.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "UnitPhotoViewController.h"
#import "Unit.h"
#import "UnitPhoto.h"
#import "UnitPhotoCell.h"
#import "UIImage+fixOrientation.h"
#import "UIImage+IF.h"
#import "PhotoThumbCell.h"
#import "CTAssetsPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kTagAddPhoto 9998

@interface UnitPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PhotoThumbCellDelegate,CTAssetsPickerControllerDelegate>
{
    dispatch_queue_t _imageProcessQueue;
}

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)newPhoto:(id)sender;

@end

@implementation UnitPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageProcessQueue=dispatch_queue_create("com.hollysmart.pinaddress", NULL);
    
    self.title=[NSString stringWithFormat:@"%@ 地点图片",_unit.name];
    
    self.managedObjectContext=_unit.managedObjectContext;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - control function

- (IBAction)newPhoto:(id)sender {
    UIActionSheet *choosePhotoActionSheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_camera", @""), NSLocalizedString(@"take_photo_from_library", @""), nil];
    } else {
        choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose_photo", @"")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancel", @"")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"take_photo_from_library", @""), nil];
    }
    
    [choosePhotoActionSheet showInView:self.view];
}

#pragma mark - PhotoThumbCellDelegate
-(void)photoThumbCell:(PhotoThumbCell *)cell didDelete:(id)sender
{
    NSIndexPath * indexPath=[_collectionView indexPathForCell:cell];
    
    // Delete the managed object.
    UnitPhoto * unitPhoto=_unit.photo[indexPath.item];
    [_unit removePhotoObject:unitPhoto];
    [_managedObjectContext deleteObject:unitPhoto];
    
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

-(NSData*)makeThumbImage:(UIImage*)origImage
{
    UIImage * rotateImage=[origImage fixOrientation];
    CGSize newSize;
    CGFloat origWidth=rotateImage.size.width;
    CGFloat origHeight=rotateImage.size.height;
    if (origWidth>origHeight) {
        if (origHeight/origWidth>460/320) {
            newSize.width=320;
            newSize.height=origHeight*newSize.width/origWidth;
        }
        else{
            newSize.height=460;
            newSize.width=origWidth*newSize.height/origHeight;
        }
    }
    else{
        if (origHeight/origWidth>320/460) {
            newSize.width=460;
            newSize.height=origHeight*newSize.width/origWidth;
        }
        else{
            newSize.height=320;
            newSize.width=origWidth*newSize.height/origHeight;
        }
    }
    UIImage * image=[rotateImage resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
    
    return UIImageJPEGRepresentation(image, 0.7);
}

#pragma mark - UIImagePickerControllerDelegate

//得到图片信息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData* imageData = UIImagePNGRepresentation([image fixOrientation]);
    
    // Give a name to the file
    NSString* imageName = [NSString stringWithFormat:@"%f.png",[[NSDate date] timeIntervalSinceReferenceDate]];
    
    // Now, we have to find the documents directory so we can save it
    // Note that you might want to save it elsewhere, like the cache directory,
    // or something similar.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    UnitPhoto * newPhoto=[NSEntityDescription insertNewObjectForEntityForName:@"UnitPhoto" inManagedObjectContext:self.managedObjectContext];
    newPhoto.createdAt=[NSDate date];
    newPhoto.localSrc=fullPathToFile;

    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:[_unit.photo count] inSection:0];
    newPhoto.unit=_unit;
    
    [_unit addPhotoObject:newPhoto];
    
    NSError * error;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [_collectionView insertItemsAtIndexPaths:@[indexPath]];

    dispatch_async(_imageProcessQueue, ^{
        newPhoto.thumb=[self makeThumbImage:image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError * error;
            if (![_managedObjectContext save:&error]) {
                NSLog(@"error save thumb");
            }
            
            [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        });
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    if (sourceType==UIImagePickerControllerSourceTypeCamera) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:Nil];
    }
    else if(sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 5;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
	
}

#pragma mark - UICollectionView Datasource

-(void)configureCell:(PhotoThumbCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    UnitPhoto * info=_unit.photo[indexPath.row];
    UIImage * image;
    
    if (info.thumb) {
        image=[UIImage imageWithData:info.thumb];
    }
    else{
        image=[UIImage imageNamed:@"default_image"];
    }
    
    cell.imageView.image=image;
    cell.delegate=self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [_unit.photo count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoThumbCell * cell=(PhotoThumbCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoThumbCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ThumbHeaderView" forIndexPath:indexPath];
    
    return headerView;
}

#pragma mark - CTAssetsPickerControllerDelegate
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self dismissViewControllerAnimated:NO completion:^{
        if ([assets count]>0) {
            [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ALAsset * asset=obj;
                ALAssetRepresentation * rep=[asset defaultRepresentation];
                UIImage * image=[UIImage imageWithCGImage:[rep fullResolutionImage] scale:1.0 orientation:(UIImageOrientation)rep.orientation];
                NSData* imageData = UIImagePNGRepresentation(image);
                // Give a name to the file
                NSString* imageName = [NSString stringWithFormat:@"%f.png",[[NSDate date] timeIntervalSinceReferenceDate]];
                
                // Now, we have to find the documents directory so we can save it
                // Note that you might want to save it elsewhere, like the cache directory,
                // or something similar.
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                
                // Now we get the full path to the file
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
                
                // and then we write it out
                [imageData writeToFile:fullPathToFile atomically:NO];
                
                UnitPhoto * newPhoto=[NSEntityDescription insertNewObjectForEntityForName:@"UnitPhoto" inManagedObjectContext:self.managedObjectContext];
                newPhoto.createdAt=[NSDate date];
                newPhoto.localSrc=fullPathToFile;
                [_unit addPhotoObject:newPhoto];
                newPhoto.unit=_unit;
                NSError * error;
                
                if (![self.managedObjectContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
                    abort();
                }
            
                NSIndexPath * indexPath=[NSIndexPath indexPathForItem:[_unit.photo count]-1 inSection:0];
                [_collectionView insertItemsAtIndexPaths:@[indexPath]];
                
                dispatch_async(_imageProcessQueue, ^{
                    newPhoto.thumb=[self makeThumbImage:image];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSError * error;
                        if (![_managedObjectContext save:&error]) {
                            NSLog(@"error save thumb");
                        }
                        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    });
                });
            }];
        }
    }];
}

@end
