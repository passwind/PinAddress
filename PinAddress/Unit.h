//
//  Unit.h
//  PinAddress
//
//  Created by Zhu Yu on 14-2-11.
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
@property (nonatomic, retain) NSSet *photo;
@property (nonatomic, retain) NSSet *scope;
@property (nonatomic, retain) Site *site;
@end

@interface Unit (CoreDataGeneratedAccessors)

- (void)addPhotoObject:(UnitPhoto *)value;
- (void)removePhotoObject:(UnitPhoto *)value;
- (void)addPhoto:(NSSet *)values;
- (void)removePhoto:(NSSet *)values;

- (void)addScopeObject:(UnitScope *)value;
- (void)removeScopeObject:(UnitScope *)value;
- (void)addScope:(NSSet *)values;
- (void)removeScope:(NSSet *)values;

@end
