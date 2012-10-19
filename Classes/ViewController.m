//
//  com_lunatechViewController.m
//  HelloWorld2
//
//  Created by Nicolas Leroux on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize textField = _textField;
@synthesize status = _status;
@synthesize username = _username;

NSString *isCheckin;

- (void)loadView
{
     [super loadView];
     self.username = [[NSUserDefaults standardUserDefaults] stringForKey: @"email_preferences"];
     self.textField.text = [[NSUserDefaults standardUserDefaults] stringForKey: @"email_preferences"];
     [self updateStatusLabel: isCheckin];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)changeGreetings:(id)sender {
    NSString *name = self.username;
    if ([name length] == 0) {
        name = @"Unknown user ";
    }
    // Save our user
    [[NSUserDefaults standardUserDefaults] setObject: name forKey:@"email_preferences"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.username = name;
    self.textField.text = name;
}

- (void) updateStatusLabel:(NSString *)parameter {
    
    NSLog(@"updateStatusLabel: %@", parameter);
    self.status.text = parameter;
    isCheckin = parameter;
    [self.view setNeedsDisplay];//edit
}


@end
