//
//  Notifier.m
//  CheckIn
//
//  Created by wolfert on 10/29/12.
//
//

#import "Notifier.h"

#define kNotificationSoundDefault @"sound.caf"

@implementation Notifier

+ (id) sharedNotifier
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (void) notifyMessage:(NSString*) message {
    UILocalNotification *reminder = [[UILocalNotification alloc] init];
    [reminder setFireDate:[NSDate date]];
    [reminder setTimeZone:[NSTimeZone localTimeZone]];
    [reminder setHasAction:YES];
    [reminder setSoundName:kNotificationSoundDefault];
    [reminder setAlertAction:@"Show"];
    [reminder setAlertBody:message];
    [[UIApplication sharedApplication] scheduleLocalNotification:reminder];
}

- (void) popupMessage:(NSString*) message {    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

@end
