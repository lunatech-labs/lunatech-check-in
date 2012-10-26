//
//  com_lunatechViewController.h
//  HelloWorld2
//
//  Created by Nicolas Leroux on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>




@interface ViewController : UIViewController <UITextFieldDelegate, LocationUpdaterDelegate>{
    NSString *isCheckin;
}

@property (retain, nonatomic) IBOutlet UITextField * textField;
@property (retain, nonatomic) IBOutlet UILabel * status;
@property (copy, nonatomic) NSString * username;


- (IBAction)changeGreetings:(id)sender;
- (IBAction)reloadLocationService:(id)sender;
- (void) updateStatusLabel:(NSString *)parameter;

@end
