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


#import "MatchState.h"


static const int kRPSOnTheClockTimeout = 10;
static const int kRPSInactivityWarningTimeout = 20;
static const int kRPSInactivityTimeout = 30;


@interface MatchState ()

@property (nonatomic, retain) NSTimer *localTimer;
@property (nonatomic, retain) NSTimer *remoteTimer;

@property (nonatomic, copy, readwrite) NSDate *startedAt;
@property (nonatomic, copy, readwrite) NSData *endedAt;

@end


@implementation MatchState

@synthesize delegate;
@synthesize setNo, totalThrows;
@synthesize localSetsWon, remoteSetsWon;
@synthesize localThrowNext, remoteThrowNext;
@synthesize localTimeSinceLastThrow, remoteTimeSinceLastThrow;
@synthesize outcome;
@synthesize localTimer, remoteTimer;
@synthesize startedAt, endedAt;


- (id)init {
    if ((self = [super init])) {
        self.remoteTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self
                                                          selector:@selector(checkRemoteActivity)
                                                          userInfo:nil
                                                           repeats:YES];

        self.localTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(checkLocalActivity)
                                                         userInfo:nil
                                                          repeats:YES];

        self.startedAt = [NSDate date];

        totalThrows = 0;
        setNo = 0;
    }

    return self;
}

- (void)dealloc {
    [localTimer invalidate];
    [remoteTimer invalidate];

    [super dealloc];
}

- (MatchOutcome)determineOutcomeForNextThrow {
    NSAssert(outcome == kRPSMatchOutcomeNone, @"match has already ended!");

    NSAssert(localThrowNext  != kRPSThrowNone, @"local player throw unset!");
    NSAssert(remoteThrowNext != kRPSThrowNone, @"remote player throw unset!");

    totalThrows++;

    if ((localThrowNext == kRPSThrowRock     && remoteThrowNext == kRPSThrowScissors) ||
        (localThrowNext == kRPSThrowPaper    && remoteThrowNext == kRPSThrowRock) ||
        (localThrowNext == kRPSThrowScissors && remoteThrowNext == kRPSThrowPaper)) {

        if (++localSetScores[setNo] == 2) {
            if (++localSetsWon == 2) {
                outcome = kRPSMatchOutcomeLocalWin;
                self.endedAt = [NSDate date];
                return outcome;
            }

            setNo++;
        }
    } else if ((localThrowNext == kRPSThrowScissors && remoteThrowNext == kRPSThrowRock) ||
               (localThrowNext == kRPSThrowRock     && remoteThrowNext == kRPSThrowPaper) ||
               (localThrowNext == kRPSThrowPaper    && remoteThrowNext == kRPSThrowScissors)) {

        if (++remoteSetScores[setNo] == 2) {
            if (++remoteSetsWon == 2) {
                outcome = kRPSMatchOutcomeRemoteWin;
                self.endedAt = [NSDate date];
                return outcome;
            }

            setNo++;
        }
    }

    localThrowNext = remoteThrowNext = kRPSThrowNone;
    localTimeSinceLastThrow = remoteTimeSinceLastThrow = 0;

    return kRPSMatchOutcomeNone;
}

- (void)setLocalThrowNext:(RPSThrowType)type {
    NSAssert(outcome == kRPSMatchOutcomeNone, @"match has already ended!");

    localThrowNext = type;

    if (localPlayerOnTheClock) {
        localPlayerOnTheClock = NO;
        [delegate localPlayerWentOffTheClock];
    }

    localTimeSinceLastThrow = 0;
}

- (void)setRemoteThrowNext:(RPSThrowType)type {
    NSAssert(outcome == kRPSMatchOutcomeNone, @"match has already ended!");

    remoteThrowNext = type;

    if (remotePlayerOnTheClock) {
        remotePlayerOnTheClock = NO;
        [delegate remotePlayerWentOffTheClock];
    }

    remoteTimeSinceLastThrow = 0;
}

- (void)checkLocalActivity {
    if (localThrowNext == kRPSThrowNone) {
        if (++localTimeSinceLastThrow == kRPSOnTheClockTimeout) {
            localPlayerOnTheClock = YES;
            [delegate localPlayerWentOnTheClock];
        } else if (localTimeSinceLastThrow == kRPSInactivityWarningTimeout) {
            [delegate localPlayerMightForfeitOnInactivity];
        } else if (localTimeSinceLastThrow == kRPSInactivityTimeout) {
            [delegate localPlayerForfeitsOnInactivity];
            outcome = kRPSMatchOutcomeLocalForfeit;
            self.endedAt = [NSDate date];
        }
    }
}

- (void)checkRemoteActivity {
    if (remoteThrowNext == kRPSThrowNone) {
        if (++remoteTimeSinceLastThrow == kRPSOnTheClockTimeout) {
            remotePlayerOnTheClock = YES;
            [delegate remotePlayerWentOnTheClock];
        } else if (remoteTimeSinceLastThrow == kRPSInactivityWarningTimeout) {
            [delegate remotePlayerMightForfeitOnInactivity];
        } else if (remoteTimeSinceLastThrow == kRPSInactivityTimeout) {
            [delegate remotePlayerForfeitsOnInactivity];
            outcome = kRPSMatchOutcomeRemoteForfeit;
            self.endedAt = [NSDate date];
        }
    }
}

- (int)scoreForLocalPlayerSetNo:(int)whichSetNo {
    NSAssert(whichSetNo >= 0 && whichSetNo < 3, @"bad set no");
    return localSetScores[whichSetNo];
}

- (int)scoreForRemotePlayerSetNo:(int)whichSetNo {
    NSAssert(whichSetNo >= 0 && whichSetNo < 3, @"bad set no");
    return remoteSetScores[whichSetNo];
}

@end
