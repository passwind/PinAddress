//
//  PhotoThumbCell.h
//  PinAddress
//
//  Created by Zhu Yu on 14-3-1.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoThumbCell;

@protocol PhotoThumbCellDelegate <NSObject>

-(void)photoThumbCell:(PhotoThumbCell*)cell didDelete:(id)sender;

@end

@interface PhotoThumbCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteAction:(id)sender;

@property (weak,nonatomic) id<PhotoThumbCellDelegate> delegate;
@end
