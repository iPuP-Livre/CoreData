//
//  EntrepriseTableViewController.h
//  CoreData
//
//  Created by Marian Paul on 02/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntreprisesTableViewController : UITableViewController <UIAlertViewDelegate>
{
    UIBarButtonItem *_addButton;
    NSMutableArray *_entrepriseArray; 
}
@end
