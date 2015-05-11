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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark IBActions

- (IBAction)addButtonTapped:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nav = [sb instantiateViewControllerWithIdentifier:@"AddNavController"];
    AddTableViewController *addvc = [sb instantiateViewControllerWithIdentifier:@"AddTableViewController"];
    [addvc setDelegate: self];
    
    [nav setViewControllers: @[addvc]];
    
    [self presentViewController: nav
                       animated: YES completion:nil];
}

# pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self birthdays] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellID= @"BirthdayCell";

    BirthdayCell *cell = [self.tableView dequeueReusableCellWithIdentifier: cellID];
    
    if (cell == nil) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil];
        cell = (BirthdayCell *) [nibObjects firstObject];
    }
    
    NSDictionary *birthday = [[self birthsdaysAscending] objectAtIndex: [indexPath row]];
    
    [[cell nameLabel] setText: [birthday valueForKey:@"name"]];
    [[cell dateLabel] setText: [birthday valueForKey:@"date"]];
    [[cell daysLabel] setText: [birthday valueForKey:@"days"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

# pragma mark Deleting rows

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *ascendingBirthdays = [NSMutableArray arrayWithArray: [self birthsdaysAscending]];
        NSUInteger row = [indexPath row];
        NSLog(@"foo");
        [ascendingBirthdays removeObjectAtIndex: row];
        [self setBirthdays: ascendingBirthdays];
        [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        
    }
}

# pragma mark Inserting rows

-(void) addBirthdayWithDate:(NSDate *)date AndWithName:(NSString *)name {
    NSDictionary *birthday = [self birthdayDictionaryWithDate: date AndName: name];
    
    [self setBirthdays: [self.birthdays arrayByAddingObject: birthday]];
    // insert row
    NSUInteger row = [[self birthsdaysAscending] indexOfObject: birthday];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
    
    [self.tableView insertRowsAtIndexPaths: @[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

# pragma mark Prepopulating rows

-(void) prepopulateBirthdays {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle: NSDateFormatterMediumStyle];
    
    [formatter setDateFormat: @"dd-MM-yyyy"];
    NSString *originalRelease = @"25-05-1975";
    NSString *lucasBirthday = @"14-05-1944";
    NSDate *starWarsDate = [formatter dateFromString: originalRelease];
    NSDate *lucasBirthdayDate = [formatter dateFromString: lucasBirthday];
    
    NSDictionary *firstBirthday = [self birthdayDictionaryWithDate: starWarsDate AndName:@"Darth Vader"];
    NSDictionary *secondBirthday = [self birthdayDictionaryWithDate: lucasBirthdayDate AndName:@"George Lucas"];
    [self setBirthdays: @[firstBirthday, secondBirthday]];
    
    NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *secondRow = [NSIndexPath indexPathForRow:0 inSection:0];

    [self.tableView insertRowsAtIndexPaths: @[firstRow, secondRow] withRowAnimation:UITableViewRowAnimationLeft];
}

# pragma mark Ascending birthdays

-(NSArray*) birthsdaysAscending {
    NSArray *birthdays = [self.birthdays sortedArrayWithOptions: NSSortConcurrent usingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSUInteger days1 = [[obj1 valueForKey: @"days"] integerValue];
        NSUInteger days2 = [[obj2 valueForKey: @"days"] integerValue];
        BOOL ascending = days2 < days1;
        return ascending;
    }];
    return birthdays;
}

# pragma mark Generating birthday NSDictionaries

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

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    // get date day and month
    [formatter setDateFormat: @"dd-MM"];
    NSString *dateDayAndMonth = [formatter stringFromDate:date];
    
    // get today's date set at 12AM
    [formatter setDateFormat: @"dd-MM-yyyy"];
    NSString *todayString = [formatter stringFromDate: [NSDate date]];
    NSDate *today = [formatter dateFromString:todayString];
    
    // get today's year
    [formatter setDateFormat: @"yyyy"];
    NSString *todayYear = [formatter stringFromDate: today];
    
    // date with today's year
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
