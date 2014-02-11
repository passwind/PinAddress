//
//  ViewPointDetailViewController.h
//  PinAddress
//
//  Created by Zhu Yu on 14-2-11.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Site;

@class SiteDetailViewController;

@protocol SiteDetailViewControllerDelegate <NSObject>

-(void)siteDetailViewController:(SiteDetailViewController*)controller didFinishWithSave:(BOOL)save;

@end
@interface SiteDetailViewController : UITableViewController

@property (nonatomic,strong) Site * site;
@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;

@property (nonatomic,weak) id<SiteDetailViewControllerDelegate> delegate;

@end
