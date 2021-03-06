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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [_unit.scope count];
}

-(void)configureCell:(UnitScopeCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    UnitScope * info=_unit.scope[indexPath.row];
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        
        UnitScope * info=_unit.scope[indexPath.row];
        [_unit removeScopeObject:info];
        [_managedObjectContext deleteObject:info];
        
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:[_unit.scope count]-1 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
