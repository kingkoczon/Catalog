//
//  MasterViewController.m
//  Catalog
//
//  Created by Bobby Koczon on 1/10/13.
//  Copyright (c) 2013 Bobby Koczon. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "TFHpple.h"
#import "Results.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

-(NSString *)fkStringByEscapingURIComponent:(NSString *)stringWithSpecialChaarcters {
	return [(__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
																				  (__bridge CFStringRef)stringWithSpecialChaarcters,
																				  NULL,
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8)
			stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

-(NSString *)fkStringByUnescapingURIComponent:(NSString *)stringWithPercentEscapes {
	return [[stringWithPercentEscapes stringByReplacingOccurrencesOfString:@"+" withString:@" "]
			stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


-(NSString *)fkURLQueryString:(NSDictionary *)parameterDictionary {
    NSMutableArray *outParameters = [[NSMutableArray alloc] init];
    for(id key in [parameterDictionary keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        return ([key isKindOfClass:[NSString class]] || [key respondsToSelector:@selector(stringValue)])
        && ([obj isKindOfClass:[NSString class]] || [obj respondsToSelector:@selector(stringValue)]);
    }]){
        id value = [parameterDictionary objectForKey:key];
        NSString *pName = [key isKindOfClass:[NSString class]]?key:[key stringValue];
        NSString *pValue = [value isKindOfClass:[NSString class]]?value:[value stringValue];
        [outParameters addObject:[NSString stringWithFormat:@"%@=%@",
                                  [self fkStringByEscapingURIComponent:pName],
                                  [self fkStringByEscapingURIComponent:pValue]]];
    }
    return [outParameters componentsJoinedByString:@"&"];
}

-(void)loadResults:(NSString *)title {
    
    NSString *urlString = [@"http://ecatalog.coronado.lib.ca.us/search~S0/?searchtype=t&searcharg=" stringByAppendingString:[self fkStringByEscapingURIComponent:title]];
    
    NSURL *resultsUrl = [NSURL URLWithString:urlString];
    
    NSData *resultsHtmlData = [NSData dataWithContentsOfURL:resultsUrl];
    
    TFHpple *resultsParser = [TFHpple hppleWithHTMLData:resultsHtmlData];
    
    NSString *resultsXpathQueryString = @"//td[@class='browseEntryData']/a[2]";
    NSArray *resultsNodes = [resultsParser searchWithXPathQuery:resultsXpathQueryString];
    
    NSMutableArray *newResults = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in resultsNodes) {
        
        Results *result = [[Results alloc] init];
        [newResults addObject:result];
        
        result.title = [[element firstChild] content];
    }
    
    _objects = newResults;
    [self.tableView reloadData];
}

- (void)loadResults {
    
    NSURL *resultsUrl = [NSURL URLWithString:@"http://ecatalog.coronado.lib.ca.us/search~S0/?searchtype=t&searcharg=finding+nemo&sortdropdown=-&SORT=D&extended=0&SUBMIT=Search&searchlimits=&searchorigarg=tfinding+nemo"];
    NSData *resultsHtmlData = [NSData dataWithContentsOfURL:resultsUrl];
    
    TFHpple *resultsParser = [TFHpple hppleWithHTMLData:resultsHtmlData];
    
    NSString *resultsXpathQueryString = @"//td[@class='browseEntryData']/a[2]";
    NSArray *resultsNodes = [resultsParser searchWithXPathQuery:resultsXpathQueryString];
    
    NSMutableArray *newResults = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in resultsNodes) {
        
        Results *result = [[Results alloc] init];
        [newResults addObject:result];
        
        result.title = [[element firstChild] content];
    }
    
    _objects = newResults;
    [self.tableView reloadData];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadResults];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    Results *thisResult = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = thisResult.title;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"showObjectDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.practiceName = [_objects objectAtIndex:indexPath.row];
    }
}

@end
