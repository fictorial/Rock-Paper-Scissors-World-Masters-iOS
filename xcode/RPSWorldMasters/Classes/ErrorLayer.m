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


#import "ErrorLayer.h"

@implementation ErrorLayer

- (id)init {
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;

        CCSprite *dudeError = [CCSprite spriteWithFile:@"dude_error.png"];
        dudeError.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:dudeError];

        [CCMenuItemFont setFontName:kRPSPrimaryFontName];
        [CCMenuItemFont setFontSize:kRPSFontSizeMedium];

        CCMenuItemFont *retry = [CCMenuItemFont itemFromString:@"RETRY" block:
                                 ^(id sender) {
                                     [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
                                     [[CCDirector sharedDirector] popSceneWithTransition:
                                      [CCTransitionFadeBlack class] duration:kRPSTransitionDuration];
                                 }];

        CCMenu *menu = [CCMenu menuWithItems:retry, nil];
        menu.position = ccp(winSize.width/2, retry.contentSize.height);
        [self addChild:menu];

        [[SimpleAudioEngine sharedEngine] playEffect:@"error.caf"];
    }
    return self;
}

@end
