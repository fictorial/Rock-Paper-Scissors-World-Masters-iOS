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


#import "WaitingLayer.h"
#import "GameKitHelper.h"

@implementation WaitingLayer

- (id)init {
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;

        CCLabelTTF *waitingLabel = [CCLabelTTF labelWithString:@"WAITING FOR OPPONENT ..."
                                                    dimensions:CGSizeMake(winSize.width, winSize.height)
                                                     alignment:CCTextAlignmentCenter
                                                      fontName:kRPSSecondaryFontName
                                                      fontSize:kRPSFontSizeMedium];

        waitingLabel.position = ccp(winSize.width/2, kStatusBarHeight);
        [self addChild:waitingLabel z:4 tag:kRPSTagWaitingLabel];

        [CCMenuItemFont setFontName:kRPSPrimaryFontName];
        [CCMenuItemFont setFontSize:kRPSFontSizeMedium];

        CCMenuItemFont *cancelRequest = [CCMenuItemFont itemFromString:@"CANCEL" block:^(id sender) {
            [[GameKitHelper sharedGameKitHelper] cancelMatchmakingRequest];
            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFadeBlack class]
                                                       duration:kRPSTransitionDuration];
        }];

        cancelRequest.color = ccYELLOW;

        CCMenu *backMenu = [CCMenu menuWithItems:cancelRequest, nil];
        backMenu.position = ccp(winSize.width/2, kRPSFontSizeMedium);
        [self addChild:backMenu];
    }
    return self;
}

@end
