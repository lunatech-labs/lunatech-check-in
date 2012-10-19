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
    id<LocationUpdaterDelegate> delegate;    
}

+(id) sharedFencer;
-(void) locationUpdated;
-(void) startMonitoring;
-(void) enteredRegion;
-(void) exitedRegion;

@property(nonatomic, strong)id delegate;

@end