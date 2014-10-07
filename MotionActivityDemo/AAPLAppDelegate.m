/*
Abstract:

     Default app delegate implementation.
*/

#import "AAPLAppDelegate.h"
#import "INTULocationManager.h"

@implementation AAPLAppDelegate

@synthesize locationManager=_locationManager;
@synthesize motionManager=_motionManager;
@synthesize locMgr;

NSTimer* myTimer;

double updateInterval = 0.2;

unsigned long int accelCount;
unsigned long int rotationCount;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%ld",accelCount);
    [self createFile:@"motion.txt"];
    [self createFile:@"location.txt"];
    [self createFile:@"rotation.txt"];
    myTimer = [NSTimer scheduledTimerWithTimeInterval: 600.0 target: self selector: @selector(timerFired:) userInfo: nil repeats: YES];
    [self currentLocation];
    
    //start the motion manager and set intervals
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = updateInterval;
    self.motionManager.gyroUpdateInterval = updateInterval;
    
    //block that starts accelerometer updates and sends to a handler
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self recordAccelerometerData:accelerometerData.acceleration];
                                                 if(error){NSLog(@"%@", error);}
                                             }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                        withHandler:^(CMGyroData *gyroData, NSError *error) {
                                [self outputRotationData:gyroData.rotationRate];
                        }];
    
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
}

-(void)currentLocation{
    locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyBlock
        timeout:12.0
        delayUntilAuthorized:YES  // This parameter is optional, defaults to NO if omitted
        block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
            if (status == INTULocationStatusSuccess) {
            // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
            // currentLocation contains the device's current location.
                [self writeLocation:currentLocation];
            }
            else if (status == INTULocationStatusTimedOut) {
                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                // However, currentLocation contains the best location available (if any) as of right now,
                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                NSLog(@"TIMEOUT %ld", status);
                [self writeToTextFile:@"Location Service Timeout" toFileNamed:@"location.txt"];
            }
            else {
                // An error occurred, more info is available by looking at the specific status returned.
                NSLog(@"ERROR %ld", status);
                NSString* errString = [NSString stringWithFormat:@"ERROR in location service. %ld", status];
                [self writeToTextFile:errString toFileNamed:@"location.txt"];
            }
    }];
}

-(void)recordAccelerometerData:(CMAcceleration)acceleration{
    NSString* time = [self getDateAsString];
    NSString* data = [NSString stringWithFormat:@"%@ %.3fx,%.3fy,%.3fz\r\n", time, acceleration.x, acceleration.y, acceleration.z];
    [self writeToTextFile:data toFileNamed:@"motion.txt"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self currentLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self recordAccelerometerData:accelerometerData.acceleration];
                                                 if(error){NSLog(@"%@", error);}
                                             }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
    NSLog(@"HEY I'm in the background! Hopefully this works...");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) timerFired:(NSTimer*) t{
    NSLog(@"TimerFired");
    [self currentLocation];
}


-(void) writeToTextFile:(NSString*)content toFileNamed:(NSString*)fyleName{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fyleName];
    //save content to the documents directory
    NSFileHandle* fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}

-(void)writeLocation:(CLLocation*)location{//@"The answer is %@", self.answer
    NSString* loc = [NSString stringWithFormat:@"currentLocation: %@\r\n", location];
    [self writeToTextFile:loc toFileNamed:@"location.txt"];
}

-(void)outputRotationData:(CMRotationRate)rotation{
    NSString* time = [self getDateAsString];
    NSString* data = [NSString stringWithFormat:@"%@ %.3fx,%.3fy,%.3fz\r\n", time, rotation.x, rotation.y, rotation.z];
    [self writeToTextFile:data toFileNamed:@"rotation.txt"];
}

-(NSString*)getDateAsString{
    
    NSDateFormatter *formatter;
    NSString *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

//This also writes to the file.
-(void)createFile:(NSString *)fileName
{
    //verify that the file was created by writing to the file
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    //create file if it doesn't exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:dataFile])
        [[NSFileManager defaultManager] createFileAtPath:dataFile contents:nil attributes:nil];
}


@end
