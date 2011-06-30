/*
 * Copyright 2011 Fictorial LLC. All Rights Reserved.
 *
 * This file is part of RPS World Masters - Online Rock Paper Scissors.
 *
 * RPS World Masters - Online Rock Paper Scissors is free software: you can
 * redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * RPS World Masters - Online Rock Paper Scissors is distributed in the hope that
 * it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * RPS World Masters - Online Rock Paper Scissors.  If not, see
 * <http://www.gnu.org/licenses/>.
 */


#import "RPSWorldMastersAppDelegate.h"
#import "RootViewController.h"
#import "MatchController.h"
#import "BaseScene.h"

void onUncaughtException(NSException* exception) {
    NSLog(@"UNCAUGHT EXCEPTION! %@", [exception reason]);

#ifdef DEBUG
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uncaught Exception"
                                                    message:[exception reason]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];

    [[NSUserDefaults standardUserDefaults] setObject:[exception reason] forKey:@"PreviousCrashReason"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif

    GAN_TRACK_EVENT_WITH_LABEL(@"crashes", [exception name], [exception reason]);
}

@implementation RPSWorldMastersAppDelegate

@synthesize window;

- (void)showPreviousCrashReason {
    NSString *reason = [[NSUserDefaults standardUserDefaults] objectForKey:@"PreviousCrashReason"];

    if (reason) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Previous Crash Reason"
                                                        message:reason
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];

        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PreviousCrashReason"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationDidFinishLaunching:(UIApplication*)application {
    NSSetUncaughtExceptionHandler(&onUncaughtException);

#ifdef DEBUG
    [self showPreviousCrashReason];
#endif

    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if (![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
        [CCDirector setDirectorType:kCCDirectorTypeDefault];

    CCDirector *director = [CCDirector sharedDirector];

    viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    viewController.wantsFullScreenLayout = YES;

    EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
                                   pixelFormat:kEAGLColorFormatRGB565    // kEAGLColorFormatRGBA8
                                   depthFormat:0];                        // GL_DEPTH_COMPONENT16_OES (for 3d effects)

    [director setOpenGLView:glView];
    [director enableRetinaDisplay:YES];
    [director setAnimationInterval:1.0/30];
    [director setDisplayFPS:NO];

    [viewController setView:glView];
    [window addSubview: viewController.view];
    window.rootViewController = viewController;
    [window makeKeyAndVisible];

    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888]; // RGBA8888, RGBA4444, RGB5_A1, RGB565

    CCScene *initialScene = [BaseScene node];
    CCLabelTTF *loading = [CCLabelTTF labelWithString:@"Authenticating ..." fontName:kRPSSecondaryFontName fontSize:kRPSFontSizeMedium];
    loading.position = ccp(director.winSize.width/2, director.winSize.height/2);
    [initialScene addChild:loading];
    [[CCDirector sharedDirector] runWithScene:initialScene];

    MatchController *matchController = [MatchController sharedController];    // just access it to init
    (void)matchController;

    // While the user is logged into Game Center, lets init the audio engine in the background.
    // It has a really nasty startup cost.

    [self performSelectorInBackground:@selector(initAudio) withObject:nil];

    // Google Analytics
    // https://www.google.com/analytics/reporting/?id=39498972

    [[GANTracker sharedTracker] startTrackerWithAccountID:@"INSERT YOURS HERE" dispatchPeriod:30 delegate:nil];
    GAN_TRACK_PAGEVIEW(@"launch");
}

- (void)initAudio {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];  // just access the object.
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
    [[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    [[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [GameKitHelper sharedGameKitHelper].delegate = nil;

    [[MatchController sharedController] release];

    CCDirector *director = [CCDirector sharedDirector];
    [[director openGLView] removeFromSuperview];
    [viewController release];
    [window release];
    [director end];
    [director release];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
