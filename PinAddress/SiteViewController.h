//
//  ViewPointsViewController.h
//  PinAddress
//
//  Created by Zhu Yu on 14-2-11.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic,retain) NSFetchedResultsController * fetchedResultsController;

@end
