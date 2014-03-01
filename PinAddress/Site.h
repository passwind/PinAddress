//
//  Site.h
//  PinAddress
//
//  Created by Zhu Yu on 14-3-1.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Unit;

@interface Site : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *units;
@end

@interface Site (CoreDataGeneratedAccessors)

- (void)insertObject:(Unit *)value inUnitsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUnitsAtIndex:(NSUInteger)idx;
- (void)insertUnits:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUnitsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUnitsAtIndex:(NSUInteger)idx withObject:(Unit *)value;
- (void)replaceUnitsAtIndexes:(NSIndexSet *)indexes withUnits:(NSArray *)values;
- (void)addUnitsObject:(Unit *)value;
- (void)removeUnitsObject:(Unit *)value;
- (void)addUnits:(NSOrderedSet *)values;
- (void)removeUnits:(NSOrderedSet *)values;
@end
