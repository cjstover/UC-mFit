//
//  LocationHandler.m
//  MotionActivityDemo
//
//  Created by me on 9/27/14.
//  Copyright (c) 2014 me. All rights reserved.
//

#import "LocationHandler.h"
static LocationHandler *DefaultManager = nil;

@interface LocationHandler()

-(void)initiate;

@end

@implementation LocationHandler

+(id)getSharedInstance{
    if (!DefaultManager) {
        DefaultManager = [[self allocWithZone:NULL]init];
        [DefaultManager initiate];
    }
    NSLog(@"Shared instance");
    return DefaultManager;
}

-(void)initiate{
    NSLog(@"location manager init");
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
}

-(void)startUpdating{
    [locationManager startUpdatingLocation];
    NSLog(@"updating location");
}

-(void) stopUpdating{
    NSLog(@"STOPPING location updates");
    [locationManager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"GOT A NEW LOCATION!!! Inside location manager");
    if ([self.delegate respondsToSelector:@selector
         (didUpdateToLocation:fromLocation:)])
    {
        [self.delegate didUpdateToLocation:oldLocation
                              fromLocation:newLocation];
        
    }
}

@end