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


#import "SettingsLayer.h"

static NSString * const kRPSDefaultKeySoundVolume = @"soundVolume";
static NSString * const kRPSDefaultKeyPumps = @"pumps";

static UISlider *soundVolumeSlider = nil;

@implementation SettingsLayer

- (id)init {
    if ((self = [super init])) {
        [[NSUserDefaults standardUserDefaults] registerDefaults:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithFloat:0.75], kRPSDefaultKeySoundVolume,
          nil]];

        [CCMenuItemFont setFontName:kRPSPrimaryFontName];
        [CCMenuItemFont setFontSize:kRPSFontSizeMedium];

        soundVolume = [CCMenuItemFont itemFromString:@"SOUND VOLUME"];
        soundVolume.disabledColor = ccc3(255,255,255);
        [soundVolume setIsEnabled:NO];

        CGSize winSize = [[CCDirector sharedDirector] winSize];

        menu = [CCMenu menuWithItems:soundVolume, nil];
        [menu alignItemsVertically];
        menu.position = ccp(winSize.width/2, winSize.height/2+kRPSFontSizeMedium);
        [self addChild:menu];

        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"BACK" block:^(id sender) {
            [soundVolumeSlider removeFromSuperview];

            [[NSUserDefaults standardUserDefaults] synchronize];

            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFadeBlack class]
                                                       duration:kRPSTransitionDuration];
        }];

        back.color = ccYELLOW;

        CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = ccp(winSize.width/2, kRPSFontSizeMedium);
        [self addChild:backMenu];
    }

    return self;
}

- (void)addVolumeSlider {
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    [SimpleAudioEngine sharedEngine].effectsVolume = [[NSUserDefaults standardUserDefaults] floatForKey:kRPSDefaultKeySoundVolume];

    soundVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(winSize.width/2-winSize.width/4,
                                                                   winSize.height-menu.position.y+kRPSFontSizeMedium*1.5,
                                                                   winSize.width/2,
                                                                   kRPSFontSizeMedium)];

    [soundVolumeSlider addTarget:self action:@selector(soundVolumeChanged:) forControlEvents:UIControlEventValueChanged];
    soundVolumeSlider.backgroundColor = [UIColor clearColor];
    soundVolumeSlider.minimumValue = 0.0f;
    soundVolumeSlider.maximumValue = 1.0f;      // as per SimpleAudioEngine docs
    soundVolumeSlider.continuous = YES;
    soundVolumeSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:kRPSDefaultKeySoundVolume];
    soundVolumeSlider.tag = kRPSTagVolumeSlider;

    [[[[CCDirector sharedDirector] openGLView] window] addSubview:soundVolumeSlider];
}

- (void)onEnter {
    [self performSelector:@selector(addVolumeSlider) withObject:nil afterDelay:kRPSTransitionDuration];
    [super onEnter];
}

- (void)soundVolumeChanged:(id)sender {
    float value = soundVolumeSlider.value;
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:kRPSDefaultKeySoundVolume];
    [SimpleAudioEngine sharedEngine].effectsVolume = value;

    NSString *valueDesc = [NSString stringWithFormat:@"%d", roundf(value)];
    GAN_TRACK_EVENT(@"soundVolume", valueDesc);
}

@end
