//
//  Geofencer.h
//  CheckIn
//
//  Created by wolfert on 10/19/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationUpdaterDelegate <NSObject>
@optional
-(void)locationUpdated:(NSString*) newLocation;

@end

@interface Geofencer : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *regionManager;
    BOOL isMonitoring;
}

+(id) sharedFencer;
-(void) locationUpdated;
-(void) startMonitoring;
-(void) stopMonitoring;
-(void) enteredRegion:(int) regionIndex;
-(void) exitedRegion:(int) regionIndex;

@property(nonatomic, strong) id<LocationUpdaterDelegate>  delegate;
@property(nonatomic, strong) NSMutableArray * locations;

@end