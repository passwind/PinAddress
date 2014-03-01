//
//  Unit+CoreDataGeneratedAccessors.m
//  PinAddress
//
//  Created by Zhu Yu on 14-3-1.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import "Unit+CoreDataGeneratedAccessors.h"

@implementation Unit (CoreDataGeneratedAccessors)

- (void)insertObject:(UnitPhoto *)value inPhotoAtIndex:(NSUInteger)idx
{
    
}

- (void)removeObjectFromPhotoAtIndex:(NSUInteger)idx
{
    
}

- (void)insertPhoto:(NSArray *)value atIndexes:(NSIndexSet *)indexes
{
    
}

- (void)removePhotoAtIndexes:(NSIndexSet *)indexes
{
    
}

- (void)replaceObjectInPhotoAtIndex:(NSUInteger)idx withObject:(UnitPhoto *)value
{
    
}

- (void)replacePhotoAtIndexes:(NSIndexSet *)indexes withPhoto:(NSArray *)values
{
    
}

- (void)addPhotoObject:(UnitPhoto *)value
{
    NSMutableOrderedSet * tmpSet=[NSMutableOrderedSet orderedSetWithOrderedSet:self.photo];
    [tmpSet addObject:value];
    self.photo=tmpSet;
}

- (void)removePhotoObject:(UnitPhoto *)value
{
    NSMutableOrderedSet * tmpSet=[NSMutableOrderedSet orderedSetWithOrderedSet:self.photo];
    [tmpSet removeObject:value];
    self.photo=tmpSet;
}

- (void)addPhoto:(NSOrderedSet *)values
{
    NSMutableOrderedSet * tmpSet=[NSMutableOrderedSet orderedSetWithOrderedSet:self.photo];
    
    [tmpSet unionOrderedSet:values];
    self.photo=tmpSet;
}

- (void)removePhoto:(NSOrderedSet *)values
{
    
}

- (void)insertObject:(UnitScope *)value inScopeAtIndex:(NSUInteger)idx
{
    
}

- (void)removeObjectFromScopeAtIndex:(NSUInteger)idx
{
    
}

- (void)insertScope:(NSArray *)value atIndexes:(NSIndexSet *)indexes
{
    
}

- (void)removeScopeAtIndexes:(NSIndexSet *)indexes
{
    
}

- (void)replaceObjectInScopeAtIndex:(NSUInteger)idx withObject:(UnitScope *)value
{
    
}

- (void)replaceScopeAtIndexes:(NSIndexSet *)indexes withScope:(NSArray *)values
{
    
}

- (void)addScopeObject:(UnitScope *)value
{
    NSMutableOrderedSet * tmpSet=[NSMutableOrderedSet orderedSetWithOrderedSet:self.scope];
    [tmpSet addObject:value];
    self.scope=tmpSet;
}

- (void)removeScopeObject:(UnitScope *)value
{
    NSMutableOrderedSet * tmpSet=[NSMutableOrderedSet orderedSetWithOrderedSet:self.scope];
    [tmpSet removeObject:value];
    self.scope=tmpSet;
}

- (void)addScope:(NSOrderedSet *)values
{
    
}

- (void)removeScope:(NSOrderedSet *)values
{
    
}

@end
