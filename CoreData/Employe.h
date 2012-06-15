//
//  Employe.h
//  CoreData
//
//  Created by Marian Paul on 02/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entreprise;

@interface Employe : NSManagedObject

@property (nonatomic, retain) NSString * nom;
@property (nonatomic, retain) NSString * prenom;
@property (nonatomic, retain) NSString * sexe;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) Entreprise *entreprise;

@end
