//
//  UnitScopeViewController.h
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Unit.h"

@interface UnitScopeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) Unit * unit;

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;

@end
