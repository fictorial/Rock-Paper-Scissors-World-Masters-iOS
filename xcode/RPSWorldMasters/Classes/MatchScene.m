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


#import "MatchScene.h"
#import "BaseScene.h"
#import "MatchController.h"
#import "MainMenuLayer.h"


const float animationDuration = 0.5;
const float kRPSButtonOnOpacity = 255;
const float kRPSButtonOffOpacity = 100;
const float kRPSThrowChoiceMenuPadding = 5;
const float kMessageSlowFlybyDuration = 2;


@interface MatchScene ()
- (void)showControlMenu;
- (void)hideControlMenu;
@end


@implementation MatchScene

@synthesize delegate;

- (void)_setNames {
    NSString *names = [NSString stringWithFormat:@"%@\n%@", remotePlayerName, [GKLocalPlayer localPlayer].alias];
    [(CCLabelTTF *)[self getChildByTag:kRPSTagPlayerNames] setString:names];
}

- (void)setRemotePlayerName:(NSString *)playerName {
    [remotePlayerName release];
    remotePlayerName = [playerName copy];
    [self _setNames];
}

- (BOOL)setLocalPlayerThrowNext:(RPSThrowType)throwWhat {
    MatchState *matchState = [MatchController sharedController].matchState;

    if (matchState.localThrowNext == kRPSThrowNone) {
        matchState.localThrowNext = throwWhat;
        return YES;
    }

    return NO;
}

#pragma mark -
#pragma mark Throw Choice Menu

- (void)setupThrowChoiceMenu {
    CCSprite *rockButtonSprite = [CCSprite spriteWithFile:NameForPNGImage(@"button-rock")];

    rockButton = [CCMenuItemSprite itemFromNormalSprite:rockButtonSprite
                                         selectedSprite:nil
                                                 target:self
                                               selector:@selector(selectRock:)];

    paperButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:NameForPNGImage(@"button-paper")]
                                          selectedSprite:nil
                                                  target:self
                                                selector:@selector(selectPaper:)];

    scissorsButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:NameForPNGImage(@"button-scissors")]
                                             selectedSprite:nil
                                                     target:self
                                                   selector:@selector(selectScissors:)];

    CGSize winSize = [[CCDirector sharedDirector] winSize];

    CCMenu *throwChoiceMenu = [CCMenu menuWithItems:rockButton, paperButton, scissorsButton, nil];
    throwChoiceMenu.anchorPoint = ccp(0.5,0.5);
    [throwChoiceMenu alignItemsHorizontallyWithPadding:3];
    [self addChild:throwChoiceMenu z:3 tag:kRPSTagThrowChoiceMenu];
    throwChoiceMenu.position = ccp(winSize.width/2, winSize.height/2);

    CCLabelTTF *nextThrow = [CCLabelTTF labelWithString:@"READY"
                                               fontName:kRPSPrimaryFontName
                                               fontSize:kRPSFontSizeSmall];
    nextThrow.anchorPoint = ccp(0.5, 1);
    nextThrow.position = ccp(winSize.width/2, winSize.height/2-rockButtonSprite.contentSize.height/2-kRPSThrowChoiceMenuPadding);
    [self addChild:nextThrow z:4 tag:kRPSTagNextThrowLabel];
}

- (void)showThrowChoiceMenu {
    rockButton.scale = paperButton.scale = scissorsButton.scale = 1;
    rockButton.opacity = paperButton.opacity = scissorsButton.opacity = 255;

    CCMenu *throwChoiceMenu = (CCMenu *)[self getChildByTag:kRPSTagThrowChoiceMenu];
    [throwChoiceMenu runAction:[CCFadeIn actionWithDuration:animationDuration]];

    CCLabelTTF *nextThrow = (CCLabelTTF *)[self getChildByTag:kRPSTagNextThrowLabel];
    nextThrow.string = @"READY";
    nextThrow.color = ccWHITE;
    [nextThrow runAction:[CCFadeIn actionWithDuration:animationDuration]];
}

