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
    return 2;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@",indexPath);
    static NSString *cellID= @"BirthdayCell";

    BirthdayCell *cell = [self.tableView dequeueReusableCellWithIdentifier: cellID];
    
    if (cell == nil) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil];
        cell = (BirthdayCell *) [nibObjects firstObject];
        [[cell nameLabel] setText:@"foo"];
        
        NSLog(@"%@",cell.nameLabel);
    }
    
    
    return cell;
}

@end
