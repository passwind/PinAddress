//
//  AddUnitViewController.m
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "AddUnitViewController.h"

@interface AddUnitViewController ()

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@implementation AddUnitViewController

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
    [self setUpUndoManager];
    self.editing=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)save:(id)sender {
    self.unit.createdAt=[NSDate date];
    [self.delegate addUnitViewController:self didFinishWithSave:YES];
}
- (IBAction)cancel:(id)sender {
    [self.delegate addUnitViewController:self didFinishWithSave:NO];
}

@end