- (void)hideThrowChoiceMenu {
    [rockButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:0]];
    [paperButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:0]];
    [scissorsButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:0]];

    CCLabelTTF *nextThrow = (CCLabelTTF *)[self getChildByTag:kRPSTagNextThrowLabel];
    [nextThrow runAction:[CCFadeOut actionWithDuration:animationDuration]];
}

- (void)selectRock:(id)sender {
    if (![self setLocalPlayerThrowNext:kRPSThrowRock])
        return;

    [rockButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:255]];
    [rockButton runAction:[CCScaleBy actionWithDuration:animationDuration/4 scale:1.1]];
    [paperButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:0]];
    [scissorsButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:0]];

    CCLabelTTF *nextThrow = (CCLabelTTF *)[self getChildByTag:kRPSTagNextThrowLabel];
    nextThrow.string = @"THROW ROCK";
    [nextThrow runAction:[CCFadeIn actionWithDuration:animationDuration]];

    [[SimpleAudioEngine sharedEngine] playEffect:@"menu-choice.caf"];

    [delegate localPlayerSelected:kRPSThrowRock];
}

- (void)selectPaper:(id)sender {
    if (![self setLocalPlayerThrowNext:kRPSThrowPaper])
        return;

    [rockButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:0]];
    [paperButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:255]];
    [paperButton runAction:[CCScaleBy actionWithDuration:animationDuration/4 scale:1.1]];
    [scissorsButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:0]];

    CCLabelTTF *nextThrow = (CCLabelTTF *)[self getChildByTag:kRPSTagNextThrowLabel];
    nextThrow.string = @"THROW PAPER";
    [nextThrow runAction:[CCFadeIn actionWithDuration:animationDuration]];

    [[SimpleAudioEngine sharedEngine] playEffect:@"menu-choice.caf"];

    [delegate localPlayerSelected:kRPSThrowPaper];
}

- (void)selectScissors:(id)sender {
    if (![self setLocalPlayerThrowNext:kRPSThrowScissors])
        return;

    [rockButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:0]];
    [paperButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:0]];
    [scissorsButton runAction:[CCFadeTo actionWithDuration:animationDuration opacity:255]];
    [scissorsButton runAction:[CCScaleBy actionWithDuration:animationDuration/4 scale:1.1]];

    CCLabelTTF *nextThrow = (CCLabelTTF *)[self getChildByTag:kRPSTagNextThrowLabel];
    nextThrow.string = @"THROW SCISSORS";
    [nextThrow runAction:[CCFadeIn actionWithDuration:animationDuration]];

    [[SimpleAudioEngine sharedEngine] playEffect:@"menu-choice.caf"];

    [delegate localPlayerSelected:kRPSThrowScissors];
}

- (void)updateScoreboardFromMatchState {
    MatchController *mpManager = [MatchController sharedController];
    MatchState *matchState = mpManager.matchState;

    if (!matchState)
        return;

    NSString *set1Text = [NSString stringWithFormat:@"%d\n%d",
                          [matchState scoreForRemotePlayerSetNo:0],
                          [matchState scoreForLocalPlayerSetNo:0]];

    NSString *set2Text = [NSString stringWithFormat:@"%d\n%d",
                          [matchState scoreForRemotePlayerSetNo:1],
                          [matchState scoreForLocalPlayerSetNo:1]];

    NSString *set3Text = [NSString stringWithFormat:@"%d\n%d",
                          [matchState scoreForRemotePlayerSetNo:2],
                          [matchState scoreForLocalPlayerSetNo:2]];

    [(CCLabelTTF *)[self getChildByTag:kRPSTagSet1Score] setString:set1Text];
    [(CCLabelTTF *)[self getChildByTag:kRPSTagSet2Score] setString:set2Text];
    [(CCLabelTTF *)[self getChildByTag:kRPSTagSet3Score] setString:set3Text];
}

