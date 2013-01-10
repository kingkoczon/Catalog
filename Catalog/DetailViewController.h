//
//  DetailViewController.h
//  Catalog
//
//  Created by Bobby Koczon on 1/10/13.
//  Copyright (c) 2013 Bobby Koczon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (strong, nonatomic) NSString *resultsLabelString;

@end
