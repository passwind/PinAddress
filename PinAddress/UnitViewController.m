//
//  UnitViewController.m
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "UnitViewController.h"
#import "Site.h"
#import "Unit.h"
#import "UnitScope.h"
#import "UnitPhoto.h"

#import "AddUnitViewController.h"
#import "UnitDetailViewController.h"
#import "ZipArchive.h"

#import "tools.h"

@interface UnitViewController ()<AddUnitViewControllerDelegate>
{
    dispatch_queue_t backgroundQueue;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) Unit * addingUnit;
- (IBAction)export:(id)sender;

@end

@implementation UnitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    backgroundQueue=dispatch_queue_create("com.hollysmart.pickaddress.bgqueue", NULL);
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title=_site.name;
    
    self.managedObjectContext=_site.managedObjectContext;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [_site.units count];
}

-(void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Unit * info=_site.units[indexPath.row];
    cell.textLabel.text=info.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UnitBriefCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
        Unit * unit=_site.units[indexPath.row];
        [_site removeUnitsObject:unit];
        [_managedObjectContext deleteObject:unit];
        
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
    if ([segue.identifier isEqualToString:@"AddUnit"]) {
        UINavigationController * navigationController=[segue destinationViewController];
        AddUnitViewController * addUnitViewController=[navigationController viewControllers][0];
        
        addUnitViewController.delegate=self;
        
        NSManagedObjectContext * addingContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [addingContext setParentContext:_managedObjectContext];
        
        _addingUnit=(Unit*)[NSEntityDescription insertNewObjectForEntityForName:@"Unit" inManagedObjectContext:addingContext];
        _addingUnit.name=@"新建地点";
        addUnitViewController.unit=_addingUnit;
        
        addUnitViewController.managedObjectContext=addingContext;
    }
    
    if([segue.identifier isEqualToString:@"ShowUnitDetail"]){
        NSIndexPath * indexPath=[self.tableView indexPathForSelectedRow];
        Unit * selectedUnit=_site.units[indexPath.row];
        
        UnitDetailViewController * unitDetailViewController=[segue destinationViewController];
        unitDetailViewController.unit=selectedUnit;
    }
}

#pragma mark - AddUnitViewControllerDelegate

-(void)addUnitViewController:(AddUnitViewController *)controller didFinishWithSave:(BOOL)save
{
    if (save) {
        NSError * error;
        
        NSManagedObjectContext * addingContext=[controller managedObjectContext];
        Site * currentSite=(Site*)[addingContext objectWithID:_site.objectID];
        
        _addingUnit.site=currentSite;
        
        [currentSite addUnitsObject:_addingUnit];
        
        if(![addingContext save:&error]){
            NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
            abort();
        }
        
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error,[error userInfo]);
            abort();
        }
        NSIndexPath * indexPath=[NSIndexPath indexPathForRow:[_site.units count]-1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)exportData
{
    NSDateFormatter * df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    NSString * prefix=[df stringFromDate:[NSDate date]];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * zf=[NSString stringWithFormat:@"%@_%@.zip",_site.name,prefix];
    NSString* zipFile = [documentsDirectory stringByAppendingPathComponent:zf];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    ZipArchive * za=[[ZipArchive alloc] init];
    [za CreateZipFile2:zipFile];
    
    NSMutableDictionary * siteDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:_site.name,@"siteName",[df stringFromDate:_site.createdAt],@"createdAt", nil];
    NSMutableArray * unitArray=[NSMutableArray arrayWithCapacity:[_site.units count]];
    
    [_site.units enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Unit * unit=obj;
        
        NSMutableDictionary * unitDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:unit.name,@"unitName",[df stringFromDate:unit.createdAt],@"createdAt",unit.latitude,@"latitude",unit.longitude,@"longitude",nil];
        
        NSMutableArray * scopeArray=[NSMutableArray arrayWithCapacity:[unit.scope count]];
        [unit.scope enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UnitScope * scope=obj;
            NSDictionary * scopeDic=[NSDictionary dictionaryWithObjectsAndKeys:scope.latitude,@"latitude",scope.longitude,@"longitude",[df stringFromDate:scope.createdAt],@"createdAt", nil];
            [scopeArray addObject:scopeDic];
        }];
        [unitDic setObject:scopeArray forKey:@"scope"];
        
        NSMutableArray * photoArray=[NSMutableArray arrayWithCapacity:[unit.photo count]];
        [unit.photo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UnitPhoto * photo=obj;
            NSURL * filePath=[NSURL fileURLWithPath:photo.localSrc];
            NSString * filename=[filePath lastPathComponent];
            
            NSDictionary * photoDic=[NSDictionary dictionaryWithObjectsAndKeys:filename,@"filename",[df stringFromDate:photo.createdAt],@"createdAt", nil];
            [photoArray addObject:photoDic];
            [za addFileToZip:photo.localSrc newname:[NSString stringWithFormat:@"%@/%@",prefix,filename]];
        }];
        [unitDic setObject:photoArray forKey:@"photo"];
        
        [unitArray addObject:unitDic];
    }];
    
    [siteDic setObject:unitArray forKey:@"unit"];
    
    NSString * dicFile=[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.json",[[NSDate date]timeIntervalSinceReferenceDate]]];
    
    NSOutputStream * dicFileStream=[NSOutputStream outputStreamToFileAtPath:dicFile append:NO];
    [dicFileStream open];
    
    NSError * error;
    if ([NSJSONSerialization writeJSONObject:siteDic toStream:dicFileStream options:0 error:&error]==0) {
        NSLog(@"write json file error %@",[error localizedDescription]);
    }
    [dicFileStream close];
    
    [za addFileToZip:dicFile newname:[NSString stringWithFormat:@"%@/data.json",prefix]];
    
    [za CloseZipFile2];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [tools removeHUD];
        [tools showTextOnly:self text:[NSString stringWithFormat:@"成功导出，请通过iTunes获取文件"]];
    });
}

- (IBAction)export:(id)sender {
    [tools showHUD:@"正在导出..."];
    
    dispatch_async(backgroundQueue, ^{
        [self exportData];
    });
}
@end