- (void)maybeRunThrowAnimation {
    MatchController *mpManager = [MatchController sharedController];
    MatchState *matchState = mpManager.matchState;

    if (!matchState || matchState.outcome != kRPSMatchOutcomeNone || runningThrowAnimation)
        return;

    if (matchState.localThrowNext  != kRPSThrowNone &&
        matchState.remoteThrowNext != kRPSThrowNone) {

        runningThrowAnimation = YES;

        [self hideThrowChoiceMenu];

        int localTag  = 0;
        int remoteTag = 0;

        switch (matchState.localThrowNext) {
            case kRPSThrowNone: NSAssert(NO, @"no local throw set!"); break;
            case kRPSThrowRock:     localTag = kRPSTagLocalRock;     break;
            case kRPSThrowPaper:    localTag = kRPSTagLocalPaper;    break;
            case kRPSThrowScissors: localTag = kRPSTagLocalScissors; break;
        }

        switch (matchState.remoteThrowNext) {
            case kRPSThrowNone: NSAssert(NO, @"no remote throw set!"); break;
            case kRPSThrowRock:     remoteTag = kRPSTagRemoteRock;     break;
            case kRPSThrowPaper:    remoteTag = kRPSTagRemotePaper;    break;
            case kRPSThrowScissors: remoteTag = kRPSTagRemoteScissors; break;
        }

        CGSize winSize = [[CCDirector sharedDirector] winSize];

        [self getChildByTag:kRPSTagRemoteRock].visible =
        [self getChildByTag:kRPSTagRemotePaper].visible =
        [self getChildByTag:kRPSTagRemoteScissors].visible =
        [self getChildByTag:kRPSTagLocalRock].visible =
        [self getChildByTag:kRPSTagLocalPaper].visible =
        [self getChildByTag:kRPSTagLocalScissors].visible = NO;

        CCSprite *remoteSprite = (CCSprite *)[self getChildByTag:remoteTag];
        CCSprite *localSprite  = (CCSprite *)[self getChildByTag:localTag];

        NSString *message = nil;

        if ((localTag == kRPSTagLocalRock     && remoteTag == kRPSTagRemoteScissors) ||
            (localTag == kRPSTagLocalScissors && remoteTag == kRPSTagRemoteRock)) {
            message = @"ROCK CRUSHES SCISSORS";
            [[SimpleAudioEngine sharedEngine] playEffect:@"thud.caf"];
        } else if ((localTag == kRPSTagLocalScissors && remoteTag == kRPSTagRemotePaper) ||
                   (localTag == kRPSTagLocalPaper    && remoteTag == kRPSTagRemoteScissors)) {
            message = @"SCISSORS CUTS PAPER";
            [[SimpleAudioEngine sharedEngine] playEffect:@"scissors.caf"];
        } else if ((localTag == kRPSTagLocalRock  && remoteTag == kRPSTagRemotePaper) ||
                   (localTag == kRPSTagLocalPaper && remoteTag == kRPSTagRemoteRock)) {
            message = @"PAPER COVERS ROCK";
            [[SimpleAudioEngine sharedEngine] playEffect:@"paper.caf"];
        }

        [self setMessage:message];

        const float kKeepHandsOnScreenDuration = kMessageSlowFlybyDuration;  // seconds

        remoteSprite.visible  = YES;
        remoteSprite.position = ccp(0, 2*winSize.height);
        [remoteSprite runAction:[CCSequence actions:
                                 [CCMoveTo actionWithDuration:animationDuration/2 position:ccp(0,winSize.height)],
                                 [CCDelayTime actionWithDuration:kKeepHandsOnScreenDuration],
                                 [CCMoveTo actionWithDuration:animationDuration/2 position:ccp(0, 2*winSize.height)],
                                 nil]];

        localSprite.visible  = YES;
        localSprite.position = ccp(winSize.width*2, -winSize.height);
        [localSprite runAction:[CCSequence actions:
                                [CCMoveTo actionWithDuration:animationDuration/2 position:ccp(winSize.width,0)],
                                [CCCallBlock actionWithBlock:
                                 ^() {
                                     [delegate handAnimationsDidFinish];
                                 }],
                                [CCDelayTime actionWithDuration:kKeepHandsOnScreenDuration],
                                [CCMoveTo actionWithDuration:animationDuration/2 position:ccp(winSize.width*2, -winSize.height)],
                                [CCCallBlock actionWithBlock:
                                 ^() {
                                     if (matchState.outcome == kRPSMatchOutcomeNone)
                                         [self showThrowChoiceMenu];

                                     runningThrowAnimation = NO;
                                 }],
                                nil]];
    }
}

