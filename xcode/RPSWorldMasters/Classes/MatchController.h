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
#import "MatchScene.h"


typedef enum {
    kRPSForfeitReasonResign,
    kRPSForfeitReasonAppTermination,
    kRPSForfeitReasonInactivityTimeout,
} RPSForfeitReason;


typedef enum {
    kRPSPacketTypeThrow   = 0xCAFEBABE,
    kRPSPacketTypeForfeit = 0xDEADBEEF
} PacketType;


typedef struct {
    uint32_t magic;      // packet type
    uint8_t  setNo;      // Which set is this for?
    uint8_t  throwNo;    // Which throw in the set is this for?
    uint8_t  throwType;  // What was thrown? kRPSThrow{Rock,Paper,Scissors}
} PlayerThrowPacket;


typedef struct {
    uint32_t magic;
    uint8_t  reason;     // RPSForfeitReason*
} ForfeitMatchPacket;


@interface MatchController : NSObject <GameKitHelperProtocol, MatchStateDelegate, MatchSceneDelegate> {
    MatchState *matchState;
    MatchScene *matchScene;

    NSTimer *activityChecker;

    int playersOnline;
}


+ (MatchController *)sharedController;
- (void)forfeitMatch:(RPSForfeitReason)why;
- (void)updateLocalPlayerScoreByOne;


@property (nonatomic, retain, readonly) MatchState *matchState;
@property (nonatomic, retain, readonly) MatchScene *matchScene;

@property (nonatomic, readonly) int playersOnline;

@end
