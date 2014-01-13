//
//  UnitScope.h
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Unit;

@interface UnitScope : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) Unit *unit;

@end
