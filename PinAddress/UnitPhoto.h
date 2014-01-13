//
//  UnitPhoto.h
//  PinAddress
//
//  Created by Zhu Yu on 14-1-14.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Unit;

@interface UnitPhoto : NSManagedObject

@property (nonatomic, retain) NSString * localSrc;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) Unit *unit;

@end
