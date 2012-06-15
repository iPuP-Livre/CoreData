//
//  CreateEmployeTableViewController.m
//  CoreData
//
//  Created by Marian Paul on 02/04/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import "CreateEmployeTableViewController.h"
#import "AppDelegate.h"
#import "Employe.h"

@interface CreateEmployeTableViewController ()

@end

@implementation CreateEmployeTableViewController

@synthesize delegate = _delegate;

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

    // On charge les valeurs des labels précisants les noms des champs     
    _fieldLabels = [[NSArray alloc] initWithObjects:@"Nom :", @"Prénom :", @"Sexe :",@"Age :", nil]; 
    
    // bouton annuler
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton; 
    
    // bouton sauvegarder 
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sauver" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton; 
    
    // déclaration du dictionnaire temporaire 
    _tempValues = [[NSMutableDictionary alloc] init];
}

-(void)cancel:(id)sender
{ 
    [self.delegate createEmployerControllerDidCancel:self];
} 

-(void)save:(id)sender 
{ 
    // Si on est en train d'éditer un text field (on n'a pas appuyé sur la touche retour), alors on prend la valeur en cours que l'on sauvegarde dans le dictionnaire temporaire 
    if (_textFieldBeingEdited != nil) {
        NSNumber *tagAsNum= [NSNumber numberWithInt:_textFieldBeingEdited.tag]; 
        [_tempValues setObject:_textFieldBeingEdited.text forKey:tagAsNum]; 
    } 
    
    // On parcourt les valeurs du dictionnaire temporaire pour setter correctement l'employé 
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Employe *employe = (Employe *)[NSEntityDescription insertNewObjectForEntityForName:@"Employe" inManagedObjectContext:appDelegate.managedObjectContext]; 

    for (NSNumber *key in [_tempValues allKeys]) {
        switch ([key intValue]) {
            case kNameRowIndex: 
                employe.nom = [_tempValues objectForKey:key]; 
                break;
            case kFirstNameRowIndex: 
                employe.prenom = [_tempValues objectForKey:key];
                break;
            case kSexRowIndex: 
                employe.sexe = [_tempValues objectForKey:key];            
                break; 
            case kAgeIndex: 
                employe.age = [NSNumber numberWithInt:[[_tempValues objectForKey:key] intValue]]; 
                break; 
            default: 
            break; 
        } 
    }

    [self.delegate createEmployeController:self didCreateNewEmploye:employe]; 
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

// titre au dessus de la table view 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{ 
    return @"Décrire le nouvel employé"; 
} 
#pragma mark - Table Data Source Methods 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return kNumberOfEditableRows; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    static NSString *EmployeCellIdentifier = @"EmployeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EmployeCellIdentifier];
    if (cell == nil) {
        // construction de la cellule
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmployeCellIdentifier];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 95, 25)]; 
        label.textAlignment = UITextAlignmentRight;
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:label];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(110, 12, 180, 25)]; 
        textField.clearsOnBeginEditing = NO; 
        [textField setDelegate:self]; 
        [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit]; 
        [cell.contentView addSubview:textField]; 
    }
    
    NSUInteger row = [indexPath row];
    UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
    label.text = [_fieldLabels objectAtIndex:row];
    // on cherche le text field parmi les sous vues de la cell (label,textField, ...) 
    UITextField *textField = nil; 
    for (UIView *oneView in cell.contentView.subviews) { 
        if ([oneView isMemberOfClass:[UITextField class]]) 
            textField = (UITextField *)oneView; 
    } 
    
    NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row]; 
    switch (row) { 
        case kNameRowIndex: // Si le nom a déjà été renseigné, alors on le place 
            if ([[_tempValues allKeys] containsObject:rowAsNum]) 
                textField.text = [_tempValues objectForKey:rowAsNum]; 
            
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo]; 
            [textField setKeyboardType:UIKeyboardTypeDefault];             
            break; 
        case kFirstNameRowIndex: 
            if ([[_tempValues allKeys] containsObject:rowAsNum])                 
                textField.text = [_tempValues objectForKey:rowAsNum]; 
            
            
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo]; 
            [textField setKeyboardType:UIKeyboardTypeDefault];             
            break;
        case kAgeIndex: 
            if ([[_tempValues allKeys] containsObject:rowAsNum])             
                textField.text = [_tempValues objectForKey:rowAsNum]; 
             
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo]; 
            [textField setKeyboardType:UIKeyboardTypeNumberPad]; 
            break;
        case kSexRowIndex: 
            if ([[_tempValues allKeys] containsObject:rowAsNum]) 
                textField.text = [_tempValues objectForKey:rowAsNum];     
            
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setKeyboardType:UIKeyboardTypeDefault]; 
            break;
        default:
        break; 
    }
    
    if (_textFieldBeingEdited == textField) _textFieldBeingEdited = nil;
    textField.tag = row;
    
    return cell; 
} 
#pragma mark - Table Delegate Methods 
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return nil; 
} 

// Appelé lorsque l'on appuie sur la touche return du clavier 
- (void)textFieldDone:(id)sender { 
    // On cherche la cell qui contient le text field qui vient de finir d'être édité pour retrouver ensuite le numéro de la ligne correspondante 
    // Note : sender est ce textField 
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview]; 
    UITableView *table = (UITableView *)[cell superview]; 
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row]; 
    row++;
    // si on est à la fin, on retourne au début ! un row%kNumberOfEditableRowsferait également l'affaire 
    if (row >= kNumberOfEditableRows) 
        row = 0; 
    NSUInteger newIndex[] = {0, row}; 
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    // on cherche la cellule suivante ((row+1)%kNumberOfEditableRows) 
    UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:newPath]; 
    
    UITextField *nextField = nil; 
    for (UIView *oneView in nextCell.contentView.subviews) { 
        if ([oneView isMemberOfClass:[UITextField class]])
            nextField = (UITextField *)oneView; 
    } 
    // on affiche le clavier pour le prochain text field 
    [nextField becomeFirstResponder]; 
} 
#pragma mark - Text Field Delegate Methods 
- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    _textFieldBeingEdited = textField; 
} 

- (void)textFieldDidEndEditing:(UITextField *)textField 
{ 
    // On pourrait tester ici si l'âge est réel (< 60 par exemple) // De plus, un test pourrait être fait sur le sexe qui devrait être M ou F           
    NSNumber *tagAsNum = [[NSNumber alloc] initWithInt:textField.tag]; 
    [_tempValues setObject:textField.text forKey:tagAsNum]; 
    [textField setClearsOnBeginEditing:NO]; 
} 

@end
