//
//  ViewController.h
//  UW_HW_04_arhautau
//
//  Created by Andrew Hautau on 5/7/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTableViewController.h"

@interface ListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, AddTableViewControllerDelegate>

// NSArray of NSDictionaries with keys: @"days", @"name", @"date"
@property (strong, nonatomic) NSArray *birthdays;

@end

