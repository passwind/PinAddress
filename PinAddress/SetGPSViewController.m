//
//  SetGPSViewController.m
//  PinAddress
//
//  Created by Zhu Yu on 14-1-13.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "SetGPSViewController.h"
#import "AppDelegate.h"
#import "Unit.h"

@interface SetGPSViewController ()
{
    NSTimer *myTimer;
}
@property (weak, nonatomic) IBOutlet UILabel *currentLatitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLongitudeLabel;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@implementation SetGPSViewController

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
	// Do any additional setup after loading the view.
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [myTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTimer
{
    if (gLocation==nil)
    {
        return;
    }
    
    self.currentLatitudeLabel.text = [NSString stringWithFormat:@"%.6f",gLocation.coordinate.latitude];
    self.currentLongitudeLabel.text = [NSString stringWithFormat:@"%.6f",gLocation.coordinate.longitude];
}

- (IBAction)cancel:(id)sender {
    NSUndoManager * undoManager=[[self.unit managedObjectContext] undoManager];
    
    [undoManager setActionName:@"longitude"];
    self.unit.longitude=[NSNumber numberWithFloat:gLocation.coordinate.longitude];
    
    [undoManager setActionName:@"latitude"];
    self.unit.latitude=[NSNumber numberWithFloat:gLocation.coordinate.latitude];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
