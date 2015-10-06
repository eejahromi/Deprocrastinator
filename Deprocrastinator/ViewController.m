//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Ehsan on 10/5/15.
//  Copyright © 2015 Ehsan Jahromi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource ,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *inputArray;
@property (strong, nonatomic) NSMutableArray *priorityArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputArray = [[NSMutableArray alloc]init];
    
    self.priorityArray = [[NSMutableArray alloc]init];
    //self.priorityArray = @[].mutableCopy;
    
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
    
    cell.textLabel.text = [self.inputArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.priorityArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
    cell.textLabel.textColor = [UIColor greenColor];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.inputArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }else if(editingStyle == UITableViewCellEditingStyleInsert){
        
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (IBAction)onAddButtonPressed:(UIButton *)sender {
    
    [self.inputArray addObject:self.inputTextField.text];
    [self.priorityArray addObject:[NSNumber numberWithInt:0]];
    [self.tableView reloadData];
}


- (IBAction)EditButtonPressed:(UIBarButtonItem *)sender {
    //UIBarButtonItem *editButton = (UIBarButtonItem *)sender;

    if (self.editing) {
        [sender setTitle:@"Edit"];
        [self.tableView setEditing:NO animated:YES];
        self.editing = NO;
        sender.style = UIBarButtonItemStylePlain;
        
    }else{
        [sender setTitle:@"Done"];
        self.editing = YES;
        [self.tableView setEditing:YES animated:YES];
        sender.style = UIBarButtonItemStyleDone;
        
    }
    
    [self.tableView reloadData];
}

- (IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (UISwipeGestureRecognizerDirectionRight) {
        int count = [[self.priorityArray objectAtIndex:indexPath.row]intValue];
        
        if (count == 0) {
            count++;
            
        }else if(count <= 3){
            count--;
        }
        
        switch (count) {
            case 0:
                cell.textLabel.textColor = [UIColor blackColor];
                break;
            case 1:
                cell.textLabel.textColor = [UIColor greenColor];
            case 2:
                cell.textLabel.textColor = [UIColor yellowColor];
            case 3:
                cell.textLabel.textColor = [UIColor redColor];
            default:
                break;
        }
        
        
        [self.priorityArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:count]];
    }
}





@end
