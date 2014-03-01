//
//  UnitPhotoViewController.h
//  PinAddress
//
//  Created by Zhu Yu on 14-1-14.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "UnitScopeViewController.h"
@class Unit;

@interface UnitPhotoViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) Unit * unit;

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;

@end
