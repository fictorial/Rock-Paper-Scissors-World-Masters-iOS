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


#import "CreditsLayer.h"
#import "HelpLayer.h"

@implementation CreditsLayer

- (id)init {
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;

        [CCMenuItemFont setFontName:kRPSPrimaryFontName];
        [CCMenuItemFont setFontSize:kRPSFontSizeMedium];

        CCLabelTTF *madeBy = [CCLabelTTF labelWithString:@"MADE BY FICTORIAL"
                                              dimensions:CGSizeMake(winSize.width, kRPSFontSizeMedium)
                                               alignment:CCTextAlignmentCenter
                                                fontName:kRPSPrimaryFontName
                                                fontSize:kRPSFontSizeMedium];

        madeBy.anchorPoint = ccp(0.5,1);
        madeBy.position = ccp(winSize.width/2, winSize.height-kStatusBarHeight*2);
        madeBy.color = ccRED;
        madeBy.opacity = 0;
        [self addChild:madeBy];

        CCSprite *theDude = [CCSprite spriteWithFile:NameForPNGImage(@"dude")];
        [self addChild:theDude z:3];
        theDude.position = ccp(0, winSize.height*0.75);
        theDude.scale = 0;

        ccBezierConfig cfg = {
            ccp(winSize.width/2, winSize.height/2),
            ccp(winSize.width/4, winSize.height/2),
            ccp(winSize.width/3, winSize.height/4)
        };

        [theDude runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:kRPSTransitionDuration],
                            [CCBezierTo actionWithDuration:0.5 bezier:cfg],
                            nil]];

        [theDude runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:kRPSTransitionDuration],
                            [CCScaleTo actionWithDuration:0.5 scale:1],
                            nil]];

        [theDude runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:kRPSTransitionDuration],
                            [CCDelayTime actionWithDuration:1],    // 2nd half of sound has 0.5s of silence before it
                            [CCRotateBy actionWithDuration:0.5 angle:360],
                            [CCCallBlock actionWithBlock:^() { [madeBy runAction:[CCFadeIn actionWithDuration:1]]; }],
                            nil]];

        [self performSelector:@selector(playSound) withObject:nil afterDelay:kRPSTransitionDuration];

        [CCMenuItemFont setFontName:kRPSSecondaryFontName];
        [CCMenuItemFont setFontSize:kRPSFontSizeMedium];

        CCMenuItemFont *url = [CCMenuItemFont itemFromString:@"http://fictorial.com" block:^(id sender) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://fictorial.com"]];
        }];

        url.color = ccGREEN;

        [CCMenuItemFont setFontName:kRPSPrimaryFontName];

        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"BACK" block:^(id sender) {
            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFadeBlack class] duration:kRPSTransitionDuration];
            [[SimpleAudioEngine sharedEngine] stopEffect:soundId];
        }];

        back.color = ccYELLOW;

        CCMenu *menu = [CCMenu menuWithItems:url, back, nil];
        [menu alignItemsVertically];
        [self addChild:menu];

        menu.position = ccp(winSize.width/2, kRPSFontSizeMedium*2);
    }
    return self;
}

- (void)playSound {
    soundId = [[SimpleAudioEngine sharedEngine] playEffect:@"credits.caf"];
}

@end
