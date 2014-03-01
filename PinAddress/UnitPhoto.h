//
//  UnitPhoto.h
//  PinAddress
//
//  Created by Zhu Yu on 14-3-1.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Unit;

@interface UnitPhoto : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * localSrc;
@property (nonatomic, retain) NSData * thumb;
@property (nonatomic, retain) Unit *unit;

@end
