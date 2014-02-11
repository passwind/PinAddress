//
//  ViewPointDetailViewController.m
//  PinAddress
//
//  Created by Zhu Yu on 14-2-11.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "SiteDetailViewController.h"
#import "Site.h"

@interface SiteDetailViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) NSUndoManager *undoManager;

- (void)updateInterface;
- (void)updateRightBarButtonItemState;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation SiteDetailViewController
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

    self.title=_site.name;
    
    [self setUpUndoManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateInterface {
    self.nameTextField.text=self.site.name;
}

- (void)updateRightBarButtonItemState {
    
    // Conditionally enable the right bar button item -- it should only be enabled if the book is in a valid state for saving.
    
    self.navigationItem.rightBarButtonItem.enabled = [self.site validateForUpdate:NULL];
    
}

- (IBAction)cancel:(id)sender {
    [self.delegate siteDetailViewController:self didFinishWithSave:NO];
}

- (IBAction)save:(id)sender {
    self.site.name=[self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.site.createdAt=[NSDate date];
    
    [self.delegate siteDetailViewController:self didFinishWithSave:YES];
}
#pragma mark - Undo support

- (void)setUpUndoManager {
    
    /*
     If the book's managed object context doesn't already have an undo manager, then create one and set it for the context and self.
     The view controller needs to keep a reference to the undo manager it creates so that it can determine whether to remove the undo manager when editing finishes.
     */
    if (self.site.managedObjectContext.undoManager == nil) {
        
        NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
        [anUndoManager setLevelsOfUndo:3];
        self.undoManager = anUndoManager;
        
        self.site.managedObjectContext.undoManager = self.undoManager;
    }
    
    // Register as an observer of the book's context's undo manager.
    NSUndoManager *bookUndoManager = self.site.managedObjectContext.undoManager;
    
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:bookUndoManager];
    [dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:bookUndoManager];
}


- (void)cleanUpUndoManager {
    
    // Remove self as an observer.
    NSUndoManager *bookUndoManager = self.site.managedObjectContext.undoManager;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidUndoChangeNotification object:bookUndoManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUndoManagerDidRedoChangeNotification object:bookUndoManager];
    
    if (bookUndoManager == self.undoManager) {
        self.site.managedObjectContext.undoManager = nil;
        self.undoManager = nil;
    }
}


- (NSUndoManager *)undoManager {
    
    return self.site.managedObjectContext.undoManager;
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
    
    // Redisplay the data.
    [self updateInterface];
    [self updateRightBarButtonItemState];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    
}

#pragma mark - Locale changes

- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self updateInterface];
}

@end