#pragma mark -
#pragma mark Clock Handling

- (void)setupOnTheClockWarnings {
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    CCSprite *remoteOnTheClockSprite = [CCSprite spriteWithFile:NameForPNGImage(@"clock")];
    CCSprite *localOnTheClockSprite = [CCSprite spriteWithFile:NameForPNGImage(@"clock")];

    [self addChild:remoteOnTheClockSprite z:99 tag:kRPSTagRemotePlayerClock];
    [self addChild:localOnTheClockSprite z:99 tag:kRPSTagLocalPlayerClock];

    remoteOnTheClockSprite.opacity = localOnTheClockSprite.opacity = kRPSLowOpacity;

    remoteOnTheClockSprite.position = ccp(remoteOnTheClockSprite.contentSize.width/2,
                                          winSize.height-kStatusBarHeight-remoteOnTheClockSprite.contentSize.height/2);

    localOnTheClockSprite.position = ccp(winSize.width-localOnTheClockSprite.contentSize.width/2,
                                         localOnTheClockSprite.contentSize.height/2);

    localOnTheClockSprite.visible = remoteOnTheClockSprite.visible = NO;
}

- (void)localPlayerWentOnTheClock {
    CCSprite *localClock = (CCSprite *)[self getChildByTag:kRPSTagLocalPlayerClock];
    localClock.visible = YES;
    localClock.color = ccYELLOW;
    [localClock runAction:[CCRepeatForever actionWithAction:
                           [CCSequence actions:
                            [CCScaleBy actionWithDuration:0.4 scale:1/1.2],
                            [CCScaleBy actionWithDuration:0.4 scale:1.2],
                            nil]]];
}

- (void)localPlayerWentOffTheClock {
    CCSprite *localClock = (CCSprite *)[self getChildByTag:kRPSTagLocalPlayerClock];
    [localClock stopAllActions];
    localClock.visible = NO;
    localClock.scale = 1.0;
    localClock.color = ccWHITE;
}

- (void)remotePlayerWentOnTheClock {
    CCSprite *remoteClock = (CCSprite *)[self getChildByTag:kRPSTagRemotePlayerClock];
    remoteClock.visible = YES;
    remoteClock.color = ccYELLOW;
    [remoteClock runAction:[CCRepeatForever actionWithAction:
                            [CCSequence actions:
                             [CCScaleBy actionWithDuration:0.4 scale:1/1.2],
                             [CCScaleBy actionWithDuration:0.4 scale:1.2],
                             nil]]];
}

- (void)remotePlayerWentOffTheClock {
    CCSprite *remoteClock = (CCSprite *)[self getChildByTag:kRPSTagRemotePlayerClock];
    [remoteClock stopAllActions];
    remoteClock.visible = NO;
    remoteClock.scale = 1.0;
}

- (void)localPlayerMightForfeitOnInactivity {
    CCSprite *localClock = (CCSprite *)[self getChildByTag:kRPSTagLocalPlayerClock];
    [localClock stopAllActions];
    localClock.visible = YES;
    localClock.scale = 1.0;
    localClock.color = ccRED;
    [localClock runAction:[CCRepeatForever actionWithAction:
                            [CCSequence actions:
                             [CCScaleBy actionWithDuration:0.2 scale:1/1.2],
                             [CCScaleBy actionWithDuration:0.2 scale:1.2],
                             nil]]];

    [[SimpleAudioEngine sharedEngine] playEffect:@"warning.caf"];
}

