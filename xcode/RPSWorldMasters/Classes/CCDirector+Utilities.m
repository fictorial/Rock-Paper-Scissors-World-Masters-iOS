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


#import "CCDirector+Utilities.h"

@implementation CCDirector (Utilities)

-(void) popSceneWithTransition: (Class)transitionClass duration:(ccTime)t {
    NSAssert( runningScene_ != nil, @"A running Scene is needed");

    [scenesStack_ removeLastObject];
    NSUInteger c = [scenesStack_ count];
    if( c == 0 ) {
        [self end];
    } else {
        CCScene* scene = [transitionClass transitionWithDuration:t scene:[scenesStack_ objectAtIndex:c-1]];
        [scenesStack_ replaceObjectAtIndex:c-1 withObject:scene];
        nextScene_ = scene;
    }
}

@end

@implementation CCTransitionFadeBlack

+(id)transitionWithDuration:(ccTime)duration scene:(CCScene*)scene {
    return [CCTransitionFade transitionWithDuration:duration scene:scene withColor:ccBLACK];
}

@end
