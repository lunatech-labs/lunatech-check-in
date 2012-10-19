//
//  com_lunatechAppDelegate.m
//  HelloWorld2
//
//  Created by Nicolas Leroux on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Create location manager
    if (!regionManager)
        regionManager = [[CLLocationManager alloc] init];

    regionManager.delegate = self;
   
    CLLocationCoordinate2D lunaLatLong = CLLocationCoordinate2DMake(51.919606, 4.456255);
    CLRegion *lunatech = [[CLRegion alloc]
                          initCircularRegionWithCenter:lunaLatLong
                          radius: 30.0
                          identifier:@"Lunatech Labs"];
    
    // Start monitoring for our CLRegion using best accuracy
    [regionManager startMonitoringForRegion:lunatech desiredAccuracy:kCLLocationAccuracyBest];
    NSLog(@" - Starting Region Monitoring " );
    if (!viewController) {
        viewController = (ViewController*) self.window.rootViewController;
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // if we don't have any subviews on the main window
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@" - Entered Region");
    NSLog(@" - Entered Region %@ \n Location %.06f %.06f",[region description], regionManager.location.coordinate.latitude,regionManager.location.coordinate.longitude );
    
    [self enteredRegion];
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@" - Exited Region %@", viewController.status.text);
    NSLog(@" - Exited Region %@ \n Location %.06f %.06f",[region description], regionManager.location.coordinate.latitude,regionManager.location.coordinate.longitude );
    
    [self exitedRegion];
  
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@" - Region Monitoring Started\n%@ \n Location %.06f %.06f",[region description], regionManager.location.coordinate.latitude,regionManager.location.coordinate.longitude );
    
    if ([region containsCoordinate:regionManager.location.coordinate]) {
        NSLog(@" - Region Monitored Entered Region");
        [self enteredRegion];
    } else {
        NSLog(@" - Region Monitored Exited Region");
        [self exitedRegion];
    }
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"error");
    NSLog(@"%@",[error localizedDescription]);
}


- (void) enteredRegion {
    
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
    [viewController updateStatusLabel:greeting];
    
}

- (void) exitedRegion {
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
    [viewController updateStatusLabel:greeting];

}

@end
