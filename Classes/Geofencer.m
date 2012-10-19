//
//  Geofencer.m
//  CheckIn
//
//  Created by wolfert on 10/19/12.
//
//

#import "Geofencer.h"

@implementation Geofencer

+ (id) sharedFencer
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id) init
{
    NSLog(@" - Geofencer init " );
    if (self) {
        // Override point for customization after application launch.
        // Create location manager
        if (!regionManager)
            regionManager = [[CLLocationManager alloc] init];
        regionManager.delegate = self;
    }
    return self;    
}


#pragma mark -
#pragma mark locationManager delegation

- (void) startMonitoring
{

    
    CLLocationCoordinate2D lunaLatLong = CLLocationCoordinate2DMake(51.919606, 4.456255);
    CLRegion *lunatech = [[CLRegion alloc]
                          initCircularRegionWithCenter:lunaLatLong
                          radius: 30.0
                          identifier:@"Lunatech Labs"];
    
    // Start monitoring for our CLRegion using best accuracy
    [regionManager startMonitoringForRegion:lunatech desiredAccuracy:kCLLocationAccuracyBest];
    NSLog(@" - Starting Region Monitoring ");    
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@" - Entered Region");
    NSLog(@" - Entered Region %@ \n Location %.06f %.06f",[region description], regionManager.location.coordinate.latitude,regionManager.location.coordinate.longitude );
    
    [self enteredRegion];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    //NSLog(@" - Exited Region %@", viewController.status.text);
    NSLog(@" - Exited Region viewController.status.text");
    NSLog(@" - Exited Region %@ \n Location %.06f %.06f",[region description], regionManager.location.coordinate.latitude,regionManager.location.coordinate.longitude );
    
    [self exitedRegion];
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@" - Region Monitoring Started\n%@ \n Location %.06f %.06f",[region description], regionManager.location.coordinate.latitude,regionManager.location.coordinate.longitude );
    
    if ([region containsCoordinate:regionManager.location.coordinate]) {
        NSLog(@" - Region Monitored Entered Region");
        [self enteredRegion];
    } else {
        NSLog(@" - Region Monitored Exited Region");
        [self exitedRegion];
    }
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"error");
    NSLog(@"%@",[error localizedDescription]);
}


#pragma mark -
#pragma mark Region code

- (void) enteredRegion
{
    
    NSString *username =  [[NSUserDefaults standardUserDefaults] stringForKey: @"email_preferences"];
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        UILocalNotification *reminder = [[UILocalNotification alloc] init];
        [reminder setFireDate:[NSDate date]];
        [reminder setTimeZone:[NSTimeZone localTimeZone]];
        [reminder setHasAction:YES];
        [reminder setAlertAction:@"Show"];
        [reminder setAlertBody:[NSString stringWithFormat:@" %@ is entering the Lunatech Office!", username] ];
        [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Show an alert or otherwise notify the user
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                            message:[NSString stringWithFormat:@" %@ is entering the Lunatech Office!", username]                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        });
    }
    
    
    NSURL *url = [ NSURL URLWithString:[ NSString stringWithFormat: @"http://198.101.196.161/checkin/%@", username ] ];
    
    NSURLRequest *request = [ NSURLRequest requestWithURL: url ];
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        [theConnection start];
    } else {
        // Inform the user that the connection failed.
        UILocalNotification *reminder = [[UILocalNotification alloc] init];
        [reminder setFireDate:[NSDate date]];
        [reminder setTimeZone:[NSTimeZone localTimeZone]];
        [reminder setHasAction:YES];
        [reminder setAlertAction:@"Show"];
        [reminder setAlertBody:@"Connection to server failed!"];
        [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
        
    }
    
    NSString *greeting = [[NSString alloc] initWithFormat:@"%@ is in the office", username];
    //[viewController updateStatusLabel:greeting];
    NSLog(@"%@",greeting);
}

- (void) exitedRegion
{
    NSString *username =  [[NSUserDefaults standardUserDefaults] stringForKey: @"email_preferences"];
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        UILocalNotification *reminder = [[UILocalNotification alloc] init];
        [reminder setFireDate:[NSDate date]];
        [reminder setTimeZone:[NSTimeZone localTimeZone]];
        [reminder setHasAction:YES];
        [reminder setAlertAction:@"Show"];
        [reminder setAlertBody:[NSString stringWithFormat:@" %@ is out of the Lunatech Office!", username] ];
        [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Show an alert or otherwise notify the user
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                            message:[NSString stringWithFormat:@" %@ is out of the Lunatech Office!", username]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        });
    }
    
    NSURL *url = [ NSURL URLWithString:[ NSString stringWithFormat: @"http://198.101.196.161/checkout/%@", username ] ];
    
    NSURLRequest *request = [ NSURLRequest requestWithURL: url ];
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        [theConnection start];
    } else {
        // Inform the user that the connection failed.
        UILocalNotification *reminder = [[UILocalNotification alloc] init];
        [reminder setFireDate:[NSDate date]];
        [reminder setTimeZone:[NSTimeZone localTimeZone]];
        [reminder setHasAction:YES];
        [reminder setAlertAction:@"Show"];
        [reminder setAlertBody:@"Connection to server failed!"];
        [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
        
    }
    
    
    NSString *greeting = [[NSString alloc] initWithFormat:@"%@ is out of the office", username];
    //[viewController updateStatusLabel:greeting];
    NSLog(@"%@",greeting);
}


@end