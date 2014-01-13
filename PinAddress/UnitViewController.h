//
//  UnitViewController.h
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic,retain) NSFetchedResultsController * fetchedResultsController;

@end
