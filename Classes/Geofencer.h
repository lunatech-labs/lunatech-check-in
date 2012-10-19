//
//  Geofencer.h
//  CheckIn
//
//  Created by wolfert on 10/19/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Geofencer : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *regionManager;
}

+(id) sharedFencer;
-(void) startMonitoring;
-(void) enteredRegion;
-(void) exitedRegion;

@end
