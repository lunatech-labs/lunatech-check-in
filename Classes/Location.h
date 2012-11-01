//
//  Location.h
//  CheckIn
//
//  Created by wolfert on 11/1/12.
//
//

#import <Foundation/Foundation.h>

@interface Location : NSObject {
    NSString * _identifier;
    double _latitude;
    double _longitude;
    double _radius;
}

@property (nonatomic, strong) CLRegion * region;

- (id) initWithIdentifier:(NSString*) idt longitude:(double) longitude latitude:(double) latitude andRadius:(double) radius;
- (NSString*) identifier;

@end
