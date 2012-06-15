//
//  EntrepriseTableViewController.m
//  CoreData
//
//  Created by Marian Paul on 02/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "EntreprisesTableViewController.h"
#import "EmployesTableViewController.h"

#import "AppDelegate.h"
#import "Entreprise.h"

@interface EntreprisesTableViewController ()

@end

@implementation EntreprisesTableViewController

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
    self.title = @"Entreprises"; 
 
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(ajouterEntreprise)]; 
    self.navigationItem.rightBarButtonItem = _addButton; 
    
    _entrepriseArray = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entreprise" inManagedObjectContext:appDelegate.managedObjectContext]; 
    [request setEntity:entity]; 
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"nom" ascending:YES]; 
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil]; 
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil; 
    NSArray *fetchResults = [appDelegate.managedObjectContext executeFetchRequest:request error:&error]; 
    if (fetchResults == nil) {
        // Gestion de l'erreur 
    } 
    _entrepriseArray = [NSMutableArray arrayWithArray:fetchResults]; 
}

-(void) ajouterEntreprise 
{ 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entreprise" message:@"Ajouter une nouvelle entreprise" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Ajouter", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show]; 
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _entrepriseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Entreprise *entreprise = (Entreprise*)[_entrepriseArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = entreprise.nom; 
    return cell; 
} 

#pragma mark - Edition 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

        // On supprime l'entreprise pointée par la cellule choisie par l'utilisateur pour la suppression
        NSManagedObject *entrepriseToDelete = [_entrepriseArray objectAtIndex:indexPath.row];
        [appDelegate.managedObjectContext deleteObject:entrepriseToDelete];
        // On met à jour le tableau, ainsi que la table view.
        [_entrepriseArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // On sauvegarde les changements 
        NSError *error = nil; 
        if (![appDelegate.managedObjectContext save:&error]) 
        { 
            // Gestion de l'erreur 
        } 
    }
} 

- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{ 
    [super setEditing:editing animated:animated]; 
    // On désactive le bouton d'ajout si on est en mode édition     
    self.navigationItem.rightBarButtonItem.enabled = !editing; 
} 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    EmployesTableViewController *viewController = [[EmployesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // on passe au contrôleur l'entreprise sélectionnée 
    viewController.entreprise = [_entrepriseArray objectAtIndex:indexPath.row]; 
    [self.navigationController pushViewController:viewController animated:YES]; 
} 
#pragma mark - UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSString *entered = [alertView textFieldAtIndex:0].text;
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        // créer une nouvelle entreprise 
        Entreprise *entreprise = (Entreprise *)[NSEntityDescription insertNewObjectForEntityForName:@"Entreprise" inManagedObjectContext:appDelegate.managedObjectContext]; 
        
        // lui mettre le nom saisi
        entreprise.nom = entered; 
        
        // sauvegarde 
        NSError *error = nil; 
        if (![appDelegate.managedObjectContext save:&error]) {
            // Gérer l'erreur 
        } 
        
        // ajout d'une nouvelle entreprise dans le tableau
        [_entrepriseArray addObject:entreprise]; 
        // on trie 
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"nom" ascending:YES]; 
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil]; 
        [_entrepriseArray sortUsingDescriptors:sortDescriptors]; 

        // on anime l'insertion d'une nouvelle ligne 
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_entrepriseArray indexOfObject:entreprise] inSection:0]; 
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade]; 
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
