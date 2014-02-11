//
//  ViewPointsViewController.m
//  PinAddress
//
//  Created by Zhu Yu on 14-2-11.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "SiteViewController.h"
#import "Site.h"
#import "SiteDetailViewController.h"
#import "UnitViewController.h"

@interface SiteViewController ()<SiteDetailViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SiteViewController

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
	
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError * error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@ %@",error,[error userInfo]);
        exit(-1);
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController!=nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest * fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription * entity=[NSEntityDescription entityForName:@"Site" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor * sort=[[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    //
    //    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController * theFetchedResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    self.fetchedResultsController=theFetchedResultsController;
    _fetchedResultsController.delegate=self;
    
    return _fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id sectionInfo=[[_fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Site * info=[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ (%d)",info.name,[info.units count]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SiteBriefCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView * tableView=self.tableView;
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AddSite"]) {
        UINavigationController * navigationController=[segue destinationViewController];
        SiteDetailViewController * addSiteViewController=[navigationController viewControllers][0];
        
        addSiteViewController.delegate=self;
        
        NSManagedObjectContext * addingContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [addingContext setParentContext:[self.fetchedResultsController managedObjectContext]];
        
        Site * newSite=(Site*)[NSEntityDescription insertNewObjectForEntityForName:@"Site" inManagedObjectContext:addingContext];
        newSite.name=@"新建地区";
        addSiteViewController.site=newSite;
        
        addSiteViewController.managedObjectContext=addingContext;
    }
    
    if ([segue.identifier isEqualToString:@"EditSite"]) {
        NSIndexPath * indexPath=[self.tableView indexPathForSelectedRow];
        Site * selectedSite=(Site*)[_fetchedResultsController objectAtIndexPath:indexPath];
        
        UINavigationController * navigationController=[segue destinationViewController];
        SiteDetailViewController * addSiteViewController=[navigationController viewControllers][0];
        
        addSiteViewController.delegate=self;
        
        NSManagedObjectContext * addingContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [addingContext setParentContext:[self.fetchedResultsController managedObjectContext]];
        
        addSiteViewController.site=selectedSite;
        
        addSiteViewController.managedObjectContext=addingContext;
    }
    
    if([segue.identifier isEqualToString:@"ShowSiteDetail"]){
        NSIndexPath * indexPath=[self.tableView indexPathForSelectedRow];
        Site * selectedSite=(Site*)[_fetchedResultsController objectAtIndexPath:indexPath];
        
        UnitViewController * unitViewController=[segue destinationViewController];
        
        unitViewController.site=selectedSite;
        
        unitViewController.managedObjectContext=selectedSite.managedObjectContext;
    }
}

#pragma mark - AddUnitViewControllerDelegate

-(void)siteDetailViewController:(SiteDetailViewController *)controller didFinishWithSave:(BOOL)save
{
    if (save) {
        NSError * error;
        NSManagedObjectContext * addingContext=[controller managedObjectContext];
        if(![addingContext save:&error]){
            NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
            abort();
        }
        
        if (![[self.fetchedResultsController managedObjectContext] save:&error]) {
            NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
            abort();
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