- (void)remotePlayerMightForfeitOnInactivity {
    CCSprite *remoteClock = (CCSprite *) [self getChildByTag:kRPSTagRemotePlayerClock];
    [remoteClock stopAllActions];
    remoteClock.visible = YES;
    remoteClock.scale = 1.0;
    remoteClock.color = ccRED;
    [remoteClock runAction:[CCRepeatForever actionWithAction:
                            [CCSequence actions:
                             [CCScaleBy actionWithDuration:0.2 scale:1/1.2],
                             [CCScaleBy actionWithDuration:0.2 scale:1.2],
                             nil]]];
}

#pragma mark -
#pragma mark Scoreboard

//  REMOTEPLAYER  0  1  2
//   LOCALPLAYER  1  2  1

- (void)setupScoreboard {
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    // Names of players (aliases)

    CCLabelTTF *playerNames = [CCLabelTTF labelWithString:@"" // Set later after GameCenter tells us.
                                               dimensions:CGSizeMake(winSize.width*0.75, kRPSFontSizeMedium*3)
                                                alignment:CCTextAlignmentRight
                                                 fontName:kRPSScoreboardFontName
                                                 fontSize:kRPSFontSizeSmall];
    playerNames.color = kRPSColorPlayer;
    playerNames.anchorPoint = ccp(1,1);
    playerNames.position = ccp(winSize.width*0.75, winSize.height-kStatusBarHeight);
    [self addChild:playerNames z:0 tag:kRPSTagPlayerNames];

    const float scoreWidth = (winSize.width*0.20+10)/3;    // 3 sets
    const float scoreSet1X = (winSize.width*0.80);
    const float scoreSet2X = (winSize.width*0.80+scoreWidth);
    const float scoreSet3X = (winSize.width*0.80+scoreWidth*2);

    // Set 1

    CCLabelTTF *set1 = [CCLabelTTF labelWithString:@"0\n0"
                                        dimensions:CGSizeMake(scoreWidth, kRPSFontSizeSmall*3)
                                         alignment:CCTextAlignmentCenter
                                          fontName:kRPSScoreboardFontName
                                          fontSize:kRPSFontSizeSmall];
    set1.color = ccWHITE;
    set1.anchorPoint = ccp(0.5,1);
    set1.position = ccp(scoreSet1X, winSize.height-kStatusBarHeight);
    [self addChild:set1 z:1 tag:kRPSTagSet1Score];

    // Set 2

    CCLabelTTF *set2 = [CCLabelTTF labelWithString:@"0\n0"
                                        dimensions:CGSizeMake(scoreWidth, kRPSFontSizeSmall*3)
                                         alignment:CCTextAlignmentCenter
                                          fontName:kRPSScoreboardFontName
                                          fontSize:kRPSFontSizeSmall];
    set2.color = ccWHITE;
    set2.anchorPoint = ccp(0.5,1);
    set2.position = ccp(scoreSet2X, winSize.height-kStatusBarHeight);
    [self addChild:set2 z:1 tag:kRPSTagSet2Score];

    // Set 3

    CCLabelTTF *set3 = [CCLabelTTF labelWithString:@"0\n0"
                                        dimensions:CGSizeMake(scoreWidth, kRPSFontSizeSmall*3)
                                         alignment:CCTextAlignmentCenter
                                          fontName:kRPSScoreboardFontName
                                          fontSize:kRPSFontSizeSmall];
    set3.color = ccWHITE;
    set3.anchorPoint = ccp(0.5,1);
    set3.position = ccp(scoreSet3X, winSize.height-kStatusBarHeight);
    [self addChild:set3 z:1 tag:kRPSTagSet3Score];
}

#pragma mark -
#pragma mark Hands

