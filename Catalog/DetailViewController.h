//
//  DetailViewController.h
//  Catalog
//
//  Created by Bobby Koczon on 1/10/13.
//  Copyright (c) 2013 Bobby Koczon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
