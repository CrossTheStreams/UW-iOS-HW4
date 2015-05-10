//
//  AddTableViewController.h
//  UW_HW_04_arhautau
//
//  Created by Andrew Hautau on 5/7/15.
//  Copyright (c) 2015 Andrew Hautau. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddTableViewControllerDelegate <NSObject>

-(void) addBirthdayWithDate: (NSDate *) date AndWithName: (NSString*) name;

@end

@interface AddTableViewController : UITableViewController

@property (nonatomic, weak) id <AddTableViewControllerDelegate> delegate;

@end