- (void)setupRemotePlayerHandSprites {
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    CCSprite *remoteRock     = [CCSprite spriteWithFile:NameForPNGImage(@"remote_rock")];
    CCSprite *remotePaper    = [CCSprite spriteWithFile:NameForPNGImage(@"remote_paper")];
    CCSprite *remoteScissors = [CCSprite spriteWithFile:NameForPNGImage(@"remote_scissors")];

    [self addChild:remoteRock z:2 tag:kRPSTagRemoteRock];
    [self addChild:remotePaper z:2 tag:kRPSTagRemotePaper];
    [self addChild:remoteScissors z:2 tag:kRPSTagRemoteScissors];

    remoteRock.position = remotePaper.position = remoteScissors.position = ccp(0, winSize.height);
    remoteRock.anchorPoint = remotePaper.anchorPoint = remoteScissors.anchorPoint = ccp(0,1);
    remoteRock.visible = remotePaper.visible = remoteScissors.visible = NO;
    remoteRock.color = remotePaper.color = remoteScissors.color = kRPSColorPlayerHand;
}

- (void)setupLocalPlayerHandSprites {
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    CCSprite *localRock = [CCSprite spriteWithFile:NameForPNGImage(@"local_rock")];
    CCSprite *localPaper = [CCSprite spriteWithFile:NameForPNGImage(@"local_paper")];
    CCSprite *localScissors = [CCSprite spriteWithFile:NameForPNGImage(@"local_scissors")];

    [self addChild:localRock z:2 tag:kRPSTagLocalRock];
    [self addChild:localPaper z:2 tag:kRPSTagLocalPaper];
    [self addChild:localScissors z:2 tag:kRPSTagLocalScissors];

    localRock.anchorPoint = localPaper.anchorPoint = localScissors.anchorPoint = ccp(1,0);
    localRock.position = localPaper.position = localScissors.position = ccp(winSize.width, 0);
    localRock.visible = localPaper.visible = localScissors.visible = NO;
    localRock.color = localPaper.color = localScissors.color = kRPSColorPlayerHand;
}

#pragma mark -
#pragma mark Control Menu

#define kRPSAlertConfirmForfeit 0xDEADBEEF

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kRPSAlertConfirmForfeit && buttonIndex == 1) {
        [[MatchController sharedController] forfeitMatch:NO];
        [MainMenuLayer replaceCurrentScene];
    }
}

- (void)setupControlMenu {
    CCSprite *settingsSprite = [CCSprite spriteWithFile:NameForPNGImage(@"button-settings")];
    CCMenuItemSprite *settingsItem = [CCMenuItemSprite itemFromNormalSprite:settingsSprite
                                                             selectedSprite:nil
                                                                      block:^(id sender) {
                                                                          [[CCDirector sharedDirector] pushScene:
                                                                           [CCTransitionFade transitionWithDuration:kRPSTransitionDuration
                                                                                                              scene:[BaseScene sceneWithLayerClass:@"SettingsLayer"]
                                                                                                          withColor:ccBLACK]];
                                                                      }];

    CCSprite *helpSprite = [CCSprite spriteWithFile:NameForPNGImage(@"button-help")];
    CCMenuItemSprite *helpItem = [CCMenuItemSprite itemFromNormalSprite:helpSprite
                                                         selectedSprite:nil
                                                                  block:^(id sender) {
                                                                      [[CCDirector sharedDirector] pushScene:
                                                                       [CCTransitionFade transitionWithDuration:kRPSTransitionDuration
                                                                                                          scene:[BaseScene sceneWithLayerClass:@"HelpLayer"]
                                                                                                      withColor:ccBLACK]];
                                                                  }];

    CCSprite *forfeitSprite = [CCSprite spriteWithFile:NameForPNGImage(@"button-forfeit")];
    CCMenuItemSprite *forfeitItem = [CCMenuItemSprite itemFromNormalSprite:forfeitSprite
                                                            selectedSprite:nil
                                                                     block:^(id sender) {
                                                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                                                                                         message:@"Are you sure you want to resign the current match?"
                                                                                                                        delegate:self
                                                                                                               cancelButtonTitle:@"Cancel"
                                                                                                               otherButtonTitles:@"OK", nil];
                                                                         alert.tag = kRPSAlertConfirmForfeit;
                                                                         [alert show];
                                                                         [alert release];
                                                                     }];

    settingsSprite.opacity = helpSprite.opacity = forfeitSprite.opacity = kRPSLowOpacity;

    const int kControlMenuPadding = 10;
    CCMenu *controlMenu = [CCMenu menuWithItems:settingsItem, helpItem, forfeitItem, nil];
    controlMenu.position = ccp((settingsItem.contentSize.width+helpItem.contentSize.width+forfeitItem.contentSize.width+kControlMenuPadding*2)/2,
                               settingsSprite.contentSize.height/2);
    [controlMenu alignItemsHorizontallyWithPadding:kControlMenuPadding];
    [self addChild:controlMenu z:3 tag:kRPSTagControlMenu];
}

