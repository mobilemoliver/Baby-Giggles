//
//  BabyGigglesAppDelegate.h
//  BabyGiggles
//
//  Created by Mike Oliver on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyGigglesMainController.h"
#import "LocalyticsSession.h"

#define ENABLE_LOCALYTICS YES

@interface BabyGigglesAppDelegate : NSObject <UIApplicationDelegate> {
    BabyGigglesMainController *mainController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

/* The main UI controller of the app.
 */
@property (nonatomic, retain) BabyGigglesMainController *mainController;

@end
