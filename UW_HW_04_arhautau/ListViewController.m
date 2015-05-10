//
//  ViewController.m
//  UW_HW_04_arhautau
//
//  Created by Andrew Hautau on 5/7/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import "ListViewController.h"
#import "AddTableViewController.h"
#import "BirthdayCell.h"

@interface ListViewController ()


@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDataSource: self];
    [self.tableView setDelegate:self];
    
    [self prepopulateBirthdays];
    
    [self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonTapped:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nav = [sb instantiateViewControllerWithIdentifier:@"AddNavController"];
    AddTableViewController *addvc = [sb instantiateViewControllerWithIdentifier:@"AddTableViewController"];
    [addvc setDelegate: self];
    
    [nav setViewControllers: @[addvc]];
    
    [self presentViewController: nav
                       animated: YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[self birthdays] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID= @"BirthdayCell";

    BirthdayCell *cell = [self.tableView dequeueReusableCellWithIdentifier: cellID];
    
    if (cell == nil) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil];
        cell = (BirthdayCell *) [nibObjects firstObject];
        
        NSDictionary *birthday = [[self birthdays] objectAtIndex: [indexPath row]];
        
        [[cell nameLabel] setText: [birthday valueForKey:@"name"]];
        [[cell dateLabel] setText: [birthday valueForKey:@"date"]];
        [[cell daysLabel] setText: [birthday valueForKey:@"days"]];
    }
    
    return cell;
}

-(void) prepopulateBirthdays {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterMediumStyle];
    [formatter setDateFormat: @"dd-MM-yyyy"];
    NSString *originalRelease = @"25-05-1975";
    NSDate *starWarsDate = [formatter dateFromString: originalRelease];
    
    NSDictionary *firstBirthday = [self birthdayDictionaryWithDate: starWarsDate AndName:@"Darth Vader"];
    NSDictionary *secondBirthday = [self birthdayDictionaryWithDate: starWarsDate AndName:@"Darth Vader"];
    
    [self setBirthdays: @[firstBirthday, secondBirthday]];
}


-(void) addBirthdayWithDate:(NSDate *)date AndWithName:(NSString *)name {
    NSDictionary *birthday = [self birthdayDictionaryWithDate: date AndName: name];
    [self setBirthdays: [self.birthdays arrayByAddingObject: birthday]];
    [self.tableView reloadData];
}

-(NSDictionary*) birthdayDictionaryWithDate:(NSDate*)date AndName:(NSString*)name {
    NSString *daysString = [self daysTillNextBirthdayWithDate: date];
    NSString *dateString = [self formattedBirthdayWithDate: date];
    
    
    NSDictionary *dict = @{ @"days": daysString,
                            @"date": dateString,
                            @"name": name
                            };
    
    return dict;
}

-(NSString*) daysTillNextBirthdayWithDate: (NSDate*) date {
    // date String
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    // get date day and month
    [formatter setDateFormat: @"dd-MM"];
    NSString *dateDayAndMonth = [formatter stringFromDate:date];
    
    // get today's date set at midnight
    [formatter setDateFormat: @"dd-MM-yyyy"];
    NSString *todayString = [formatter stringFromDate: [NSDate date]];
    NSDate *today = [formatter dateFromString:todayString];
    
    [formatter setDateFormat: @"yyyy"];
    NSString *todayYear = [formatter stringFromDate: today];
    
    // date with this year
    [formatter setDateFormat: @"dd-MM-yyyy"];
    NSDate *dateWithCurrentYear = [formatter dateFromString: [[dateDayAndMonth stringByAppendingString:@"-"] stringByAppendingString:todayYear]];
    
    NSDate *nextBirthday = dateWithCurrentYear;
    
    if ([today compare:dateWithCurrentYear] == NSOrderedDescending) {
        // the birthday has already happened this year.
        // bump it up to next year
        int nextYear = [todayYear integerValue] + 1;
        NSString *nextYearString = [NSString stringWithFormat:@"%d", nextYear];
        NSDate *dateWithNextYear = [formatter dateFromString: [[dateDayAndMonth stringByAppendingString:@"-"] stringByAppendingString:nextYearString]];
        nextBirthday = dateWithNextYear;
        
    }
    
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [sysCalendar components: NSCalendarUnitDay fromDate: today  toDate: nextBirthday  options:0];
    
    NSUInteger day = [dateComponents day];
    NSString *daysString;
    
    if (day == 0) {
        daysString = @"Today";
    } else {
        daysString = [NSString stringWithFormat:@"%i days", day];
    }

    return daysString;
}

-(NSString*) formattedBirthdayWithDate: (NSDate*) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    return [formatter stringFromDate: date];
}

@end
