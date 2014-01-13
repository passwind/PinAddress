//
//  UnitScopeViewController.m
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "UnitScopeViewController.h"
#import "UnitScopeCell.h"
#import "UnitScope.h"
#import "AppDelegate.h"

@interface UnitScopeViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
- (IBAction)newScope:(id)sender;
@end

@implementation UnitScopeViewController

-(NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController!=nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest * fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription * entity=[NSEntityDescription entityForName:@"UnitScope" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"unit == %@", _unit];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor * sort=[[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    //    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController * theFetchedResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    self.fetchedResultsController=theFetchedResultsController;
    _fetchedResultsController.delegate=self;
    
    return _fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    self.title=[NSString stringWithFormat:@"%@ 范围坐标",_unit.name];
    
    self.managedObjectContext=_unit.managedObjectContext;
    
    NSError * error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@ %@",error,[error userInfo]);
        exit(-1);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)configureCell:(UnitScopeCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    UnitScope * info=[_fetchedResultsController objectAtIndexPath:indexPath];
    cell.latitudeLabel.text = [NSString stringWithFormat:@"%.6f",[info.latitude floatValue]];
    cell.longitudeLabel.text = [NSString stringWithFormat:@"%.6f",[info.longitude floatValue]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UnitScopeCell";
    UnitScopeCell *cell = (UnitScopeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
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
            [self configureCell:(UnitScopeCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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

// Override to support editing the table view.
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

#pragma mark - Table view editing

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // The table view should not be re-orderable.
    return NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
        self.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        self.rightBarButtonItem = nil;
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - add method

- (IBAction)newScope:(id)sender {
    UnitScope * newScope=[NSEntityDescription insertNewObjectForEntityForName:@"UnitScope" inManagedObjectContext:self.managedObjectContext];
    newScope.createdAt=[NSDate date];
    newScope.latitude=[NSNumber numberWithFloat:gLocation.coordinate.latitude];
    newScope.longitude=[NSNumber numberWithFloat:gLocation.coordinate.longitude];
    
    newScope.unit=_unit;
    
    [_unit addScopeObject:newScope];
    
    NSError * error;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
        abort();
    }
}

- (void)editAction:(id)sender {
	[self.tableView setEditing:YES animated:YES];
	[self addButtons:self.tableView.editing];
}

- (void)addButtons:(BOOL)editing {
	if (editing) {
		// Add the "done" button to the navigation bar
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
									   initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
		
		self.navigationItem.rightBarButtonItem = doneButton;
	} else {
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
			
        self.navigationItem.rightBarButtonItem = editButton;
	}
}

- (void)doneAction:(id)sender {
	[self.tableView setEditing:NO animated:YES];
	[self addButtons:self.tableView.editing];
}

@end
