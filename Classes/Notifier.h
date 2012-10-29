//
//  Notifier.h
//  CheckIn
//
//  Created by wolfert on 10/29/12.
//
//

#import <Foundation/Foundation.h>

@interface Notifier : NSObject


+(id) sharedNotifier;
-(void) notifyMessage:(NSString*) message;
-(void) popupMessage:(NSString*) message;
-(void) scheduledMessage:(NSString*) message;

@end