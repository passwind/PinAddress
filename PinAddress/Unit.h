//
//  Unit.h
//  PinAddress
//
//  Created by Zhu Yu on 14-1-10.
//  Copyright (c) 2014年 hollysmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UnitScope;

@interface Unit : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSSet *scope;
@end

@interface Unit (CoreDataGeneratedAccessors)

- (void)addScopeObject:(UnitScope *)value;
- (void)removeScopeObject:(UnitScope *)value;
- (void)addScope:(NSSet *)values;
- (void)removeScope:(NSSet *)values;

@end
