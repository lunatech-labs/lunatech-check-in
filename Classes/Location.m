//
//  Location.m
//  CheckIn
//
//  Created by wolfert on 11/1/12.
//
//

#import "Location.h"

@implementation Location

- (id) initWithIdentifier:(NSString*) idt longitude:(double) longitude latitude:(double) latitude andRadius:(double) radius
{
    if (self = [super init]) {
        _identifier = idt;
        _longitude = longitude;
        _latitude = latitude;
        _radius = radius;
    }
    return self;
}

- (CLRegion*) region
{
    if (!_region)
        _region = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(_latitude, _longitude) radius:_radius identifier:_identifier];
    return _region;
}

- (NSString*) identifier
{
    return _identifier;
}

@end