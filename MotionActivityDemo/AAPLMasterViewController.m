/*
Abstract:

     Main view for Motion Activity app.  This shows a list of the 7 days from which
     user activity and step counting data is available.
*/

@import CoreMotion;

#import "AAPLMasterViewController.h"
#import "AAPLMotionActivityQuery.h"
#import "AAPLActivityDataManager.h"
#import "AAPLDetailViewController.h"
#import "INTULocationManager.h"

@interface AAPLMasterViewController () {
	NSMutableArray *_objects;
	NSMutableArray *_stepCounts;
	AAPLActivityDataManager *_dataManager;
}
@end

@implementation AAPLMasterViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    //[[LocationHandler getSharedInstance]setDelegate:self];
    //[[LocationHandler getSharedInstance]startUpdating];
	if (!_objects) {
		_objects = [[NSMutableArray alloc] init];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDays) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"%f lat, %f long", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    //[latitudeLabel setText:[NSString stringWithFormat:@"Latitude: %f",newLocation.coordinate.latitude]];
    //[longitudeLabel setText:[NSString stringWithFormat:@"Longitude: %f",newLocation.coordinate.longitude]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[self refreshDays];
}

- (void)refreshDays
{
	if (!_dataManager) {
		_dataManager = [[AAPLActivityDataManager alloc] init];
	}
	if ([AAPLActivityDataManager checkAvailability]) {
		[_dataManager checkAuthorization:^(BOOL authorized) {
			dispatch_async(dispatch_get_main_queue(), ^{
				if (authorized) {
					NSDate *date = [NSDate date];
					[_objects removeAllObjects];
					for (int i = 0; i < 7; ++i){
						AAPLMotionActivityQuery *query = [AAPLMotionActivityQuery queryStartingFromDate:date offsetByDay:-i];
						[_objects addObject:query];
						[self.tableView reloadData];
					}
				} else {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"M7 not authorized"
						message:@"Please enable Motion Activity for this application." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
					[alert show];
				}
			});
			// We only need the data manager to check for authorization.
			_dataManager = nil;
		}];

	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"M7 not available"
			message:@"No activity or step counting is available" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
	}
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	 return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	 return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	 NSDate *object = _objects[indexPath.row];
	 cell.textLabel.text = [object description];
	 return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	 return NO;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	 if ([[segue identifier] isEqualToString:@"showDetail"]) {
		  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		  NSDate *object = _objects[indexPath.row];
		  [[segue destinationViewController] setDetailItem:object];
	 }
}

@end
