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


#import "BaseScene.h"


@protocol MatchSceneDelegate

- (void)localPlayerSelected:(RPSThrowType)throwType;
- (void)handAnimationsDidFinish;

@end


// A new match scene is created with each new match started.

@interface MatchScene : BaseScene <UIAlertViewDelegate> {
    CCMenuItemSprite *rockButton;
    CCMenuItemSprite *paperButton;
    CCMenuItemSprite *scissorsButton;

    BOOL runningThrowAnimation;

    NSString *remotePlayerName;

    id<MatchSceneDelegate> delegate;
}


@property (nonatomic, assign) id<MatchSceneDelegate> delegate;


- (void)setRemotePlayerName:(NSString *)playerName;
- (void)updateScoreboardFromMatchState;
- (void)setMessage:(NSString *)message;

- (void)localPlayerWentOnTheClock;
- (void)localPlayerWentOffTheClock;

- (void)remotePlayerWentOnTheClock;
- (void)remotePlayerWentOffTheClock;

- (void)localPlayerMightForfeitOnInactivity;
- (void)remotePlayerMightForfeitOnInactivity;


@end
