//
//  BasicExampleAppDelegate.m
//  Google Analytics iPhone SDK.
//
//  Copyright 2009 Google Inc. All rights reserved.
//

#import "BasicExampleAppDelegate.h"

#import "GANTracker.h"

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 10;

@implementation BasicExampleAppDelegate

@synthesize window = window_;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  // **************************************************************************
  // PLEASE REPLACE WITH YOUR ACCOUNT DETAILS.
  // **************************************************************************
  [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-0000000-1"
                                         dispatchPeriod:kGANDispatchPeriodSec
                                               delegate:nil];
  NSError *error;
  if (![[GANTracker sharedTracker] trackEvent:@"my_category"
                                       action:@"my_action"
                                        label:@"my_label"
                                        value:-1
                                    withError:&error]) {
    // Handle error here
  }

  if (![[GANTracker sharedTracker] trackPageview:@"/app_entry_point"
                                       withError:&error]) {
    // Handle error here
  }

  [window_ makeKeyAndVisible];
}

- (void)dealloc {
  [[GANTracker sharedTracker] stopTracker];
  [window_ release];
  [super dealloc];
}

@end
