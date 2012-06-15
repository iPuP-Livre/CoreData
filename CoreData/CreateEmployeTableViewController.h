//
//  CreateEmployeTableViewController.h
//  CoreData
//
//  Created by Marian Paul on 02/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNumberOfEditableRows 4 // Nom, prénom, age et sexe 
#define kNameRowIndex 0 
#define kFirstNameRowIndex 1 
#define kSexRowIndex 2 
#define kAgeIndex 3 
#define kLabelTag 4096 

@class Employe; 
@class CreateEmployeTableViewController;

@protocol CreateEmployeDelegate <NSObject>
- (void) createEmployeController:(CreateEmployeTableViewController*)controller didCreateNewEmploye:(Employe*)employe;
- (void) createEmployerControllerDidCancel:(CreateEmployeTableViewController*)controller;
@end

@interface CreateEmployeTableViewController : UITableViewController <UITextFieldDelegate>
{
    NSArray *_fieldLabels;
    NSMutableDictionary *_tempValues;
    UITextField *_textFieldBeingEdited;
}
@property (nonatomic, assign) id <CreateEmployeDelegate> delegate;
@end
