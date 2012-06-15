//
//  Entreprise.h
//  CoreData
//
//  Created by Marian Paul on 02/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entreprise : NSManagedObject

@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSSet *employes;
@end

@interface Entreprise (CoreDataGeneratedAccessors)

- (void)addEmployesObject:(NSManagedObject *)value;
- (void)removeEmployesObject:(NSManagedObject *)value;
- (void)addEmployes:(NSSet *)values;
- (void)removeEmployes:(NSSet *)values;

@end
