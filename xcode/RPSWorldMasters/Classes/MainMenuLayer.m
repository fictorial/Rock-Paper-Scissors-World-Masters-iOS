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


#import "MainMenuLayer.h"
#import "BaseScene.h"
#import "GameKitHelper.h"
#import "MatchScene.h"
#import "MatchController.h"

@implementation MainMenuLayer

- (id)init {
    if ((self = [super init])) {
        [CCMenuItemFont setFontName:kRPSPrimaryFontName];
        [CCMenuItemFont setFontSize:kRPSFontSizeMedium];

        CCMenuItemFont *playNow = [CCMenuItemFont itemFromString:@"PLAY NOW" block:^(id sender) {
            GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
            request.minPlayers = request.maxPlayers = 2;

            GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
            [gkHelper cancelMatchmakingRequest];  // if any
            [gkHelper findMatchForRequest:request];

            [[CCDirector sharedDirector] pushScene:
             [CCTransitionFade transitionWithDuration:kRPSTransitionDuration
                                                scene:[BaseScene sceneWithLayerClass:@"WaitingLayer"]
                                            withColor:ccBLACK]];
        }];

        CCMenuItemFont *challengeFriend = [CCMenuItemFont itemFromString:@"CHALLENGE" block:^(id sender) {
            GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
            request.minPlayers = request.maxPlayers = 2;

            GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
            [gkHelper cancelMatchmakingRequest];  // if any
            [gkHelper showMatchmakerWithRequest:request];

            [[CCDirector sharedDirector] pushScene:
             [CCTransitionFade transitionWithDuration:kRPSTransitionDuration
                                                scene:[BaseScene sceneWithLayerClass:@"WaitingLayer"]
                                            withColor:ccBLACK]];
        }];

        CCMenuItemFont *leaderboards = [CCMenuItemFont itemFromString:@"LEADERBOARD" block:^(id sender) {
            GameKitHelper *gkHelper = [GameKitHelper sharedGameKitHelper];
            [gkHelper showLeaderboard];
        }];

        CCMenuItemFont *settings = [CCMenuItemFont itemFromString:@"SETTINGS" block:^(id sender) {
            [[CCDirector sharedDirector] pushScene:
             [CCTransitionFade transitionWithDuration:kRPSTransitionDuration
                                                scene:[BaseScene sceneWithLayerClass:@"SettingsLayer"]
                                            withColor:ccBLACK]];
        }];

        CCMenuItemFont *help = [CCMenuItemFont itemFromString:@"HELP" block:^(id sender) {
            [[CCDirector sharedDirector] pushScene:
             [CCTransitionFade transitionWithDuration:kRPSTransitionDuration
                                                scene:[BaseScene sceneWithLayerClass:@"HelpLayer"]
                                            withColor:ccBLACK]];
        }];

        mainMenu = [CCMenu menuWithItems:playNow, challengeFriend, leaderboards, settings, help, nil];
        [mainMenu alignItemsVertically];
        [self addChild:mainMenu z:2];


        CGSize winSize = [[CCDirector sharedDirector] winSize];

        CCSprite *remoteRock = [CCSprite spriteWithFile:NameForPNGImage(@"remote_rock")];
        remoteRock.anchorPoint = ccp(0,1);
        remoteRock.position = ccp(-remoteRock.contentSize.width/3.5,
                                  winSize.height-remoteRock.contentSize.height/12);
        remoteRock.rotation = -15;
        [self addChild:remoteRock z:1 tag:kRPSTagRemoteRock];

        CCSprite *remotePaper = [CCSprite spriteWithFile:NameForPNGImage(@"remote_paper")];
        remotePaper.anchorPoint = ccp(0.5,1);
        remotePaper.position = ccp(winSize.width/2+remotePaper.contentSize.width/8,
                                   winSize.height+remotePaper.contentSize.height/8);
        [self addChild:remotePaper z:1 tag:kRPSTagRemotePaper];

        CCSprite *remoteScissors = [CCSprite spriteWithFile:NameForPNGImage(@"remote_scissors")];
        remoteScissors.anchorPoint = ccp(1,1);
        remoteScissors.position = ccp(winSize.width+remoteScissors.contentSize.width/2,
                                      winSize.height-remoteScissors.contentSize.height/6);
        remoteScissors.rotation = 20;
        [self addChild:remoteScissors z:1 tag:kRPSTagRemoteScissors];

        remoteRock.color = remotePaper.color = remoteScissors.color = kRPSColorPlayerHand;

        CCLabelTTF *title = [CCLabelTTF labelWithString:@"RPS WORLD MASTERS"
                                               fontName:kRPSPrimaryFontName
                                               fontSize:kRPSFontSizeMedium];
        title.position = ccp(winSize.width/2, winSize.height*0.17);
        title.color = ccRED;
        [self addChild:title z:99 tag:kRPSTagTitle];
        title.scale = 0;
        title.visible = NO;
        [title runAction:[CCSequence actions:
                          [CCDelayTime actionWithDuration:1.5],
                          [CCShow action],
                          [CCScaleTo actionWithDuration:0.2 scale:1],
                          nil]];

        CCLabelTTF *rps = [CCLabelTTF labelWithString:@"ONLINE ROCK PAPER SCISSORS"
                                             fontName:kRPSPrimaryFontName
                                             fontSize:kRPSFontSizeSmall];
        rps.position = ccp(title.position.x, title.position.y - title.contentSize.height);
        [self addChild:rps z:99 tag:kRPSTagSubtitle];
        rps.opacity = 0;
        [rps runAction:[CCSequence actions:
                        [CCDelayTime actionWithDuration:2],
                        [CCFadeIn actionWithDuration:1],
                        nil]];

        int playersOnline = [MatchController sharedController].playersOnline;

        if (playersOnline > 1) {
            NSString *activityAsString = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:playersOnline]
                                                                          numberStyle:NSNumberFormatterDecimalStyle];

            NSString *activityDesc = [NSString stringWithFormat:@"%@ PLAYERS ONLINE", activityAsString];

            CCLabelTTF *playersOnlineLabel = [CCLabelTTF labelWithString:activityDesc
                                                                fontName:@"Helvetica-Bold"   // just looks good
                                                                fontSize:kRPSFontSizeTiny];
            playersOnlineLabel.position = ccp(rps.position.x, 5);
            [self addChild:playersOnlineLabel z:99 tag:kRPSTagPlayersOnline];
            playersOnlineLabel.opacity = 0;
            playersOnlineLabel.anchorPoint = ccp(0.5,0);
            playersOnlineLabel.color = ccWHITE;
            [playersOnlineLabel runAction:[CCSequence actions:
                                           [CCDelayTime actionWithDuration:2],
                                           [CCFadeTo actionWithDuration:1 opacity:200],
                                           nil]];
        }
    }

    return self;
}

+ (void)replaceCurrentScene {
    CCScene *scene = [BaseScene node];
    scene.tag = kRPSTagSceneMain;

    [scene addChild:[MainMenuLayer node] z:1 tag:kRPSTagLayerMainMenu];

    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFade transitionWithDuration:kRPSTransitionDuration
                                        scene:scene
                                    withColor:ccBLACK]];
}

@end
