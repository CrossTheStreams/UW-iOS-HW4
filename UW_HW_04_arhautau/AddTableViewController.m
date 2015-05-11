//
//  AddTableViewController.m
//  UW_HW_04_arhautau
//
//  Created by Andrew Hautau on 5/7/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "AddTableViewController.h"
#import "ListViewController.h"

@interface AddTableViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *birthdayField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation AddTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupDatePicker];
    [self updateBirthdayField];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateBirthdayField {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterLongStyle];
    [self.birthdayField setText: [formatter stringFromDate: [self.datePicker date]]];
}

-(ListViewController*) listViewController {
    return (ListViewController *) [[self navigationController] presentingViewController];
}

# pragma mark Setup UIDatePicker

-(void) setupDatePicker {
    [self.datePicker setDatePickerMode: UIDatePickerModeDate];
    [self.datePicker setMaximumDate: [NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterMediumStyle];
    [formatter setDateFormat: @"yyyy"];
    
    NSUInteger previousYear = [[formatter stringFromDate: [NSDate date]] integerValue] - 1;
    [formatter setDateFormat: @"dd-MM-yyyy"];
    
    NSDate *firstOfJanuaryOfPreviousYear = [formatter dateFromString: [NSString stringWithFormat: @"01-01-%lu", (unsigned long)previousYear]];
    
    [self.datePicker setDate: firstOfJanuaryOfPreviousYear];
}

# pragma mark IBActions

- (IBAction)dateValueChanged:(id)sender {
    [self updateBirthdayField];
}

- (IBAction)tappedCancel:(id)sender {
    ListViewController *listVC = [self listViewController];
    [listVC dismissViewControllerAnimated:YES completion:^{
        // reset date information here
    }];
}

- (IBAction)tappedDone:(id)sender {
    ListViewController *listVC = [self listViewController];
    [listVC dismissViewControllerAnimated:YES completion:^{
        NSDate *date = [self.datePicker date];
        NSString *name = [[self nameField] text];
        [self.delegate addBirthdayWithDate: date AndWithName: name];
    }];
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
