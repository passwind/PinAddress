//
//  UnitDetailViewController.h
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Unit.h"

@interface UnitDetailViewController : UITableViewController

@property (nonatomic,strong) Unit * unit;

@end

// These methods are used by the AddViewController, so are declared here, but they are private to these classes.

@interface UnitDetailViewController (Private)

- (void)setUpUndoManager;
- (void)cleanUpUndoManager;

@end