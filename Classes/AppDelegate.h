//
//  com_lunatechAppDelegate.h
//  HelloWorld2
//
//  Created by Nicolas Leroux on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    ViewController *viewController;
    
}

@property (nonatomic, strong) IBOutlet ViewController *viewController;

@end
