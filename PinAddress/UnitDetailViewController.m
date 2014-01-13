//
//  UnitDetailViewController.m
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "UnitDetailViewController.h"

#import "UnitScopeViewController.h"
#import "EditingViewController.h"

#import "AppDelegate.h"

@interface UnitDetailViewController ()
{
    NSTimer *myTimer;
}
- (IBAction)setCurrentGPS:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentLongLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLatLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scopeDetailLabel;

@property (nonatomic, strong) NSUndoManager *undoManager;

- (void)updateInterface;
- (void)updateRightBarButtonItemState;

@end

@implementation UnitDetailViewController
@synthesize undoManager;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    if ([self class] == [UnitDetailViewController class]) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // if the local changes behind our back, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    // Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    
    /*
     When editing starts, create and set an undo manager to track edits. Then register as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded.
     When editing ends, de-register from the notification center and remove the undo manager, and save the changes.
     */
    if (editing) {
        [self setUpUndoManager];
    }
    else {
        [self cleanUpUndoManager];
        // Save the changes.
        NSError *error;
        if (![self.unit.managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)updateInterface {
    self.nameLabel.text=self.unit.name;
    self.latitudeLabel.text = [NSString stringWithFormat:@"%.6f",[self.unit.latitude floatValue]];
    self.longitudeLabel.text = [NSString stringWithFormat:@"%.6f",[self.unit.longitude floatValue]];
    self.scopeDetailLabel.text=[NSString stringWithFormat:@"%d",[self.unit.scope count]];
}

- (void)updateRightBarButtonItemState {
    
    // Conditionally enable the right bar button item -- it should only be enabled if the book is in a valid state for saving.

    self.navigationItem.rightBarButtonItem.enabled = [self.unit validateForUpdate:NULL];

}

#pragma mark - UITableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Only allow selection if editing.
    if (indexPath.section==0) {
        if (self.editing) {
            return indexPath;
        }
        return nil;
    }
    return indexPath;
}

/*
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.editing && indexPath.section==0) {
        [self performSegueWithIdentifier:@"EditSelectedItem" sender:self];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - Undo support

- (void)setUpUndoManager {
    
    /*
     If the book's managed object context doesn't already have an undo manager, then create one and set it for the context and self.
     The view controller needs to keep a reference to the undo manager it creates so that it can determine whether to remove the undo manager when editing finishes.
     */
    if (self.unit.managedObjectContext.undoManager == nil) {
        
        NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
        [anUndoManager setLevelsOfUndo:3];
        self.undoManager = anUndoManager;
        
        self.unit.managedObjectContext.undoManager = self.undoManager;
    }
    
    // Register as an observer of the book's context's undo manager.
    NSUndoManager *bookUndoManager = self.unit.managedObjectContext.undoManager;
    
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:bookUndoManager];
    [dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:bookUndoManager];
}


- (void)cleanUpUndoManager {
    
    // Remove self as an observer.
    NSUndoManager *bookUndoManager = self.unit.managedObjectContext.undoManager;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:bookUndoManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:bookUndoManager];
    
    if (bookUndoManager == self.undoManager) {
        self.unit.managedObjectContext.undoManager = nil;
        self.undoManager = nil;
    }
}


- (NSUndoManager *)undoManager {
    
    return self.unit.managedObjectContext.undoManager;
}


- (void)undoManagerDidUndo:(NSNotification *)notification {
    
    // Redisplay the data.
    [self updateInterface];
    [self updateRightBarButtonItemState];
}


- (void)undoManagerDidRedo:(NSNotification *)notification {
    
    // Redisplay the data.
    [self updateInterface];
    [self updateRightBarButtonItemState];
}


/*
 The view controller must be first responder in order to be able to receive shake events for undo. It should resign first responder status when it disappears.
 */
- (BOOL)canBecomeFirstResponder {
    
    return YES;
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    // Redisplay the data.
    [self updateInterface];
    [self updateRightBarButtonItemState];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    
    [myTimer invalidate];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"EditSelectedItem"]) {
        
        EditingViewController *controller = (EditingViewController *)[segue destinationViewController];
        controller.editedObject = self.unit;
        controller.editedFieldKey = @"name";
        controller.editedFieldName = NSLocalizedString(@"name", @"display name for title");
    }
    
    if ([[segue identifier] isEqualToString:@"ShowUnitScope"]) {
        UnitScopeViewController *unitScopeViewController=(UnitScopeViewController*)[segue destinationViewController];
        unitScopeViewController.unit=self.unit;
    }
}

#pragma mark - Locale changes

- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self updateInterface];
}

#pragma mark - set gps

-(void)onTimer
{
    if (gLocation==nil)
    {
        return;
    }
    
    self.currentLatLabel.text = [NSString stringWithFormat:@"%.6f",gLocation.coordinate.latitude];
    self.currentLongLabel.text = [NSString stringWithFormat:@"%.6f",gLocation.coordinate.longitude];
}

- (IBAction)setCurrentGPS:(id)sender {
    [undoManager setActionName:@"longitude"];
    self.unit.longitude=[NSNumber numberWithFloat:gLocation.coordinate.longitude];
    
    [undoManager setActionName:@"latitude"];
    self.unit.latitude=[NSNumber numberWithFloat:gLocation.coordinate.latitude];
    
    [self updateInterface];
}
@end
