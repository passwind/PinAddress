//
//  Site+CoreDataGeneratedAccessors.m
//  PinAddress
//
//  Created by Zhu Yu on 14-3-1.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "Site+CoreDataGeneratedAccessors.h"

@implementation Site (CoreDataGeneratedAccessors)

- (void)insertObject:(Unit *)value inUnitsAtIndex:(NSUInteger)idx
{
    
}

- (void)removeObjectFromUnitsAtIndex:(NSUInteger)idx
{
    
}

- (void)insertUnits:(NSArray *)value atIndexes:(NSIndexSet *)indexes
{
    
}

- (void)removeUnitsAtIndexes:(NSIndexSet *)indexes
{
    
}

- (void)replaceObjectInUnitsAtIndex:(NSUInteger)idx withObject:(Unit *)value
{
    
}

- (void)replaceUnitsAtIndexes:(NSIndexSet *)indexes withUnits:(NSArray *)values
{
    
}

- (void)addUnitsObject:(Unit *)value
{
    NSMutableOrderedSet * tmpSet=[NSMutableOrderedSet orderedSetWithOrderedSet:self.units];
    [tmpSet addObject:value];
    self.units=tmpSet;
}

- (void)removeUnitsObject:(Unit *)value
{
    NSMutableOrderedSet * tmpSet=[NSMutableOrderedSet orderedSetWithOrderedSet:self.units];
    [tmpSet removeObject:value];
    self.units=tmpSet;
}

- (void)addUnits:(NSOrderedSet *)values
{
    
}

- (void)removeUnits:(NSOrderedSet *)values
{
    
}

@end
