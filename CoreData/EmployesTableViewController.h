//
//  EmployesTableViewController.h
//  CoreData
//
//  Created by Marian Paul on 02/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateEmployeTableViewController.h"

@class Entreprise;

@interface EmployesTableViewController : UITableViewController <CreateEmployeDelegate>
{
    NSMutableArray *_employesArray;
}
@property (nonatomic, strong) Entreprise *entreprise;
@end
