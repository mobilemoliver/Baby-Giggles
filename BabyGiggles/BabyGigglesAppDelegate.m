//
//  BabyGigglesAppDelegate.m
//  BabyGiggles
//
//  Created by Mike Oliver on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BabyGigglesAppDelegate.h"
#import "ThirdPartyKeys.h"

@implementation BabyGigglesAppDelegate


@synthesize window=_window;
@synthesize mainController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (ENABLE_LOCALYTICS)
        [[LocalyticsSession sharedLocalyticsSession] startSession:LOCALYTICS_KEY];
    
    // Add the main UI controller to the window.
    BabyGigglesMainController *newMainController = [[BabyGigglesMainController alloc] initWithNibName:@"BabyGigglesMainController" bundle:nil];
    self.mainController = newMainController;
    [self.window addSubview: self.mainController.view];
    [newMainController release];
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Attempt to resume the existing session or create a new one.
    
    if (ENABLE_LOCALYTICS)
    {
        [[LocalyticsSession sharedLocalyticsSession] resume];
        [[LocalyticsSession sharedLocalyticsSession] upload];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // close the session before entering the background

    if (ENABLE_LOCALYTICS)
    {
        [[LocalyticsSession sharedLocalyticsSession] close];
        [[LocalyticsSession sharedLocalyticsSession] upload];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Close Localytics Session in the case where the OS terminates the app

    if (ENABLE_LOCALYTICS)
    {
        [[LocalyticsSession sharedLocalyticsSession] close];
        [[LocalyticsSession sharedLocalyticsSession] upload];
    }
}

- (void)dealloc
{
    [_window release];
    self.mainController = nil;
    [super dealloc];
}

@end
