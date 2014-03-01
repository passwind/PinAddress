//
//  Unit.h
//  PinAddress
//
//  Created by Zhu Yu on 14-3-1.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Site, UnitPhoto, UnitScope;

@interface Unit : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *photo;
@property (nonatomic, retain) NSOrderedSet *scope;
@property (nonatomic, retain) Site *site;
@end

@interface Unit (CoreDataGeneratedAccessors)

- (void)insertObject:(UnitPhoto *)value inPhotoAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPhotoAtIndex:(NSUInteger)idx;
- (void)insertPhoto:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePhotoAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPhotoAtIndex:(NSUInteger)idx withObject:(UnitPhoto *)value;
- (void)replacePhotoAtIndexes:(NSIndexSet *)indexes withPhoto:(NSArray *)values;
- (void)addPhotoObject:(UnitPhoto *)value;
- (void)removePhotoObject:(UnitPhoto *)value;
- (void)addPhoto:(NSOrderedSet *)values;
- (void)removePhoto:(NSOrderedSet *)values;
- (void)insertObject:(UnitScope *)value inScopeAtIndex:(NSUInteger)idx;
- (void)removeObjectFromScopeAtIndex:(NSUInteger)idx;
- (void)insertScope:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeScopeAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInScopeAtIndex:(NSUInteger)idx withObject:(UnitScope *)value;
- (void)replaceScopeAtIndexes:(NSIndexSet *)indexes withScope:(NSArray *)values;
- (void)addScopeObject:(UnitScope *)value;
- (void)removeScopeObject:(UnitScope *)value;
- (void)addScope:(NSOrderedSet *)values;
- (void)removeScope:(NSOrderedSet *)values;
@end