- (void)showControlMenu {
    CCMenu *controlMenu = (CCMenu *)[self getChildByTag:kRPSTagControlMenu];
    [controlMenu runAction:[CCFadeIn actionWithDuration:animationDuration]];
}

- (void)hideControlMenu {
    CCMenu *controlMenu = (CCMenu *)[self getChildByTag:kRPSTagControlMenu];
    [controlMenu runAction:[CCFadeOut actionWithDuration:animationDuration]];
}

#pragma mark -
#pragma mark misc

- (void)setupMessageLabel {
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    CCLabelTTF *messageLabel = [CCLabelTTF labelWithString:@""
                                                dimensions:CGSizeMake(winSize.width, kRPSFontSizeMedium*3)
                                                 alignment:CCTextAlignmentCenter
                                                  fontName:kRPSPrimaryFontName
                                                  fontSize:kRPSFontSizeMedium];

    [self addChild:messageLabel z:4 tag:kRPSTagMessageLabel];
}

- (void)setMessage:(NSString *)message {
    [self hideThrowChoiceMenu];
    [self hideControlMenu];

    CCLabelTTF *messageLabel = (CCLabelTTF *)[self getChildByTag:kRPSTagMessageLabel];
    NSAssert(messageLabel != nil, @"missing message label");

    CGSize winSize = [[CCDirector sharedDirector] winSize];

    [messageLabel stopAllActions];

    messageLabel.string = message;
    messageLabel.position = ccp(-winSize.width*2, winSize.height/2-kStatusBarHeight);
    [messageLabel runAction:[CCSequence actions:
                             [CCMoveTo actionWithDuration:animationDuration position:ccp(winSize.width/2-25, winSize.height/2-kStatusBarHeight)],
                             [CCMoveBy actionWithDuration:kMessageSlowFlybyDuration position:ccp(50, 0)],
                             [CCMoveTo actionWithDuration:animationDuration position:ccp(winSize.width*2, winSize.height/2-kStatusBarHeight)],
                             [CCCallBlock actionWithBlock:^() { [self showControlMenu]; }],
                             nil]];
}

#pragma mark -
#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        GKMatch *match = [GameKitHelper sharedGameKitHelper].currentMatch;
        NSAssert(match != nil, @"missing expected match");

        [self setupThrowChoiceMenu];
        [self setupScoreboard];
        [self setupRemotePlayerHandSprites];
        [self setupLocalPlayerHandSprites];
        [self setupControlMenu];
        [self setupMessageLabel];
        [self setupOnTheClockWarnings];

        [[SimpleAudioEngine sharedEngine] playEffect:@"match-start.caf"];

        [self schedule:@selector(maybeRunThrowAnimation) interval:1];
    }

    return self;
}

- (void)dealloc {
    self.remotePlayerName = nil;
    [super dealloc];
}

@end
