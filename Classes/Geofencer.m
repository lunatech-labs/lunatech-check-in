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
        isMonitoring = false;
    }
    return self;    
}

- (NSMutableArray*) locations
{
    if (!_locations)
        _locations = [[NSMutableArray alloc] initWithObjects:
                      [[Location alloc] initWithIdentifier:@"Lunatech Office" longitude:4.456255 latitude:51.919606 andRadius:30.0], nil];
    return _locations;
}

#pragma mark -
#pragma mark protocol methods

-(void)locationUpdated:(NSString*) newLocation {

    //check foor delegate using instances
    if([_delegate respondsToSelector:@selector(locationUpdated:)])
        [_delegate locationUpdated:newLocation];
}

#pragma mark -
#pragma mark locationManager delegation

- (void) startMonitoring
{
    if (!isMonitoring) {
        NSLog(@" - Starting Region Monitoring ");
        for (int i = 0; i < [self.locations count]; i++) {
            [regionManager startMonitoringForRegion:[[self.locations objectAtIndex:i] region] desiredAccuracy:kCLLocationAccuracyBest];
        }
        isMonitoring = YES;
    }
}

- (void) stopMonitoring
{
    if (isMonitoring) {
        NSLog(@" - Stopping Region Monitoring ");
        for (int i = 0; i < [_locations count]; i++) {
            [regionManager stopMonitoringForRegion:[[self.locations objectAtIndex:i] region]];
        }
        isMonitoring = NO;
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@" - Entered Region");
    NSLog(@" - Entered Region %@ \n Location %.06f %.06f",[region description], regionManager.location.coordinate.latitude,regionManager.location.coordinate.longitude );
    
    [self enteredRegion:0];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@" - Exited Region viewController.status.text");
    NSLog(@" - Exited Region %@ \n Location %.06f %.06f",[region description], regionManager.location.coordinate.latitude,regionManager.location.coordinate.longitude );
    
    [self exitedRegion:0];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@" - Region Monitoring Started\n%@ \n Location %.06f %.06f",[region description], regionManager.location.coordinate.latitude,regionManager.location.coordinate.longitude );
    
    if ([region containsCoordinate:regionManager.location.coordinate]) {
        NSLog(@" - Region Monitored Entered Region");
        [self enteredRegion:0];
    } else {
        NSLog(@" - Region Monitored Exited Region");
        [self exitedRegion:0];
    }
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    [self locationUpdated:[error localizedDescription]];
}


#pragma mark -
#pragma mark Region code

- (void) enteredRegion:(int)regionIndex
{
    
    NSString *username =  [[NSUserDefaults standardUserDefaults] stringForKey: @"email_preferences"];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[Notifier sharedNotifier] notifyMessage:[NSString stringWithFormat:@"You just entered %@", [[self.locations objectAtIndex:regionIndex] identifier]]];
    
    
    NSURL *url = [ NSURL URLWithString:kNetworkCheckInURL(username)];
    
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
        [[Notifier sharedNotifier] notifyMessage:[NSString stringWithFormat:@"Connection to server failed!"]];
    }
    
    [self locationUpdated:[NSString stringWithFormat:@"%@ is in the office", username]];
}

- (void) exitedRegion:(int)regionIndex
{
    NSString *username =  [[NSUserDefaults standardUserDefaults] stringForKey: @"email_preferences"];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [[Notifier sharedNotifier] notifyMessage:[NSString stringWithFormat:@"You just left %@", [[self.locations objectAtIndex:regionIndex] identifier]]];

    NSURL *url = [ NSURL URLWithString:kNetworkCheckOutURL(username)];
    
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
        [[Notifier sharedNotifier] notifyMessage:[NSString stringWithFormat:@"Connection to server failed!"]];

    }
    
    [self locationUpdated:[NSString stringWithFormat:@"%@ is out of the office", username]];
}


@end