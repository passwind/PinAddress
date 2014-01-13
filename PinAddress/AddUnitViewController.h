//
//  AddUnitViewController.h
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UnitDetailViewController.h"

@class AddUnitViewController;

@protocol AddUnitViewControllerDelegate <NSObject>

-(void)addUnitViewController:(AddUnitViewController*)controller didFinishWithSave:(BOOL)save;

@end

@interface AddUnitViewController : UnitDetailViewController

@property (nonatomic,weak) id<AddUnitViewControllerDelegate> delegate;

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;


@end
