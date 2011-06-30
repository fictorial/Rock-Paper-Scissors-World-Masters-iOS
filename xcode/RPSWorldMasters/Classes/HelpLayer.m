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


#import "HelpLayer.h"
#import "BaseScene.h"

@implementation HelpLayer

- (id)init {
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;

        CCSprite *rules = [CCSprite spriteWithFile:NameForPNGImage(@"rules")];
        rules.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:rules];

        [CCMenuItemFont setFontName:kRPSPrimaryFontName];
        [CCMenuItemFont setFontSize:kRPSFontSizeMedium];

        CCMenuItemFont *credits = [CCMenuItemFont itemFromString:@"CREDITS" block:^(id sender) {
            [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:kRPSTransitionDuration
                                                                                      scene:[BaseScene sceneWithLayerClass:@"CreditsLayer"]
                                                                                  withColor:ccBLACK]];
        }];

        CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"BACK" block:^(id sender) {
            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFadeBlack class]
                                                       duration:kRPSTransitionDuration];
        }];

        back.color = ccYELLOW;

        CCMenu *menu = [CCMenu menuWithItems:credits, back, nil];
        [menu alignItemsVertically];
        menu.position = ccp(winSize.width/2, kRPSFontSizeMedium*2);
        [self addChild:menu];

        CCLabelTTF *bestOf = [CCLabelTTF labelWithString:@"2 OF 3 THROWS WINS A SET\n2 OF 3 SETS WINS THE MATCH"
                                              dimensions:CGSizeMake(winSize.width, MAX(kRPSFontSizeSmall*3, winSize.height/10))
                                               alignment:CCTextAlignmentCenter
                                                fontName:kRPSPrimaryFontName
                                                fontSize:kRPSFontSizeSmall];
        bestOf.anchorPoint = ccp(0.5, 1);
        bestOf.position = ccp(winSize.width/2, winSize.height-kStatusBarHeight*1.25);
        [self addChild:bestOf];
    }
    return self;
}

@end
