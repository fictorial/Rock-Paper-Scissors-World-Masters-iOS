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



typedef enum {
    kRPSMatchOutcomeNone,
    kRPSMatchOutcomeLocalWin,
    kRPSMatchOutcomeLocalForfeit,
    kRPSMatchOutcomeRemoteWin,
    kRPSMatchOutcomeRemoteForfeit,
} MatchOutcome;


@protocol MatchStateDelegate

// Players must make throws in a timely fashion.
// If they do not, they "go on the clock" (after N seconds).
// If they do not make a throw after N*2 seconds, they forfeit the match.
// If they do make a throw while on the clock, they come off the clock.
// Inactivity timeouts are per throw.

- (void)localPlayerWentOnTheClock;
- (void)localPlayerWentOffTheClock;
- (void)localPlayerForfeitsOnInactivity;
- (void)localPlayerMightForfeitOnInactivity;

- (void)remotePlayerWentOnTheClock;
- (void)remotePlayerWentOffTheClock;
- (void)remotePlayerForfeitsOnInactivity;
- (void)remotePlayerMightForfeitOnInactivity;

@end


// A new match state is created with each new match started.

@interface MatchState : NSObject {
    id<MatchStateDelegate> delegate;

    int setNo;
    int totalThrows;

    int localSetsWon;
    int remoteSetsWon;

    int localSetScores[3];
    int remoteSetScores[3];

    MatchOutcome outcome;

    RPSThrowType localThrowNext;
    RPSThrowType remoteThrowNext;

    int localTimeSinceLastThrow;
    int remoteTimeSinceLastThrow;

    BOOL localPlayerOnTheClock;
    BOOL remotePlayerOnTheClock;

    NSTimer *localTimer;
    NSTimer *remoteTimer;

    NSDate *startedAt;
    NSData *endedAt;
}


@property (nonatomic, assign) id<MatchStateDelegate> delegate;

@property (nonatomic, readonly) int setNo;
@property (nonatomic, readonly) int totalThrows;

@property (nonatomic, readonly) int localSetsWon;
@property (nonatomic, readonly) int remoteSetsWon;

@property (nonatomic, assign) MatchOutcome outcome;

@property (nonatomic, assign) RPSThrowType localThrowNext;
@property (nonatomic, assign) RPSThrowType remoteThrowNext;

@property (nonatomic, readonly) int localTimeSinceLastThrow;
@property (nonatomic, readonly) int remoteTimeSinceLastThrow;

@property (nonatomic, copy, readonly) NSDate *startedAt;
@property (nonatomic, copy, readonly) NSData *endedAt;


- (int)scoreForLocalPlayerSetNo:(int)whichSetNo;
- (int)scoreForRemotePlayerSetNo:(int)whichSetNo;

// Set localThrowNext, remoteThrowNext as throws are received.
// Call this to determine what the outcome of the match is based on the given throws.

- (MatchOutcome)determineOutcomeForNextThrow;

@end
