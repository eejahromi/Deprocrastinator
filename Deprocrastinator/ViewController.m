//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Ehsan on 10/5/15.
//  Copyright © 2015 Ehsan Jahromi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource ,UITableViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *inputArray;
@property (strong, nonatomic) NSMutableArray *priorityArray;
@property (strong, nonatomic) NSMutableArray *checkArray;

@property (strong, nonatomic) NSArray *colorArray;

@property BOOL isEditingNow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputArray = [[NSMutableArray alloc]init];
    
    self.priorityArray = [[NSMutableArray alloc]init];

    self.checkArray = [[NSMutableArray alloc]init];
    
    //self.colorArray = [[NSMutableArray alloc]init];
    self.colorArray = [[NSArray alloc] initWithObjects:[UIColor blackColor],[UIColor greenColor],[UIColor yellowColor],[UIColor redColor], nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.inputArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDetected:)];
        [swipeRightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:swipeRightRecognizer];

    cell.textLabel.text = [self.inputArray objectAtIndex:indexPath.row];
    int count = [[self.priorityArray objectAtIndex:indexPath.row]intValue];
    cell.textLabel.textColor = self.colorArray[count];

    if (![self.checkArray objectAtIndex:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else{
        cell.accessoryType =UITableViewCellAccessoryNone;
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.priorityArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
   // cell.textLabel.textColor = [UIColor greenColor];

    if (![self.checkArray objectAtIndex:indexPath.row]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.checkArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
    } else{
        cell.accessoryType =UITableViewCellAccessoryNone;
        [self.checkArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
    }

}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                            message:@"Are you sure you want to delete this item?"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deleteButton = [UIAlertAction actionWithTitle:@"Delete"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self.inputArray removeObjectAtIndex:indexPath.row];
                                                           [self.tableView reloadData];
                                                       }];
        
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        [controller addAction:deleteButton];
        [controller addAction:cancelButton];
        
        [self presentViewController:controller animated:YES completion:nil];
        
        
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{

    NSString *movingString = [self.inputArray objectAtIndex:sourceIndexPath.row];
    NSString *priorityItem = [self.priorityArray objectAtIndex:sourceIndexPath.row];

    // re-order items in the to do list
    [self.inputArray removeObjectAtIndex:sourceIndexPath.row];
    [self.inputArray insertObject:movingString atIndex:destinationIndexPath.row];

    // re-order corresponding priorities
    [self.priorityArray removeObjectAtIndex:sourceIndexPath.row];
    [self.priorityArray insertObject:priorityItem atIndex:destinationIndexPath.row];
    [self.tableView reloadData];

}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (IBAction)onAddButtonPressed:(UIButton *)sender {
    
    [self.inputArray addObject:self.inputTextField.text];
    [self.priorityArray addObject:[NSNumber numberWithInt:0]];
    [self.checkArray addObject:[NSNumber numberWithBool:NO]];
    [self.tableView reloadData];
}


- (IBAction)EditButtonPressed:(UIBarButtonItem *)sender {
    //UIBarButtonItem *editButton = (UIBarButtonItem *)sender;

    if ([sender.title isEqual:@"Edit"]) {
        sender.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
        self.isEditingNow = YES;
    }else{
        sender.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
        self.isEditingNow = NO;
    }
}

- (void)swipeDetected:(UISwipeGestureRecognizer *)sender {

        if (sender.state == UIGestureRecognizerStateEnded) {
            CGPoint point = [sender locationInView:self.tableView];
            NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
            UITableViewCell *swipeRigntCell = [self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"Swipe detected");


            int count = [[self.priorityArray objectAtIndex:indexPath.row]intValue];

            NSLog(@"Priority %i",count);

        if((count >= 0) && (count < 3)){
            count++;
        } else if(count == 3){
            count=0;
        }

        NSLog(@"Priority %i",count);


        swipeRigntCell.textLabel.textColor = self.colorArray[count];
        
        [self.priorityArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:count]];

        }

    [self.tableView reloadData];
}


@end
