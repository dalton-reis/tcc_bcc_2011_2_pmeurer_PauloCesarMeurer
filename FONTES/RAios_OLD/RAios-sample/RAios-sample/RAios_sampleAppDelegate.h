//
//  RAios_sampleAppDelegate.h
//  RAios-sample
//
//  Created by Paulo Cesar Meurer on 11/7/11.
//  Copyright 2011 FURB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RAios_sampleViewController;

@interface RAios_sampleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet RAios_sampleViewController *viewController;

@end
