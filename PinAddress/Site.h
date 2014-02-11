//
//  Site.h
//  PinAddress
//
//  Created by Zhu Yu on 14-2-11.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Unit;

@interface Site : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *units;
@end

@interface Site (CoreDataGeneratedAccessors)

- (void)addUnitsObject:(Unit *)value;
- (void)removeUnitsObject:(Unit *)value;
- (void)addUnits:(NSSet *)values;
- (void)removeUnits:(NSSet *)values;

@end
