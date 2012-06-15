//
//  EmployesTableViewController.m
//  CoreData
//
//  Created by Marian Paul on 02/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "EmployesTableViewController.h"

#import "Entreprise.h"
#import "Employe.h"

@interface EmployesTableViewController ()
- (void) ajouterEmploye;
@end

@implementation EmployesTableViewController
@synthesize entreprise = _entreprise;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Mettre le titre 
    self.title = _entreprise.nom;
    // Mettre le bouton d'edition 
    self.navigationItem.rightBarButtonItem = self.editButtonItem; 
    // On initialise le tableau à partir des employés de l'entreprise 
    _employesArray = [[NSMutableArray alloc] initWithArray:[_entreprise.employes allObjects]]; 
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(ajouterEmploye)];
    
    // espace flexible pour pousser le bouton add à droite
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:[NSArray arrayWithObjects:flexible, addButton, nil]];
    
    if (_entreprise.employes.count == 0) {
        [self ajouterEmploye];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) ajouterEmploye
{
    CreateEmployeTableViewController *c = [[CreateEmployeTableViewController alloc] initWithStyle:UITableViewStylePlain];
    c.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _employesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *NormalCellIdentifier = @"NormalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NormalCellIdentifier];
    }
    Employe *employe = (Employe*)[_employesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", employe.nom,employe.prenom];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ — %d ans", employe.sexe, [employe.age intValue]];
    return cell; 
} 

#pragma mark - Edition 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // On supprime l'employé pointé par la cellule choisie par l'utilisateur pour la suppression
        NSManagedObject *employeToDelete = [_employesArray objectAtIndex:indexPath.row];
        [_entreprise.managedObjectContext deleteObject:employeToDelete];
        // On met à jour le tableau, ainsi que la table view.
        [_employesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // On sauvegarde les changements 
        NSError *error = nil; 
        if (![_entreprise.managedObjectContext save:&error]) 
        { 
            // Gestion de l'erreur 
        } 
    }
} 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - CreateEmployeTableViewController delegate

- (void) createEmployeController:(CreateEmployeTableViewController*)controller didCreateNewEmploye:(Employe*)employe
{
    // on met la bonne entreprise
    employe.entreprise = _entreprise;
    // on sauve
    [_entreprise.managedObjectContext save:nil];
    
    [_employesArray addObject:employe];
    
    [self.tableView reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void) createEmployerControllerDidCancel:(CreateEmployeTableViewController*)controller
{
    [self dismissModalViewControllerAnimated:YES];   
}

@end
